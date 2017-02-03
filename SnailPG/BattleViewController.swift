//
//  BattleViewController.swift
//  SnailPG
//
//  Created by Ben Swanson on 1/12/17.
//  Copyright © 2017 Benjamin Swanson. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseAuth

class BattleViewController: UIViewController {
    
    var target: Monster?
    var loggedInHero: Hero?
    var monsterMaxHealth: Int?
    var battleLog = [BattleCellConfig]()
    
    @IBOutlet weak var battleLogTable: UITableView!
    @IBOutlet weak var heroHealthLabel: UILabel!
    @IBOutlet weak var heroNameLabel: UILabel!
    @IBOutlet weak var monsterNameLabel: UILabel!
    @IBOutlet weak var monsterHealthLabel: UILabel!
    @IBOutlet weak var runButton: UIButton!
    @IBOutlet weak var backToMainButton: UIButton!
    @IBOutlet weak var battleAgainButton: UIButton!
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var attackButton: UIButton!
    @IBOutlet weak var heroHealthSlider: HealthBar!
    @IBOutlet weak var monsterHealthSlider: UISlider!
    @IBOutlet weak var heroManaLabel: UILabel!
    @IBOutlet weak var heroManaSlider: HealthBar!
    
    @IBAction func attackButtonPressed(_ sender: UIButton) {
        // Choose who attacks first
        
        let response = getTurnOrder()
        
        let random = response.0
        
        let heroRange = response.1
        
        if random < Int(heroRange) {
            
            let monsterDead = heroAttacks()
            
            if !monsterDead {
                let _ = monsterAttacks()
            }
            
        } else {
            
            let heroDead = monsterAttacks()
            
            if !heroDead {
                let _ = heroAttacks()
            }
            
        }
        
        update()
        
    }
    
    func getTurnOrder() -> (Int, Double) {
        let total = Int((loggedInHero?.dexterity)!) + (target?.speed)!
        
        let heroRange = round((Double((loggedInHero?.dexterity)!) / Double(total)) * 100.0)
        
        let random = Int(arc4random_uniform(UInt32(100))) + 1
        
        return (random, heroRange)
    }
    
    func monsterAttacks() -> Bool {
        
        let response = target?.attack(loggedInHero!)
        let text = response?.0
        let type = response?.1

        battleLog.append(BattleCellConfig(text: text!, color: type!, image1: #imageLiteral(resourceName: "snailhero2"), image2: loggedInHero?.icon as! UIImage))
        
        return heroIsDead()
    }
    
    func heroAttacks() -> Bool {

        let response = (loggedInHero?.attack(target!))!
        let text = response.0
        let type = response.1
        
        battleLog.append(BattleCellConfig(text: text, color: type, image1: loggedInHero?.icon as! UIImage, image2: #imageLiteral(resourceName: "snailhero2")))
        
        return monsterIsDead()
    }
    
    func heroIsDead() -> Bool {
        if (loggedInHero?.health)! <= 0 {
            ad.saveContext()
            
            //Button visibility
            runButton.isHidden = true
            attackButton.isHidden = true
            backToMainButton.isHidden = true
            restartButton.isHidden = false
            battleAgainButton.isHidden = true
            
            battleLog.append(BattleCellConfig(text: "\((loggedInHero?.name!)!) was defeated.", color: "Defeat", image1: #imageLiteral(resourceName: "snailhero2"), image2: loggedInHero?.icon as! UIImage))
            
            var cleanBackpack = [String]()
            
            for item in loggedInHero?.backpack as! [String] {
                if item == "Revive Potion" {
                    cleanBackpack.append(item)
                }
            }
            
            loggedInHero?.backpack = cleanBackpack as NSObject?
            
            return true
        }
        return false
    }
    
    func monsterIsDead() -> Bool {
        // Monster Health Check
        if (target?.health)! <= 0 {
            ad.saveContext()
            
            runButton.isHidden = true
            attackButton.isHidden = true
            battleAgainButton.isHidden = false
            backToMainButton.isHidden = false
            restartButton.isHidden = true
            
            battleLog.append(BattleCellConfig(text: "\((target?.name)!) was defeated.", color: "Victory", image1: loggedInHero?.icon as! UIImage, image2: #imageLiteral(resourceName: "snailhero2")))
            
            if let goldDrop = target?.gold {
                loggedInHero?.gold += goldDrop
                
                battleLog.append(BattleCellConfig(text: "\((loggedInHero?.name!)!) got \(goldDrop) gold!", color: "Gold", image1: #imageLiteral(resourceName: "snailhero2"), image2: loggedInHero?.icon as! UIImage))
                
            }
            if let itemDrop = target?.drop {
                let bp = loggedInHero?.backpack as! NSMutableArray
                bp.add(itemDrop)
                
                battleLog.append(BattleCellConfig(text: "\((loggedInHero?.name!)!) picked up \(itemDrop)!", color: "Item", image1: #imageLiteral(resourceName: "snailhero2"), image2: loggedInHero?.icon as! UIImage))
                
            }
            // gain EXP when monster is slain
            loggedInHero?.gainsExp(amount: (target?.experience)!)
            
            battleLog.append(BattleCellConfig(text: "\((loggedInHero?.name!)!) gained \((target?.experience)!) experience!", color: "Experience", image1: #imageLiteral(resourceName: "snailhero2"), image2: loggedInHero?.icon as! UIImage))
            
            var potentialAchievement: String?
            
            switch Int((loggedInHero?.victories)!) {
            case 1:
                potentialAchievement = "Won A Battle"
                break
            case 50:
                potentialAchievement = "50 Enemies"
                break
            case 100:
                potentialAchievement = "100 Enemies"
                break
            case 200:
                potentialAchievement = "200 Enemies"
                break
            case 500:
                potentialAchievement = "500 Enemies"
                break
            case 1000:
                potentialAchievement = "1000 Enemies"
                break
            default: break
            }
            
            if let ach = potentialAchievement {
                let heroDidNotAlreadyHaveAchievement = loggedInHero?.achieve(ach)
                if heroDidNotAlreadyHaveAchievement! {
                    achieve(ach)
                }
            }
            
            // Increment Firebase total victories
            if let user = FIRAuth.auth()?.currentUser {
                print("dandelions")
                ref.child("users").child(user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    // Get user value
                    if let currentTotalVictories = (snapshot.value as? NSDictionary)?["totalVictories"] as? Int {
                        
                        ref.child("users/\(user.uid)/totalVictories").setValue(currentTotalVictories + 1)
                        
                    }
                    
                }) { (error) in
                    print(error.localizedDescription)
                }
            }
            
            return true
        }
        return false
    }
    
    func use(ability: String) {
        
        let response = getTurnOrder()
        
        let random = response.0
        
        let heroRange = response.1
        
        if random < Int(heroRange) {
            
            let monsterDead = performAbility(ability: ability)
            if monsterDead == false {
                let _ = monsterAttacks()
            }
            
        } else {
            
            let heroDead = monsterAttacks()
            
            if heroDead == false {
                let _ = performAbility(ability: ability)
            }
            
        }
        
        update()
    }
    
    func performAbility(ability: String) {
        let response = loggedInHero.use(ability: ability, target: target!)
        let text = response.0
        let type = response.1
        
        battleLog.append(BattleCellConfig(text: text, color: type, image1: loggedInHero.icon as! UIImage, image2: #imageLiteral(resourceName: "snailhero2")))
        
        return monsterIsDead()
    }
    
    @IBAction func died(_ sender: UIButton) {
        if let navController = self.navigationController {
            navController.popToRootViewController(animated: true)
        }
    }
    
    @IBAction func won(_ sender: UIButton) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
    func achieve(_ key: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let modal = storyboard.instantiateViewController(withIdentifier: "achievement") as! AchievementModalViewController
        let chieve = Achievements[key]
        modal.configureModal(name: chieve?["name"] as! String, description: chieve?["description"] as! String, icon: chieve?["icon"] as! UIImage)
        self.present(modal, animated: true, completion: nil)
    }
    
    @IBAction func runButtonPressed(_ sender: UIButton) {
        let backpack = loggedInHero?.backpack as! [String]
        for i in 0..<backpack.count {
            if backpack[i] == "Escape Potion" {
                loggedInHero?.removeFromBackpack(at: i)
                break
            }
        }
        
        ad.saveContext()
        
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToMain" {
            let controller = segue.destination as! MainViewController
            controller.loggedInHero = self.loggedInHero
        }
    }
    @IBAction func battleAgainButtonPressed(_ sender: Any) {
        attackButton.isHidden = false
        backToMainButton.isHidden = true
        restartButton.isHidden = true
        battleAgainButton.isHidden = true
        getMonster()
        update()
    }
    
    func update(){
        heroHealthLabel.text = String(describing: (loggedInHero?.health)!)
        monsterHealthLabel.text = String(describing: (target?.health)!)
        heroHealthSlider.maximumValue = Float((loggedInHero?.maxHealth)!)
        heroHealthSlider.value = Float((loggedInHero?.health)!)
        heroManaLabel.text = String(describing: (loggedInHero?.mana)!)
        heroManaSlider.maximumValue = Float((loggedInHero?.maxMana)!)
        heroManaSlider.value = Float((loggedInHero?.mana)!)
        monsterHealthSlider.maximumValue = Float((monsterMaxHealth!))
        monsterHealthSlider.value = Float((target?.health)!)
        


        
        battleLogTable.reloadData()
        
        if battleLog.count > 0 {
            scrollToLastRow()
        }
    }
    
    func scrollToLastRow() {
        let indexPath = IndexPath(row: max(battleLog.count - 1,0), section: 0)
        battleLogTable.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: true)
    }
    
    func getMonster() {
        
        let area = AreaDataForIndex[Int((loggedInHero?.area)!)]
        let monsterPoolPick = Int(arc4random_uniform(100)) + 1
        var areaMonsters = [String]()
        if monsterPoolPick <= 5 {
            areaMonsters = area?["elites"] as! [String]
        } else {
            areaMonsters = area?["monsters"] as! [String]
        }
        let randomMonsterIdx = Int(arc4random_uniform(UInt32(areaMonsters.count)))
        
        let randomMonster = areaMonsters[randomMonsterIdx]
        
        let monsterChoice = MonsterList[randomMonster]!
        
        monsterMaxHealth = monsterChoice["health"] as! Int?
        
        target = Monster(name: monsterChoice["name"] as! String, health: monsterChoice["health"] as! Int, gold: monsterChoice["gold"] as! Int, damage: monsterChoice["damage"] as! Int, experience: monsterChoice["experience"] as! Int, speed: monsterChoice["speed"] as! Int)

        // Set Monster stats labels
        monsterNameLabel.text = target?.name
    }
    
    override func viewDidLoad() {
        battleLogTable.delegate = self
        battleLogTable.dataSource = self

        // Set Hero stats labels
        heroNameLabel.text = "\((loggedInHero?.name!)!)'s Health:"
        
        runButton.isHidden = true
        
        for item in loggedInHero?.backpack as! [String] {
            if item == "Escape Potion" {
                runButton.isHidden = false
            }
        }
        
        attackButton.isHidden = false
        backToMainButton.isHidden = true
        restartButton.isHidden = true
        battleAgainButton.isHidden = true
        getMonster()
        update()

    }
    
}

extension BattleViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "battleLogCell", for: indexPath) as! BattleLogCell
        cell.configureCell(with: battleLog[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return battleLog.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
