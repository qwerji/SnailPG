//
//  WelcomeViewController.swift
//  SnailPG
//
//  Created by Ben Swanson on 1/12/17.
//  Copyright © 2017 Benjamin Swanson. All rights reserved.
//

import UIKit
import CoreData

class WelcomeViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var previousHeroesLabel: UILabel!
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let defaults = UserDefaults.standard
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var previousHeroes = [Hero]()
    @IBOutlet weak var previousHeroesTable: UITableView!
    @IBOutlet weak var heroName: UITextField!
    var loggedInHero: Hero?
    
    @IBAction func unwindToWelcome(segue: UIStoryboardSegue) {
        update()
    }
    
    @IBAction func jobChosen(_ sender: UIButton) {
        if heroName.text! == "" {
            
            let alert = UIAlertController(title: "Please enter a name.", message: "", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                (action: UIAlertAction!) -> Void in
                return
            })
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            var jobChoice: String?
            let hero = NSEntityDescription.insertNewObject(forEntityName: "Hero", into: managedObjectContext) as! Hero
            
            // Set defaults for the selected job on creation
            switch sender.tag {
            case 0:
                jobChoice = "Warrior"
                hero.strength = 10
                hero.dexterity = 6
                hero.intelligence = 2
                break
            case 1:
                jobChoice = "Mage"
                hero.strength = 2
                hero.dexterity = 6
                hero.intelligence = 10
                break
            case 2:
                jobChoice = "Thief"
                hero.strength = 2
                hero.dexterity = 10
                hero.intelligence = 6
                break
            default: print("Error")
            }
            
            hero.health = 50
            hero.level = 1
            hero.name = heroName.text!
            hero.job = jobChoice!
            
            // Save Hero instance in appDelegate and CoreData
            appDelegate.saveContext()
            loggedInHero = hero
            
            // Clear textbox
            heroName.text = ""
            
            // Go to Main
            self.performSegue(withIdentifier: "heroCreation", sender: nil)
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! MainViewController
        controller.loggedInHero = self.loggedInHero
    }
    
    func update() {
        // Get previous heroes that are not dead
        let heroRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Hero")
        heroRequest.predicate = NSPredicate(format: "%K > %D", "health", 0)
        do {
            let results = try managedObjectContext.fetch(heroRequest)
            
            previousHeroes = results as! [Hero]
        } catch {
            print("\(error)")
        }
        
        if previousHeroes.isEmpty {
            previousHeroesTable.isHidden = true
            previousHeroesLabel.isHidden = true
        } else {
            previousHeroesTable.isHidden = false
            previousHeroesLabel.isHidden = false
        }
        previousHeroesTable.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Preload the game entities into CoreData on first app load
        preload()
        update()
        
        previousHeroesTable.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        update()
    }
    
    func preload(){
        let preloaded = defaults.bool(forKey: "preloaded")
        if !preloaded {
            
            // Preload Coredata
            
            // Monster Area 0
            let goblinPleb = NSEntityDescription.insertNewObject(forEntityName: "Monster", into: managedObjectContext) as! Monster
            goblinPleb.name = "Goblin Pleb"
            goblinPleb.health = 20
            goblinPleb.damage = 8
            goblinPleb.gold = 15
            goblinPleb.experience = 15
            
            let basicSnail = NSEntityDescription.insertNewObject(forEntityName: "Monster", into: managedObjectContext) as! Monster
            basicSnail.name = "Basic Snail"
            basicSnail.health = 10
            basicSnail.damage = 5
            basicSnail.gold = 5
            basicSnail.experience = 10
            
            let mechaSnail = NSEntityDescription.insertNewObject(forEntityName: "Monster", into: managedObjectContext) as! Monster
            mechaSnail.name = "Mecha-Snail"
            mechaSnail.health = 25
            mechaSnail.damage = 10
            mechaSnail.gold = 30
            mechaSnail.experience = 30
            
            let prancingPony = NSEntityDescription.insertNewObject(forEntityName: "Monster", into: managedObjectContext) as! Monster
            prancingPony.name = "Prancing Pony"
            prancingPony.health = 15
            prancingPony.damage = 7
            prancingPony.gold = 12
            prancingPony.experience = 15
            
            let snailDragon = NSEntityDescription.insertNewObject(forEntityName: "Monster", into: managedObjectContext) as! Monster
            snailDragon.name = "Snail Dragon"
            snailDragon.health = 30
            snailDragon.damage = 10
            snailDragon.gold = 35
            snailDragon.experience = 35
            
            
            let lesserDragon = NSEntityDescription.insertNewObject(forEntityName: "Monster", into: managedObjectContext) as! Monster
            lesserDragon.name = "Lesser Dragon"
            lesserDragon.health = 40
            lesserDragon.damage = 15
            lesserDragon.gold = 50
            lesserDragon.experience = 50
            
            let slimer = NSEntityDescription.insertNewObject(forEntityName: "Monster", into: managedObjectContext) as! Monster
            slimer.name = "Slimer"
            slimer.health = 15
            slimer.damage = 10
            slimer.gold = 10
            slimer.experience = 15
            
            
            let vampireSnail = NSEntityDescription.insertNewObject(forEntityName: "Monster", into: managedObjectContext) as! Monster
            vampireSnail.name = "Vampire Snail"
            vampireSnail.health = 20
            vampireSnail.damage = 12
            vampireSnail.gold = 15
            vampireSnail.experience = 20
            
            
            let landShark = NSEntityDescription.insertNewObject(forEntityName: "Monster", into: managedObjectContext) as! Monster
            landShark.name = "Land Shark"
            landShark.health = 40
            landShark.damage = 20
            landShark.gold = 100
            landShark.experience = 100
            
            
            let greaterSnail = NSEntityDescription.insertNewObject(forEntityName: "Monster", into: managedObjectContext) as! Monster
            greaterSnail.name = "Greater Snail"
            greaterSnail.health = 20
            greaterSnail.damage = 10
            greaterSnail.gold = 40
            greaterSnail.experience = 20
            
            
            let evilShopkeep = NSEntityDescription.insertNewObject(forEntityName: "Monster", into: managedObjectContext) as! Monster
            evilShopkeep.name = "Evil Shopkeep"
            evilShopkeep.health = 80
            evilShopkeep.damage = 7
            evilShopkeep.gold = 80
            evilShopkeep.experience = 75
            
            
            let lavaLord = NSEntityDescription.insertNewObject(forEntityName: "Monster", into: managedObjectContext) as! Monster
            lavaLord.name = "Lava Lord"
            lavaLord.health = 35
            lavaLord.damage = 20
            lavaLord.gold = 40
            lavaLord.experience = 40
            
            
            let snailJunkie = NSEntityDescription.insertNewObject(forEntityName: "Monster", into: managedObjectContext) as! Monster
            snailJunkie.name = "Snail Junkie"
            snailJunkie.health = 50
            snailJunkie.damage = 15
            snailJunkie.gold = 50
            snailJunkie.experience = 50
            
            let ratMonkey = NSEntityDescription.insertNewObject(forEntityName: "Monster", into: managedObjectContext) as! Monster
            ratMonkey.name = "Rat Monkey"
            ratMonkey.health = 65
            ratMonkey.damage = 20
            ratMonkey.gold = 70
            ratMonkey.experience = 70
            
            let goblinElite = NSEntityDescription.insertNewObject(forEntityName: "Monster", into: managedObjectContext) as! Monster
            goblinElite.name = "Goblin Elite"
            goblinElite.health = 50
            goblinElite.damage = 15
            goblinElite.gold = 50
            goblinElite.experience = 55
            
            // Weapons
            let copperSword = NSEntityDescription.insertNewObject(forEntityName: "Weapon", into: managedObjectContext) as! Weapon
            copperSword.name = "Copper Sword"
            copperSword.handed = 1
            copperSword.damage = 3
            copperSword.price = 5
            
            let hammerOfNailing = NSEntityDescription.insertNewObject(forEntityName: "Weapon", into: managedObjectContext) as! Weapon
            hammerOfNailing.name = "Hammer of Nailing"
            hammerOfNailing.handed = 1
            hammerOfNailing.damage = 12
            hammerOfNailing.price = 25
            
            let greatSword = NSEntityDescription.insertNewObject(forEntityName: "Weapon", into: managedObjectContext) as! Weapon
            greatSword.name = "Great Sword"
            greatSword.handed = 2
            greatSword.damage = 10
            greatSword.price = 15
            
            let swordOfTheSnailKing = NSEntityDescription.insertNewObject(forEntityName: "Weapon", into: managedObjectContext) as! Weapon
            swordOfTheSnailKing.name = "Sword of the Snail King"
            swordOfTheSnailKing.handed = 2
            swordOfTheSnailKing.damage = 100
            swordOfTheSnailKing.price = 300
            
            let staffOfWonder = NSEntityDescription.insertNewObject(forEntityName: "Weapon", into: managedObjectContext) as! Weapon
            staffOfWonder.name = "Staff of Wonder"
            staffOfWonder.handed = 2
            staffOfWonder.damage = 20
            staffOfWonder.price = 30
            
            // Armor
            
            let bubbleBoots = NSEntityDescription.insertNewObject(forEntityName: "Armor", into: managedObjectContext) as! Armor
            bubbleBoots.name = "Bubble Boots"
            bubbleBoots.defense = 50
            bubbleBoots.price = 300
            
            let shinGuards = NSEntityDescription.insertNewObject(forEntityName: "Armor", into: managedObjectContext) as! Armor
            shinGuards.name = "Shin Guards"
            shinGuards.defense = 4
            shinGuards.price = 8
            
            let leatherCap = NSEntityDescription.insertNewObject(forEntityName: "Armor", into: managedObjectContext) as! Armor
            leatherCap.name = "Leather Cap"
            leatherCap.defense = 5
            leatherCap.price = 10
            
            let robesOfWonder = NSEntityDescription.insertNewObject(forEntityName: "Armor", into: managedObjectContext) as! Armor
            robesOfWonder.name = "Robes of Wonder"
            robesOfWonder.defense = 18
            robesOfWonder.price = 50
            
            let leatherArmor = NSEntityDescription.insertNewObject(forEntityName: "Armor", into: managedObjectContext) as! Armor
            leatherArmor.name = "Leather Armor"
            leatherArmor.defense = 20
            leatherArmor.price = 60
            
            // Potions
            let healthPotion = NSEntityDescription.insertNewObject(forEntityName: "Potion", into: managedObjectContext) as! Potion
            healthPotion.name = "Health Potion"
            healthPotion.effect = "Heals 10"
            healthPotion.price = 10

            let escapePotion = NSEntityDescription.insertNewObject(forEntityName: "Potion", into: managedObjectContext) as! Potion
            escapePotion.name = "Escape Potion"
            escapePotion.effect = "Allows escape from a regular battle."
            escapePotion.price = 30
            
            // Save
            appDelegate.saveContext()
            
            // Don't preload again
            defaults.set(true, forKey: "preloaded")
        }
        
        // Set up keyboard
        heroName.returnKeyType = .done
        heroName.delegate = self
        
        previousHeroesTable.delegate = self
    }
    
    // Keyboard goes away when Done is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension WelcomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    // Get row count
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return previousHeroes.count
    }
    
    // Set rows to previous hero names
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "previousHero")!
        cell.textLabel?.text = "\(previousHeroes[indexPath.row].name!) - \(previousHeroes[indexPath.row].job!)"
        return cell
    }
    
    // When pressed, log into that hero
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        loggedInHero = previousHeroes[indexPath.row]
        self.performSegue(withIdentifier: "heroCreation", sender: nil)
    }
    
}
