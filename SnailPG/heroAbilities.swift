//
//  heroAbilities.swift
//  Snail Fantasy
//
//  Created by Andrew Carver on 1/25/17.
//  Copyright © 2017 Benjamin Swanson. All rights reserved.
//

import UIKit

extension Hero {
    
    //warrior abilites
    func battleRage(_ target: Hero){
        
    }
    //mage abilities
    func magicMissile(_ target: Monster) -> (String, String){
        let spell = "Magic Missile"
        let computedDamage = Int(arc4random_uniform(UInt32(Int(self.intelligence/2)))) + 1
        target.health -= computedDamage
        self.mana -= 10
        var result = "Spell Cast"
        var log = "\(self.name) cast \(spell) and did \(computedDamage) damage to \(target.name)!"
        return (log, result)
    }
    //thief abilities
    
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
            
        } else {
            
            // Base damage range
            computedDamage = Int(arc4random_uniform(UInt32(computedDamage - computedDamage/2))) + Int(computedDamage/2)
            
            log = "\(self.name!) did \(computedDamage) damage to \(target.name)!"
            result = "Base Hit"
            
        }
        
        target.health -= computedDamage
        
        return (log, result)
    }
    
}





