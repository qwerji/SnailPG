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
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var target: Monster?
    var loggedInHero: Hero?
    @IBOutlet weak var battleLog: UILabel!
    @IBOutlet weak var monsterNameLabel: UILabel!
    @IBOutlet weak var monsterHealthLabel: UILabel!
    @IBOutlet weak var monsterDamageLabel: UILabel!
    
    @IBOutlet weak var runButton: UIButton!
    @IBOutlet weak var backToMainButton: UIButton!
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var attackButton: UIButton!
    
    @IBAction func attackButtonPressed(_ sender: UIButton) {
        // Hero Attacks
        battleLog.text! += "\n" + (loggedInHero?.attack(target!))!
        
        // Monster Health Check
        if (target?.health)! <= 0 {
            appDelegate.saveContext()
            
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
            // Show win button
            
            update()
            return
        }
        
        // Monster Attacks
        battleLog.text! += "\n" + (target?.attack(loggedInHero!))!
        
        // Hero Health Check
        if (loggedInHero?.health)! <= 0 {
            appDelegate.saveContext()
            
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
    }
    
    func getMonster() {
        // Implement monster choosing logic here, making a more specific DB query
        
        let randomMonsterIdx = Int(arc4random_uniform(UInt32(Area0Monsters.count)))
        
        let monsterChoice = MonsterList[Area0Monsters[randomMonsterIdx]]!
        
        target = Monster(name: monsterChoice["name"] as! String, health: monsterChoice["health"] as! Int, gold: monsterChoice["gold"] as! Int, damage: monsterChoice["damage"] as! Int, experience: monsterChoice["experience"] as! Int)
        
        // Set Monster stats labels
        monsterNameLabel.text = target?.name
        monsterDamageLabel.text = String(describing: (target?.damage)!)
    }
    
    override func viewDidLoad() {
        // Set Hero stats labels
        heroNameLabel.text = "\((loggedInHero?.name!)!)'s Health:"
        
        runButton.isHidden = false
        attackButton.isHidden = false
        backToMainButton.isHidden = true
        restartButton.isHidden = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Load Monsters
        getMonster()
        
        // Update health labels
        update()
    }
    
}
