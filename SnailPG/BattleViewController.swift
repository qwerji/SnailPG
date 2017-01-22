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
    @IBOutlet weak var heroHealthLabel: UILabel!
    @IBOutlet weak var heroNameLabel: UILabel!
    
    var target: Monster?
    var loggedInHero: Hero?
    var monsterMaxHealth: Int?
    
    @IBOutlet weak var battleLog: UILabel!
    @IBOutlet weak var monsterNameLabel: UILabel!
    @IBOutlet weak var monsterHealthLabel: UILabel!
    @IBOutlet weak var monsterDamageLabel: UILabel!
    
    @IBOutlet weak var runButton: UIButton!
    @IBOutlet weak var backToMainButton: UIButton!
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var attackButton: UIButton!
    @IBOutlet weak var heroHealthSlider: HealthBar!
    
    @IBAction func attackButtonPressed(_ sender: UIButton) {
        // Hero Attacks
        battleLog.text! += "\n" + (loggedInHero?.attack(target!))!
        
        // Monster Health Check
        if (target?.health)! <= 0 {
            ad.saveContext()
            
            runButton.isHidden = true
            attackButton.isHidden = true
            backToMainButton.isHidden = false
            restartButton.isHidden = true
            
            battleLog.text! += "\n\((target?.name)!) was defeated."
            
            if let goldDrop = target?.gold {
                loggedInHero?.gold += goldDrop
                battleLog.text! += "\n\((loggedInHero?.name!)!) got \(goldDrop) gold!"
            }
            if let itemDrop = target?.drop {
                let bp = loggedInHero?.backpack as! NSMutableArray
                bp.add(itemDrop)
                battleLog.text! += "\n\((loggedInHero?.name!)!) picked up \(itemDrop)!"
            }
            // gain EXP when monster is slain
            loggedInHero?.gainsExp(amount: (target?.experience)!)
            battleLog.text! += "\n\((loggedInHero?.name!)!) gained \((target?.experience)!) experience!"
            // Show win button
            
            update()
            return
        }
        
        // Monster Attacks
        battleLog.text! += "\n" + (target?.attack(loggedInHero!))!
        
        // Hero Health Check
        if (loggedInHero?.health)! <= 0 {
            ad.saveContext()
            
            runButton.isHidden = true
            attackButton.isHidden = true
            backToMainButton.isHidden = true
            restartButton.isHidden = false
            
            battleLog.text! += "\n\((loggedInHero?.name!)!) was defeated."
            
            // Show die button
            
            update()
            return
        }
        update()
    }
    
    @IBAction func died(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindToWelcome", sender: nil)
    }
    
    @IBAction func won(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
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
        heroHealthSlider.value = Float((loggedInHero?.health)!)
        heroHealthSlider.maximumValue = Float((loggedInHero?.maxHealth)!)
    }
    
    func getMonster() {
        
        let area = AreaDataForIndex[Int((loggedInHero?.area)!)]
        
        let areaMonsters = area?["monsters"] as! Array<Any>
        
        let randomMonsterIdx = Int(arc4random_uniform(UInt32(areaMonsters.count)))
        
        let randomMonster = areaMonsters[randomMonsterIdx]
        
        let monsterChoice = MonsterList[randomMonster as! String]!
        
        monsterMaxHealth = monsterChoice["health"] as! Int?
        
        target = Monster(name: monsterChoice["name"] as! String, health: monsterChoice["health"] as! Int, gold: monsterChoice["gold"] as! Int, damage: monsterChoice["damage"] as! Int, experience: monsterChoice["experience"] as! Int)
        
        // Set Monster stats labels
        monsterNameLabel.text = target?.name
        monsterDamageLabel.text = String(describing: (target?.damage)!)
    }
    
    override func viewDidLoad() {
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
