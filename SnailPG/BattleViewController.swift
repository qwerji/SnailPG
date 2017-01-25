//
//  BattleViewController.swift
//  SnailPG
//
//  Created by Ben Swanson on 1/12/17.
//  Copyright © 2017 Benjamin Swanson. All rights reserved.
//

import UIKit
import CoreData

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
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var attackButton: UIButton!
    @IBOutlet weak var heroHealthSlider: HealthBar!
    @IBOutlet weak var monsterHealthSlider: UISlider!
    
    @IBAction func attackButtonPressed(_ sender: UIButton) {
        // Choose who attacks first
        
        let total = Int((loggedInHero?.dexterity)!) + (target?.speed)!
        
        let heroRange = round((Double((loggedInHero?.dexterity)!) / Double(total)) * 100.0)
        
        let random = Int(arc4random_uniform(UInt32(100))) + 1
        
        if random < Int(heroRange) {
            
            let monsterDead = heroAttacks()
            
            if monsterDead == false {
                let _ = monsterAttacks()
            }
            
        } else {
            
            let heroDead = monsterAttacks()
            
            if heroDead == false {
                let _ = heroAttacks()
            }
            
        }
        
        update()
        
    }
    
    func monsterAttacks() -> Bool {
        
        let response = target?.attack(loggedInHero!)
        let text = response?.0
        let type = response?.1

        battleLog.append(BattleCellConfig(text: text!, color: type!, image1: #imageLiteral(resourceName: "snailhero2"), image2: loggedInHero?.icon as! UIImage))
        
        // Hero Health Check
        if (loggedInHero?.health)! <= 0 {
            ad.saveContext()
            
            runButton.isHidden = true
            attackButton.isHidden = true
            backToMainButton.isHidden = true
            restartButton.isHidden = false
            
            battleLog.append(BattleCellConfig(text: "\((loggedInHero?.name!)!) was defeated.", color: "Defeat", image1: #imageLiteral(resourceName: "snailhero2"), image2: loggedInHero?.icon as! UIImage))
            
            return true
        }
        return false
    }
    
    func heroAttacks() -> Bool {

        let response = (loggedInHero?.attack(target!))!
        let text = response.0
        let type = response.1
        
        battleLog.append(BattleCellConfig(text: text, color: type, image1: loggedInHero?.icon as! UIImage, image2: #imageLiteral(resourceName: "snailhero2")))
        
        // Monster Health Check
        if (target?.health)! <= 0 {
            ad.saveContext()
            
            runButton.isHidden = true
            attackButton.isHidden = true
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
            
            return true
        }
        return false
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
    
    @IBAction func runButtonPressed(_ sender: UIButton) {
        let backpack = loggedInHero?.backpack as! [String]
        for i in 0..<backpack.count {
            if backpack[i] == "Escape Potion" {
                loggedInHero?.removeFromBackpack(at: i)
                break
            }
        }
        
        ad.saveContext()
        
        performSegue(withIdentifier: "unwindToMain", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToMain" {
            let controller = segue.destination as! MainViewController
            controller.loggedInHero = self.loggedInHero
        }
    }
    
    func update(){
        heroHealthLabel.text = String(describing: (loggedInHero?.health)!)
        monsterHealthLabel.text = String(describing: (target?.health)!)
        heroHealthSlider.maximumValue = Float((loggedInHero?.maxHealth)!)
        heroHealthSlider.value = Float((loggedInHero?.health)!)
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
        
        let areaMonsters = area?["monsters"] as! Array<Any>
        
        let randomMonsterIdx = Int(arc4random_uniform(UInt32(areaMonsters.count)))
        
        let randomMonster = areaMonsters[randomMonsterIdx]
        
        let monsterChoice = MonsterList[randomMonster as! String]!
        
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
