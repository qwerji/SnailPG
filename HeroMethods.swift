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
        
    }
}
