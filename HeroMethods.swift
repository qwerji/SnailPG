//
//  HeroMethods.swift
//  Snail Fantasy
//
//  Created by Ben Swanson on 1/17/17.
//  Copyright © 2017 Benjamin Swanson. All rights reserved.
//

import UIKit
import FirebaseAuth

extension Hero {
    
    func drink(potion: [String:Any]) {
        if potion["name"] as! String == "Health Potion" {
            if health + 20 > maxHealth {
                health = maxHealth
            } else {
                health += 20
            }
        } else if potion["name"] as! String == "Mana Potion" {
            if mana + 20 > maxMana {
                mana = maxMana
            } else {
                mana += 20
            }
        }
        ad.saveContext()
    }
    
    func equip(armorPiece: [String:Any]) {
        if let a = armor {
            addToBackpack(a)
        }
        armor = armorPiece["name"] as! String?
        defense = Int64(armorPiece["defense"] as! Int)
        ad.saveContext()
    }
    
    func equip(weapon: [String:Any]) {
        if let lh = leftHand {
            if let rh = rightHand {
                addToBackpack(rh)
            }
            if weapon["handed"] as! Int == 2 {
                addToBackpack(lh)
                rightHand = nil
            } else {
                if ItemList[leftHand!]?["handed"] as! Int == 1 {
                    rightHand = leftHand
                } else {
                    addToBackpack(lh)
                }
            }
        }
        leftHand = weapon["name"] as! String?
        ad.saveContext()
    }
    
    func incrementFirebaseVictories() {
        if let user = FIRAuth.auth()?.currentUser {
            ref.child("users").child(user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                if let currentTotalVictories = (snapshot.value as? NSDictionary)?["totalVictories"] as? Int {
                    ref.child("users/\(user.uid)/totalVictories").setValue(currentTotalVictories + 1)
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    func cleanBackpackOnDeath() {
        var cleanBackpack = [String]()
        for item in backpackArray() {
            if item == "Revive Potion" {
                cleanBackpack.append(item)
            }
        }
        backpack = cleanBackpack as NSObject?
    }
    
    func backpackArray() -> [String] {
        return backpack as! [String]
    }
    
    func canUseEscapePotion() -> Bool {
        let bp = backpackArray()
        for i in 0..<bp.count {
            if bp[i] == "Escape Potion" {
                removeFromBackpack(at: i)
                return true
            }
        }
        return false
    }
    
    func didReachVictoriesAchievement() -> String? {
        
        var potentialAchievement: String?
        switch victories {
        case 1:
            potentialAchievement = "Won A Battle"
            break
        case 50:
            potentialAchievement = "50 Enemies"
            break
        case 100:
            potentialAchievement = "100 Enemies"
            break
        case 200:
            potentialAchievement = "200 Enemies"
            break
        case 500:
            potentialAchievement = "500 Enemies"
            break
        case 1000:
            potentialAchievement = "1000 Enemies"
            break
        default: break
        }
        if let ach = potentialAchievement {
            let heroDidNotAlreadyHaveAchievement = achieve(ach)
            if heroDidNotAlreadyHaveAchievement {
                return ach
            }
        }
        return nil
        
    }
    
    func achieve(_ potentialAchievement: String) -> Bool {
        var achievements = self.achievements as! [String]
        for achievement in achievements {
            if achievement == potentialAchievement {
                return false
            }
        }
        achievements.append(potentialAchievement)
        self.achievements = achievements as NSObject?
        return true
    }
    
    func getGold(amount: Int) {
        self.gold += amount
    }
    
    //adds item to backpack
    func addToBackpack(_ item: String) {
        var bp = backpackArray()
        bp.append(item)
        self.backpack = bp as NSObject?
        ad.saveContext()
    }
    //removes item from backpack when it is being equipped
    func removeFromBackpack(at index: Int) {
        var bp = backpackArray()
        bp.remove(at: index)
        self.backpack = bp as NSObject?
        ad.saveContext()
    }
    
    func getHit(with damage: Int) {
        self.health -= damage
    }
    
    func attack(_ target: Monster) -> (String, String) {
        var result = ""
        var log = ""
        var computedDamage = Int(self.strength)

        if let weapon = self.leftHand {
            computedDamage += ItemList[weapon]?["damage"] as! Int
        }
        if let weapon = self.rightHand {
            computedDamage += ItemList[weapon]?["damage"] as! Int
        }
        
        let hitChance = Int(arc4random_uniform(UInt32(10))) + 1
        if hitChance == 1 {
            
            // Miss
            computedDamage = 0
            
            log = "\(self.name!) missed!"
            result = "Miss"
            
        } else if hitChance == 10 {
            
            // Max damage
            log = "Critical hit! \(self.name!) did \(computedDamage) damage to \(target.name)!"
            result = "Base Hit"
            if self.job == "Mage" {
                let sparks = mageSparkDamage()
                log += sparks.0
                target.health -= sparks.1
            }
            
        } else {
            // Base damage range
            computedDamage = Int(arc4random_uniform(UInt32(computedDamage - computedDamage/2))) + Int(computedDamage/2)
            
            log = "\(self.name!) did \(computedDamage) damage to \(target.name)!"
            result = "Base Hit"
            
            if self.job == "Mage" {
                let sparkChance = arc4random_uniform(UInt32(10)) + 1
                if Int(sparkChance) <= Int(4 + (intelligence/480)) {
                    let sparks = mageSparkDamage()
                    log += sparks.0
                    target.health -= sparks.1
                }
            }
        }
        
        target.health -= computedDamage
        return (log, result)
    }
    func mageSparkDamage()-> (String,Int){
            let roundedDOWNIntelligence = floor(Double(self.intelligence)/4.0)
            let roundedUPIntelligence = ceil(Double(self.intelligence)/4.0)
            let sparkDamage = Int(arc4random_uniform(UInt32(roundedUPIntelligence)+1)) + Int(roundedDOWNIntelligence)
            return (" +\(sparkDamage) dealt from spark!", sparkDamage)
    }
    
    func maxManaCalculation(){
        self.maxMana = self.intelligence * 5
    }
    
    func gainsExp(amount: Int){
        self.experience += amount
        self.victories += 1
        if self.experience >= self.expToLevel {
            self.experience -= expToLevel
            self.level += 1
            self.expToLevel = self.level * 100
            self.statPoints += 5
            
            if self.level > 0 && self.level % 5 == 0 {
                self.maxArea += 1
                
                if self.area < self.maxArea - 1 {
                    self.area = self.maxArea - 1
                }
                
            }
            
            ad.saveContext()
        }
    }
    func addToStat(with index: Int){
        switch index {
        // HEALTH POINTS
        case 0:
            self.statPoints -= 1
            self.maxHealth += 5
            break
        // STRENGTH
        case 1:
            self.statPoints -= 1
            if self.job! == "Warrior" {
                self.strength += 2
            } else {
                self.strength += 1
            }
            break
        // DEXTERITY
        case 2:
            self.statPoints -= 1
            switch self.job! {
            case "Warrior":
                self.dexterity += 2
                break
            case "Thief":
                self.dexterity += 3
                break
            default:
                self.dexterity += 1
                break
            }
            break
        // INTELLIGENCE
        case 3:
            self.statPoints -= 1
            if self.job! == "Mage" {
                self.intelligence += 4
            } else {
                self.intelligence += 1
            }
            break
        default:
            break
        }
    }
    func removeFromStat(with index: Int, minStat: Int){
        
        switch index {
        // HEALTH POINTS
        case 0:
            if self.maxHealth - 5 >= minStat {
                self.statPoints += 1
                self.maxHealth -= 5
            }
            break
        // STRENGTH
        case 1:
            
            if self.job! == "Warrior" {
                if self.strength - 2 >= minStat {
                    self.strength -= 2
                    self.statPoints += 1
                }
            } else {
                if self.strength - 1 >= minStat {
                    self.strength -= 1
                    self.statPoints += 1
                }
            }
            break
        // DEXTERITY
        case 2:
            switch self.job! {
            case "Warrior":
                if self.dexterity - 2 >= minStat {
                    self.dexterity -= 2
                    self.statPoints += 1
                }
                break
            case "Theif":
                if self.dexterity - 3 >= minStat {
                    self.dexterity -= 3
                    self.statPoints += 1
                }
                break
            default:
                if self.dexterity - 1 >= minStat {
                    self.dexterity -= 1
                    self.statPoints += 1
                }
                break
            }
            break
        // INTELLIGENCE
        case 3:
            if self.job! == "Mage" {
                if self.intelligence - 4 >= minStat {
                    self.intelligence -= 4
                    self.statPoints += 1
                }
            } else {
                if self.intelligence - 1 >= minStat {
                    self.intelligence -= 1
                    self.statPoints += 1
                }
            }
            break
        default:
            break
        }
    }
}





















