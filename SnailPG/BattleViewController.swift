//
//  BattleViewController.swift
//  SnailPG
//
//  Created by Ben Swanson on 1/12/17.
//  Copyright © 2017 Benjamin Swanson. All rights reserved.
//

import UIKit

class BattleViewController: UIViewController {
    
    var target: Monster?
    var loggedInHero: Hero?
    var monsterMaxHealth: Int?
    var battleLog = [BattleCellConfig]()
    let monsterManager = MonsterManager.sharedInstance
    let achievementManager = AchievementManager.sharedInstance
    
    @IBOutlet weak var abilityButton: UIButton!
    @IBOutlet weak var itemButton: UIButton!
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
    
    func updateButtonStates() {

        // Battle-ending checks
        if (loggedInHero?.health)! <= 0 {
            
            restartButton.isHidden = false
            
            attackButton.isHidden = true
            backToMainButton.isHidden = true
            battleAgainButton.isHidden = true
            itemButton.isHidden = true
            abilityButton.isHidden = true
            
        } else if (target?.health)! <= 0 {
            
            backToMainButton.isHidden = false
            battleAgainButton.isHidden = false
            
            attackButton.isHidden = true
            itemButton.isHidden = true
            abilityButton.isHidden = true
            
        } else {
            
            backToMainButton.isHidden = true
            battleAgainButton.isHidden = true
            
            // In-battle checks
            
            // Escape Potion Check
            runButton.isHidden = true
            for item in (loggedInHero?.backpackArray())! {
                if item == "Escape Potion" {
                    runButton.isHidden = false
                }
            }
            
            // Can always attack if in battle
            attackButton.isHidden = false
            
            // Check for items
            if (loggedInHero?.backpack as! [String]).count > 0 {
                itemButton.isHidden = false
            } else {
                itemButton.isHidden = true
            }
            
            // Check for mana
            if (loggedInHero?.mana)! < 10 {
                abilityButton.isHidden = true
            } else {
                abilityButton.isHidden = false
            }
            
        }
        
    }
    
    @IBAction func abilityButtonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let modal = storyboard.instantiateViewController(withIdentifier: "abilities") as! AbilityModalViewController
        modal.job = (loggedInHero?.job)!
        modal.delegate = self
        modal.update()
        self.present(modal, animated: true, completion: nil)
    }
    
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
            battleLog.append(BattleCellConfig(text: "\((loggedInHero?.name!)!) was defeated.", color: "Defeat", image1: #imageLiteral(resourceName: "snailhero2"), image2: loggedInHero?.icon as! UIImage))
            loggedInHero?.cleanBackpackOnDeath()
            return true
        }
        return false
    }
    
    func monsterIsDead() -> Bool {
        // Monster Health Check
        if (target?.health)! <= 0 {
            
            battleLog.append(BattleCellConfig(text: "\((target?.name)!) was defeated.", color: "Victory", image1: loggedInHero?.icon as! UIImage, image2: #imageLiteral(resourceName: "snailhero2")))
            if let goldDrop = target?.gold {
                loggedInHero?.gold += goldDrop
                battleLog.append(BattleCellConfig(text: "\((loggedInHero?.name!)!) got \(goldDrop) gold!", color: "Gold", image1: #imageLiteral(resourceName: "snailhero2"), image2: loggedInHero?.icon as! UIImage))
            }
            if let itemDrop = target?.drop {
                loggedInHero?.addToBackpack(itemDrop)
                battleLog.append(BattleCellConfig(text: "\((loggedInHero?.name!)!) picked up \(itemDrop)!", color: "Item", image1: #imageLiteral(resourceName: "snailhero2"), image2: loggedInHero?.icon as! UIImage))
            }
            // gain EXP when monster is slain
            loggedInHero?.gainsExp(amount: (target?.experience)!)
            battleLog.append(BattleCellConfig(text: "\((loggedInHero?.name!)!) gained \((target?.experience)!) experience!", color: "Experience", image1: #imageLiteral(resourceName: "snailhero2"), image2: loggedInHero?.icon as! UIImage))
            
            if let achievement = loggedInHero?.didReachVictoriesAchievement() {
                achieve(achievement)
            }
            
            loggedInHero?.incrementFirebaseVictories()
            
            ad.saveContext()
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
    
    func performAbility(ability: String) -> Bool {
        let response = loggedInHero?.use(ability: ability, target: target!)
        let text = response?.0
        let type = response?.1
        battleLog.append(BattleCellConfig(text: text!, color: type!, image1: loggedInHero?.icon as! UIImage, image2: #imageLiteral(resourceName: "snailhero2")))
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
        let chieve = achievementManager.achievements[key]
        modal.configureModal(name: chieve?["name"] as! String, description: chieve?["description"] as! String, icon: chieve?["icon"] as! UIImage)
        self.present(modal, animated: true, completion: nil)
    }
    
    @IBAction func runButtonPressed(_ sender: UIButton) {
        if (loggedInHero?.canUseEscapePotion())! {
            ad.saveContext()
            let _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToMain" {
            let controller = segue.destination as! MainViewController
            controller.loggedInHero = self.loggedInHero
        }
    }
    
    @IBAction func battleAgainButtonPressed(_ sender: Any) {
        getMonster()
        update()
    }
    
    func update(){
        heroHealthLabel.text = String(describing: (loggedInHero?.health)!)
        monsterHealthLabel.text = String(describing: (target?.health)!)
        heroHealthSlider.value = Float((loggedInHero?.health)!)
        heroManaLabel.text = String(describing: (loggedInHero?.mana)!)
        heroManaSlider.value = Float((loggedInHero?.mana)!)
        monsterHealthSlider.value = Float((target?.health)!)
        battleLogTable.reloadData()
        if battleLog.count > 0 {
            scrollToLastRow()
        }
        updateButtonStates()
    }
    
    func scrollToLastRow() {
        let indexPath = IndexPath(row: max(battleLog.count - 1,0), section: 0)
        battleLogTable.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: true)
    }
    
    func getMonster() {
        
        target = monsterManager.getMonster(for: loggedInHero!)
        
        monsterMaxHealth = target?.health
        monsterNameLabel.text = target?.name
        monsterHealthSlider.maximumValue = Float(monsterMaxHealth!)
    }
    
    override func viewDidLoad() {
        battleLogTable.delegate = self
        battleLogTable.dataSource = self
        
        heroNameLabel.text = "\((loggedInHero?.name!)!)'s Health:"
        heroManaSlider.maximumValue = Float((loggedInHero?.maxMana)!)
        heroHealthSlider.maximumValue = Float((loggedInHero?.maxHealth)!)
        restartButton.isHidden = true
        
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
