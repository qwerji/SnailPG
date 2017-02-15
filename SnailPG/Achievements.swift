//
//  Achievements.swift
//  Snail Fantasy
//
//  Created by Ben Swanson on 1/26/17.
//  Copyright © 2017 Benjamin Swanson. All rights reserved.
//

import UIKit
import FirebaseAuth

class AchievementManager {
    
    static let sharedInstance = AchievementManager()
    
    func checkForItemAchievements(for hero: Hero, itemType: String) -> String? {
        
        var potentialAchievement: String?
        
        switch itemType {
        case "Weapon":
            potentialAchievement = "First Weapon"
            break
        case "Armor":
            potentialAchievement = "First Armor"
            break
        case "Potion":
            potentialAchievement = "First Potion"
            break
        default: break
        }
        
        if let ach = potentialAchievement {
            let heroDidNotAlreadyHaveAchievement = hero.achieve(ach)
            if heroDidNotAlreadyHaveAchievement {
                return ach
            }
        }
        
        return nil
    }
    
    func checkForNameAchievements(for hero: Hero, completion: @escaping (_ achievement: String?) -> Void) {
        
        var nameAchievement: String?
        
        if let user = FIRAuth.auth()?.currentUser {
            ref.child("users/\(user.uid)").observeSingleEvent(of: .value, with: { (snapshot) in
                
                for achievement in self.nameAchievements {
                    if achievement.value["name"] as? String == hero.name {
                        var alreadyHasAchievement = false
                        
                        if snapshot.childSnapshot(forPath: "achievements").hasChild((achievement.value["name"] as? String)!) {
                            alreadyHasAchievement = true
                        }
                        
                        if !alreadyHasAchievement {
                            ref.child("users/\(user.uid)/achievements/\(achievement.value["name"]!)").setValue(true)
                            nameAchievement = achievement.value["name"] as! String?
                        }
                        
                        completion(nameAchievement)
                    }
                }
                
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    let achievements: [String:[String:Any]] = [
        // Snailed It Series
        "Won A Battle" : [
            "name"        : "Snailin' It: I",
            "description" : "You won your first battle!",
            "icon"        : #imageLiteral(resourceName: "snailhero2")
        ],
        "50 Enemies" : [
            "name"        : "Snailin' It: II",
            "description" : "50 Enemies Defeated!",
            "icon"        : #imageLiteral(resourceName: "snailhero2")
        ],
        "100 Enemies" : [
            "name"        : "Snailin' It: III",
            "description" : "100 Enemies Defeated!",
            "icon"        : #imageLiteral(resourceName: "snailhero2")
        ],
        "200 Enemies" : [
            "name"        : "Snailin' It: IV",
            "description" : "200 Enemies Defeated!",
            "icon"        : #imageLiteral(resourceName: "snailhero2")
        ],
        "500 Enemies" : [
            "name"        : "Snailin' It: V",
            "description" : "500 Enemies Defeated!",
            "icon"        : #imageLiteral(resourceName: "snailhero2")
        ],
        "1000 Enemies" : [
            "name"        : "Snailin' It: VI",
            "description" : "1000 Enemies Defeated!",
            "icon"        : #imageLiteral(resourceName: "snailhero2")
        ],
        
        // Purchases Series
        "First Weapon" : [
            "name"        : "Armed",
            "description" : "Purchased your first weapon!",
            "icon"        : #imageLiteral(resourceName: "warrior")
        ],
        "First Armor" : [
            "name"        : "Reinforcement",
            "description" : "Purchased your first piece of armor!",
            "icon"        : #imageLiteral(resourceName: "warrior")
        ],
        "First Potion" : [
            "name"        : "Glug, glug",
            "description" : "Purchased your first potion!",
            "icon"        : #imageLiteral(resourceName: "mage")
        ],
        
        // Damage Series
        "1000 Damage" : [
            "name" : "Rekt",
            "description" : "Dealt 1000 damage in one strike!",
            "icon"        : #imageLiteral(resourceName: "warrior")
        ]
    ]
    
    let nameAchievements: [String:[String:Any]] = [
        // Names Series
        "Algore Rhythms" : [
            "name"        : "Algore Rhythms",
            "description" : "Ray...",
            "icon"        : #imageLiteral(resourceName: "nameGenerator")
        ],
        "Phil Buckets" : [
            "name"        : "Phil Buckets",
            "description" : "A great basketball player.",
            "icon"        : #imageLiteral(resourceName: "nameGenerator")
        ],
        "Jill People" : [
            "name"        : "Jill People",
            "description" : "What a gal.",
            "icon"        : #imageLiteral(resourceName: "nameGenerator")
        ],
        "Beanbag Ben" : [
            "name"        : "Beanbag Ben",
            "description" : "Damn it, Andy.",
            "icon"        : #imageLiteral(resourceName: "nameGenerator")
        ],
        "Pem Pem" : [
            "name"        : "Pem Pem",
            "description" : "Don't forget your pem pems.",
            "icon"        : #imageLiteral(resourceName: "nameGenerator")
        ],
        "Andy McArver" : [
            "name"        : "Andy McArver",
            "description" : "Oh shit is the mic on?",
            "icon"        : #imageLiteral(resourceName: "nameGenerator")
        ],
        "Michael Choi" : [
            "name"        : "Michael Choi",
            "description" : "ChoiGod12",
            "icon"        : #imageLiteral(resourceName: "nameGenerator")
        ],
        "Tryit Bryit" : [
            "name"        : "Tryit Bryit",
            "description" : "There he goes...",
            "icon"        : #imageLiteral(resourceName: "nameGenerator")
        ],
        "Plebby the Pleb" : [
            "name"        : "Plebby the Pleb",
            "description" : "Plebians.",
            "icon"        : #imageLiteral(resourceName: "nameGenerator")
        ]
    ]
}
