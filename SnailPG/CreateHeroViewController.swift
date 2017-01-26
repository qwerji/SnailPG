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
        heroName.text = RandomNameGenerator().getName
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

            let hero = NSEntityDescription.insertNewObject(forEntityName: "Hero", into: context) as! Hero
            
            hero.config(for: sender.tag, with: heroName.text!)
            
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
        if let controller = segue.destination as? StatViewController {
            controller.loggedInHero = self.loggedInHero
            controller.isFromMain = false
        }
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

