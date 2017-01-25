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
        let result = "Spell Cast"
        let log = "\(self.name) cast \(spell) and did \(computedDamage) damage to \(target.name)!"
        return (log, result)
    }
    //thief abilities
    

}





