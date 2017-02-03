//
//  heroAbilities.swift
//  Snail Fantasy
//
//  Created by Andrew Carver on 1/25/17.
//  Copyright © 2017 Benjamin Swanson. All rights reserved.
//

import UIKit

extension Hero {
    func use(ability: String, target: Monster) -> (String, String){
        switch ability {
        case "Shield Bash":
            return self.shieldBash(target)
            break
        case "Desperate Strike":
            return self.desperateStrike(target)
            break
        case "Magic Missile":
            return self.magicMissile(target)
            break
        case "Cure":
            return self.cure()
            break
        case "Leech":
            return self.leech(target)
            break
        case "Mana Shield":
            return self.manaShield(target)
            break
        case "Back Stab":
            return self.backStab(target)
            break
        default:
            break
        }
    }
    //warrior abilites
    func shieldBash(_ target: Monster) -> (String, String){
        let spell = "Shield Bash"
        let shieldDamage = self.defense
        target.health -= Int(shieldDamage)
        self.mana -= 30
        let result = "Spell Cast"
        let log = "\(self.name) casts \(spell) and did \(shieldDamage) damage to \(target.name)!"
        return (log, result)
    }
    func desperateStrike(_ target: Monster) -> (String, String){
        let spell = "Desperate Strike"
        var computedDamage = 0
        let strikeChance = Int(arc4random_uniform(UInt32(10))) + 1
        if strikeChance == (1-5){
            computedDamage += Int(self.strength)
        }
        else{
            computedDamage = 0
        }
        self.mana -= 30
        let result = "Spell Cast"
        let log = "\(self.name) casts \(spell) and did \(computedDamage) damage to \(target.name)!"
        return (log, result)
    }
    //mage abilities
    func magicMissile(_ target: Monster) -> (String, String){
        let spell = "Magic Missile"
        let computedDamage = Int(arc4random_uniform(UInt32(Int(self.intelligence/2)))) + 1
        target.health -= computedDamage
        self.mana -= 30
        let result = "Spell Cast"
        let log = "\(self.name) casts \(spell) and did \(computedDamage) damage to \(target.name)!"
        return (log, result)
    }
    func cure() -> (String, String){
        let spell = "Cure"
        let healedDamage = Int(arc4random_uniform(UInt32(Int(self.intelligence/2)))) + 1
        self.health += healedDamage
        self.mana -= 30
        let result = "Spell Cast"
        let log = "\(self.name) casts \(spell) and healed \(healedDamage) damage!"
        return (log, result)
    }
    func leech(_ target: Monster) -> (String, String){
        let spell = "Leech"
        let leechedDamage = Int(arc4random_uniform(UInt32(Int(self.intelligence/4)))) + 1
        target.health -= leechedDamage
        self.health += leechedDamage
        self.mana -= 30
        let result = "Spell Cast"
        let log = "\(self.name) casts \(spell) and stole \(leechedDamage) health from \(target.name)!"
        return (log, result)
    }
    func manaShield(_ target: Monster) -> (String, String){
        let spell = "Mana Shield"
        let blockedDamage = Int(arc4random_uniform(UInt32(Int(self.intelligence/2)))) + 1
        target.damage -= blockedDamage
        self.mana -= 30
        let result = "Spell Cast"
        let log = "\(self.name) casts \(spell) and blocked \(blockedDamage) damage from \(target.name)!"
        return (log, result)
    }
    //thief abilities
    func backStab(_ target: Monster) -> (String, String){
        let spell = "Back Stab"
        let stabDamage = Int(self.dexterity * 2)
        target.damage -= stabDamage
        self.mana -= 40
        let result = "Spell Cast"
        let log = "\(self.name) casts \(spell) and blocked \(stabDamage) damage from \(target.name)!"
        return (log, result)
    }
}

let AbilityList : [String:[String:Any]] = [
    "Warrior": [
        "Shield Bash" : [
            "name" : "Shield Bash",
            "cost" : 30,
        ],
        "Desperate Strike" : [
            "name" : "Desperate Strike",
            "cost" : 30,
        ],
    ],
    "Mage": [
        "Magic Missile" : [
            "name" : "Magic Missile",
            "cost" : 30,
        ],
        "Cure" : [
            "name" : "Cure",
            "cost" : 30,
        ],
        "Leech" : [
            "name" : "Leech",
            "cost" : 30,
        ],
        "Mana Shield" : [
            "name" : "Mana Shield",
            "cost" : 30,
        ],
    ],
    "Thief": [
        "Back Stab" : [
            "name" : "Back Stab",
            "cost" : 40,
        ],
    ]
]





