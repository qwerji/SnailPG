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

