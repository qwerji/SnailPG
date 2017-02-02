//
//  CreateHeroViewController.swift
//  Snail Fantasy
//
//  Created by Tyler Warren on 1/23/17.
//  Copyright © 2017 Benjamin Swanson. All rights reserved.
//

import UIKit
import CoreData
import FirebaseAuth

class CreateHeroViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var heroName: UITextField!
    var loggedInHero: Hero?
    var globalAchievements = [String]()
    var isARandomName = false
    
    @IBAction func nameGeneratorPressed(_ sender: UIButton) {
        heroName.text = RandomNameGenerator().getName
        if !isARandomName {
            isARandomName = true
        }
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        if isARandomName {
            isARandomName = false
        }
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
            
            if let user = FIRAuth.auth()?.currentUser, isARandomName {
                
                ref.child("users").child(user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    // Get user value
                    if let currentAchievements = (snapshot.value as? NSDictionary)?.allValues[0] as? NSDictionary {

                        for achievement in GlobalAchievements {
                            if achievement.value["name"] as? String == self.loggedInHero?.name {
                                var alreadyHasAchievement = false
                                
                                for currentAchievement in currentAchievements {
                                    if currentAchievement.key as? String == achievement.value["name"] as? String {
                                        alreadyHasAchievement = true
                                    }
                                }
                                
                                if !alreadyHasAchievement {
                                    ref.child("users/\(user.uid)/achievements").child("\(achievement.value["name"]!)").setValue(true)
                                    self.globalAchieve(achievement.value["name"] as! String)
                                }
                                break
                            }
                        }
                    }
                    
                }) { (error) in
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func globalAchieve(_ key: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let modal = storyboard.instantiateViewController(withIdentifier: "achievement") as! AchievementModalViewController
        let chieve = GlobalAchievements[key]
        modal.configureModal(name: chieve?["name"] as! String, description: chieve?["description"] as! String, icon: chieve?["icon"] as! UIImage)
        self.present(modal, animated: true, completion: nil)
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
        heroName.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
    }
    
}

