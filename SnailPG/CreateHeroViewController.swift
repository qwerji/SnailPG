//
//  CreateHeroViewController.swift
//  Snail Fantasy
//
//  Created by Tyler Warren on 1/23/17.
//  Copyright © 2017 Benjamin Swanson. All rights reserved.
//

import UIKit
import CoreData

class CreateHeroViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var heroName: UITextField!
    var loggedInHero: Hero?
    
    @IBAction func nameGeneratorPressed(_ sender: UIButton) {
        var randomNames = ["Jill","Bill","Phil","Stranky","Mooper","Bryit","Andu","Vulf","Victor","Timmy","Wilthas","Ophelia","Pappy","Pamela","Vicki","Coni","Amber","Sara","Leah","Dan","Benjamin","Michelle","Nasim","Luca","Algore","Maloc","Brandon","Doj", "Porkle", "Pem", "Fiaz", "Django","Nancy","Sparkle","Grampy","Jack","Glenn","Lars","Berry","Magic","Spider","Taco","Hawaiian","Magnus","Frothgar","Gorlok","Colon","The","Ty","Beanbag","Plebby","Mad","Andy","Larry", "Karl", "Margie","Miguel"]
        var randomLastNames = ["People", "Buckets", "Dustkeeper","Hawkarrow","LoneMane","Boulderbreaker","Ashridge","Bryit","Deathseeker","Mandu","Snowmane","Kingslayer","Swiftfoot","Mountainscream","Moonshadow", "Voidstrider","Moonthorn","Grandcrest","Stinkz","Rhythms","Pem","Ponies", "Darksider","Saltshaker","Riverchaser","Wyvernbeard","Treegazer","Fogbinder","Dragonblood","Dawncrest","WildShard","Bronzefist","Shieldbearer","Gangletoes","FizzBuzz","Donglegoblin","Cloudstriker","Goodbrancher","Bluejeans","Coffee","Brian","Powell","Donald","Ben","the Pleb","Bingo"]
        
        func randomBool() -> Bool {
            return arc4random_uniform(2) == 0
        }
        func nameGenerator () -> String {
            var generatedName: String
            if randomBool(){
                generatedName = "\(randomNames[Int(arc4random_uniform(UInt32(randomNames.count)))])"
                
            } else {
                generatedName = "\(randomNames[Int(arc4random_uniform(UInt32(randomNames.count)))]) \(randomLastNames[Int(arc4random_uniform(UInt32(randomLastNames.count)))])"
            }
            return generatedName
        }
        
        heroName.text = nameGenerator()
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
            let hero = NSEntityDescription.insertNewObject(forEntityName: "Hero", into: context) as! Hero
            
            // Set defaults for the selected job on creation
            switch sender.tag {
            case 0:
                jobChoice = "Warrior"
                hero.strength = 10
                hero.dexterity = 6
                hero.intelligence = 2
                hero.icon = #imageLiteral(resourceName: "warrior")
                break
            case 1:
                jobChoice = "Mage"
                hero.strength = 2
                hero.dexterity = 6
                hero.intelligence = 10
                hero.icon = #imageLiteral(resourceName: "mage")
                break
            case 2:
                jobChoice = "Thief"
                hero.strength = 2
                hero.dexterity = 10
                hero.intelligence = 6
                hero.icon = #imageLiteral(resourceName: "thief")
                break
            default: break
            }
            
            hero.maxArea = 0
            hero.area = 0
            hero.maxHealth = 50
            hero.defense = 0
            hero.health = 50
            hero.maxMana = hero.intelligence * 5
            hero.mana = hero.intelligence * 5
            hero.level = 1
            hero.experience = 0
            hero.expToLevel = 100
            hero.statPoints = 5
            hero.victories = 0
            hero.name = heroName.text!
            hero.job = jobChoice!
            hero.backpack = NSArray()
            
            // Save Hero instance in appDelegate and CoreData
            ad.saveContext()
            loggedInHero = hero
            
            // Clear textbox
            heroName.text = ""
            
            // Go to Stats for stat allocation
            self.performSegue(withIdentifier: "creationStatsSegue", sender: nil)
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! StatViewController
        controller.loggedInHero = self.loggedInHero
        controller.isFromMain = false
    }
    

    
    // Keyboard goes away when Done is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    override func viewDidLoad() {
        heroName.delegate = self
    }
    
}

