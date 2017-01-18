//
//  BattleViewController.swift
//  SnailPG
//
//  Created by Ben Swanson on 1/12/17.
//  Copyright © 2017 Benjamin Swanson. All rights reserved.
//

import UIKit
import CoreData

struct ActiveMonster {
    var name: String
    var health: Int
    var gold: Int
    var damage: Int
    init(monster: Monster){
        self.name = monster.name!
        self.health = Int(monster.health)
        self.gold = Int(monster.gold)
        self.damage = Int(monster.damage)
    }
    mutating func getHit(damage: Int) {
        self.health -= damage
    }
}

class BattleViewController: UIViewController {
    @IBOutlet weak var heroHealthLabel: UILabel!
    @IBOutlet weak var heroNameLabel: UILabel!
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var target: ActiveMonster?
    var loggedInHero: Hero?
    @IBOutlet weak var battleLog: UILabel!
    @IBOutlet weak var monsterNameLabel: UILabel!
    @IBOutlet weak var monsterHealthLabel: UILabel!
    @IBOutlet weak var monsterDamageLabel: UILabel!
    
    @IBAction func attackButtonPressed(_ sender: UIButton) {
        // Hero Attacks
        var heroAttackValue = 0
        let hitChance = Int(arc4random_uniform(UInt32(10))) + 1
        if hitChance == 1 {
            // Miss
            battleLog.text = (battleLog.text ?? "") + "\n\((loggedInHero?.name!)!) missed!"
        } else if hitChance == 10 {
            // Max damage
            heroAttackValue = Int((loggedInHero?.strength)!)
            battleLog.text = (battleLog.text ?? "") + "\n\((loggedInHero?.name!)!) did \(heroAttackValue) damage to \((target?.name)!)!"
        } else {
            // Base damage range
            heroAttackValue = Int(arc4random_uniform(UInt32((loggedInHero?.strength)!))) + 1
            battleLog.text = (battleLog.text ?? "") + "\n\((loggedInHero?.name!)!) did \(heroAttackValue) damage to \((target?.name)!)!"
        }
        
        // Implement weapon modifiers here
        
        target?.getHit(damage: heroAttackValue)
        
        // Monster health check
        if (target?.health)! <= 0 {
            battleLog.text = battleLog.text! + "\n\((loggedInHero?.name!)!) defeated \((target?.name)!)!"
            if let goldDrop = target?.gold {
                battleLog.text = battleLog.text! + "\nYou gained \(goldDrop) gold!"
                loggedInHero?.gold += goldDrop
            }
            //            if let itemDrop = target.drop {
            //                print("You picked up \(itemDrop.name)!")
            //                self.backpack.append(itemDrop)
            //            }
            
            let alert = UIAlertController(title: "Snailed it!", message: "\((target?.name)!) was defeated. \((loggedInHero?.name!)!) gained \((target?.gold)!) gold.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Back to Menu", style: UIAlertActionStyle.default) {
                (action: UIAlertAction!) -> Void in
                self.appDelegate.saveContext()
                self.dismiss(animated: true, completion: nil)
            })
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        // Monster Attacks
        var monsterAttackValue = 0
        let targetHitChance = Int(arc4random_uniform(UInt32(10))) + 1
        if targetHitChance == 1 {
            // Miss
            battleLog.text = (battleLog.text ?? "") + "\n\((target?.name)!) missed!"
        } else if targetHitChance == 10 {
            // Max damage
            monsterAttackValue = Int((target?.damage)!)
            battleLog.text = (battleLog.text ?? "") + "\n\((target?.name)!) did \(monsterAttackValue) damage to \((loggedInHero?.name!)!)!"
        } else {
            // Base damage range
            monsterAttackValue = Int(arc4random_uniform(UInt32((target?.damage)!))) + 1
            battleLog.text = (battleLog.text ?? "") + "\n\((target?.name)!) did \(monsterAttackValue) damage to \((loggedInHero?.name!)!)!"
        }
        
        loggedInHero?.getHit(damage: monsterAttackValue)

        // Hero health check
        if (loggedInHero?.health)! <= 0 {
            let alert = UIAlertController(title: "You Died", message: "\((loggedInHero?.name!)!) was defeated by \((target?.name)!).", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Back to Welcome", style: UIAlertActionStyle.default) {
                (action: UIAlertAction!) -> Void in
                self.appDelegate.saveContext()
                self.died()
            })
            self.present(alert, animated: true, completion: nil)
            return
        }
        update()
    }
    
    func died() -> Void {
        performSegue(withIdentifier: "unwindToWelcome", sender: nil)
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
    
    override func viewDidLoad() {
        // Set Hero stats labels
        heroNameLabel.text = "\((loggedInHero?.name!)!)'s Health:"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Load Monsters
        
        // Implement monster choosing logic here, making a more specific DB query
        
        let monsterRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Monster")
        do {
            let results = try managedObjectContext.fetch(monsterRequest)
            let monsterIdx = Int(arc4random_uniform(UInt32(results.count)))
            let monsterChoice = results[monsterIdx] as! Monster
            
            target = ActiveMonster(monster: monsterChoice)
            
        } catch {
            print("\(error)")
        }
        
        // Set Monster stats labels
        monsterNameLabel.text = target?.name
        monsterDamageLabel.text = String(describing: (target?.damage)!)
        
        // Update health labels
        update()
    }
    
}
