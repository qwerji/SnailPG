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
    @IBOutlet weak var previousHeroesTable: UITableView!
    @IBOutlet weak var heroName: UITextField!
    var previousHeroes = [Hero]()
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
                hero.icon = #imageLiteral(resourceName: "theif")
                break
            default: print("Error")
            }
            
            hero.area = 0
            hero.maxHealth = 50
            hero.defense = 0
            hero.health = 50
            hero.level = 1
            hero.experience = 0
            hero.expToLevel = 100
            hero.name = heroName.text!
            hero.job = jobChoice!
            hero.backpack = NSArray()

            // Save Hero instance in appDelegate and CoreData
            ad.saveContext()
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
            let results = try context.fetch(heroRequest)
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
        previousHeroesTable.dataSource = self
        previousHeroesTable.delegate = self
        heroName.delegate = self
        
        update()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        update()
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
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}

extension WelcomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    // Get row count
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return previousHeroes.count
    }
    
    // Set rows to previous hero names
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "continueCell", for: indexPath) as! continueCell
        cell.configureCell(for: previousHeroes[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    // When pressed, log into that hero
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        loggedInHero = previousHeroes[indexPath.row]
        self.performSegue(withIdentifier: "heroCreation", sender: nil)
    }
    
}
