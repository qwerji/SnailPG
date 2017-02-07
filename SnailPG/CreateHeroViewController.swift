//
//  CreateHeroViewController.swift
//  Snail Fantasy
//
//  Created by Tyler Warren on 1/23/17.
//  Copyright © 2017 Benjamin Swanson. All rights reserved.
//

import UIKit

class CreateHeroViewController: UIViewController, UITextFieldDelegate {

    let achievementManager = AchievementManager.sharedInstance
    
    @IBOutlet weak var heroName: UITextField!
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
        if let name = heroName.text {

            let hero = Hero.createNewHero(job: sender.tag, name: name)
            
            // Save Hero instance in appDelegate and CoreData
            ad.saveContext()
            
            // Go to Stats for stat allocation
            self.performSegue(withIdentifier: "creationStatsSegue", sender: hero)
            
            if isARandomName {
                if let achievement = achievementManager.checkForNameAchievements(for: hero) {
                    globalAchieve(achievement)
                }
            }
        } else {
            
            let alert = UIAlertController(title: "Please enter a name.", message: "", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                (action: UIAlertAction!) -> Void in
                return
            })
            self.present(alert, animated: true, completion: nil)

        }
    }
    
    func globalAchieve(_ key: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let modal = storyboard.instantiateViewController(withIdentifier: "achievement") as! AchievementModalViewController
        let chieve = achievementManager.nameAchievements[key]
        modal.configureModal(name: chieve?["name"] as! String, description: chieve?["description"] as! String, icon: chieve?["icon"] as! UIImage)
        self.present(modal, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? StatViewController {
            controller.loggedInHero = sender as? Hero
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

