//
//  HeroMethods.swift
//  Snail Fantasy
//
//  Created by Ben Swanson on 1/17/17.
//  Copyright © 2017 Benjamin Swanson. All rights reserved.
//

import UIKit

extension Hero {
    
    func getGold(amount: Int) {
        self.gold += amount
    }
    
    //adds item to backpack
    func addToBackpack(_ item: String) {
        var bp = self.backpack as! [String]
        bp.append(item)
        self.backpack = bp as NSObject?
    }
    //removes item from backpack when it is being equipped
    func removeFromBackpack(at index: Int) {
        var bp = self.backpack as! [String]
        bp.remove(at: index)
        self.backpack = bp as NSObject?
    }
    
    func getHit(with damage: Int) {
        self.health -= damage
    }
    
    func attack(_ target: Monster) -> String {
        
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
            
        } else if hitChance == 10 {
            
            // Max damage
            log = "Critical hit! \(self.name!) did \(computedDamage) damage to \(target.name)!"
            
        } else {
            
            // Base damage range
            computedDamage = Int(arc4random_uniform(UInt32(computedDamage - computedDamage/2))) + Int(computedDamage/2)
            
            log = "\(self.name!) did \(computedDamage) damage to \(target.name)!"
            
        }
        
        target.health -= computedDamage
        
        return log
    }
    func gainsExp(amount: Int){
        self.experience += amount
        if self.experience >= self.expToLevel {
            experience -= expToLevel
            self.level += 1
            self.expToLevel = self.level * 100
            self.statPoints += 5
            if self.level == 10{
                
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
            case "Theif":
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
    func equip (armorPiece: String){
        self.defense = Int64(ItemList[armorPiece]!["defense"] as! Int)
    }
}





















