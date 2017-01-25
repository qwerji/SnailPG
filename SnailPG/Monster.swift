//
//  Monster.swift
//  Snail Fantasy
//
//  Created by Ben Swanson on 1/19/17.
//  Copyright © 2017 Benjamin Swanson. All rights reserved.
//

import Foundation

class Monster {
    
    var name: String
    var health: Int
    var gold: Int
    var damage: Int
    var drop: String?
    var experience: Int
    var speed: Int
    
    init(name: String, health: Int, gold: Int, damage: Int, drop: String? = nil, experience: Int, speed: Int) {
        self.name = name
        self.health = health
        self.gold = gold
        self.damage = damage
        self.drop = drop
        self.experience = experience
        self.speed = speed
    }
    
    func attack(_ hero: Hero) -> (String, String) {
        var result = ""
        var log = ""
        var computedDamage = self.damage
        
        let hitChance = Int(arc4random_uniform(UInt32(10))) + 1
        
        if hitChance == 1 {
            
            // Miss
            computedDamage = 0
            
            log = "\(self.name) missed!"
            result = "Miss"
            
        } else if hitChance == 10 {
            
            // Max damage
            log = "Critical Hit! \(self.name) did \(computedDamage) damage to \(hero.name!)!"
            result = "Base Damage"
            
        } else {
            
            // Base damage range
            computedDamage = Int(arc4random_uniform(UInt32(computedDamage - computedDamage/2))) + Int(computedDamage/2)
            
            log = "\(self.name) did \(computedDamage) damage to \(hero.name!)!"
            result = "Base Damage"
            
        }
        
        if computedDamage > 0 && hero.defense > 0 {
            log += " \(hero.defense) blocked by armor."
        }
        
        if computedDamage - Int(hero.defense) > 0 {
            hero.health -= (computedDamage - Int(hero.defense))
        }
        
        return (log, result)
    }
}

let AreaDataForIndex: [Int:[String:Any]] = [
    0 : [
        "name"     : "Snail Meadow",
        "monsters" : [
            "Goblin Pleb",
            "Basic Snail",
            "Prancing Pony",
            "Slimer",
            "Greater Snail",
            "Snail Junkie"
        ]
    ],
    1 : [
        "name"     : "Haunted Forest",
        "monsters" : [
            "Mecha Snail",
            "Snail Dragon",
            "Land Shark",
            "Greater Snail",
            "Lava Lord"
        ]
    ],
    2 : [
        "name"     : "Goblin Outpost",
        "monsters" : [
            "Snail Dragon",
            "Lesser Dragon",
            "Vampire Snail",
            "Evil Shopkeep",
            "Rat Monkey",
            "Goblin Elite"
        ]
    ]
]

let MonsterList: [String:[String:Any]] = [
    "Goblin Pleb" : [
        "name"       : "Goblin Pleb",
        "area"       : 0,
        "health"     : 30,
        "damage"     : 8,
        "speed"      : 3,
        "gold"       : 10,
        "experience" : 15
    ],
    "Basic Snail" : [
        "name"       : "Basic Snail",
        "area"       : 0,
        "health"     : 20,
        "damage"     : 5,
        "speed"      : 2,
        "gold"       : 10,
        "experience" : 5
    ],
    "Mecha Snail" : [
        "name"       : "Mecha Snail",
        "area"       : 0,
        "health"     : 35,
        "damage"     : 10,
        "speed"      : 4,
        "gold"       : 20,
        "experience" : 30
    ],
    "Prancing Pony" : [
        "name"       : "Prancing Pony",
        "area"       : 0,
        "health"     : 25,
        "damage"     : 7,
        "speed"      : 8,
        "gold"       : 10,
        "experience" : 15
    ],
    "Snail Dragon" : [
        "name"       : "Snail Dragon",
        "area"       : 0,
        "health"     : 30,
        "damage"     : 10,
        "speed"      : 4,
        "gold"       : 35,
        "experience" : 35
    ],
    "Lesser Dragon" : [
        "name"       : "Lesser Dragon",
        "area"       : 0,
        "health"     : 40,
        "damage"     : 15,
        "speed"      : 6,
        "gold"       : 50,
        "experience" : 50
    ],
    "Slimer" : [
        "name"       : "Slimer",
        "area"       : 0,
        "health"     : 15,
        "damage"     : 10,
        "speed"      : 7,
        "gold"       : 10,
        "experience" : 15
    ],
    "Vampire Snail" : [
        "name"       : "Vampire Snail",
        "area"       : 0,
        "health"     : 20,
        "damage"     : 12,
        "speed"      : 4,
        "gold"       : 15,
        "experience" : 20
    ],
    "Land Shark" : [
        "name"       : "Land Shark",
        "area"       : 0,
        "health"     : 40,
        "damage"     : 20,
        "speed"      : 6,
        "gold"       : 100,
        "experience" : 100
    ],
    "Greater Snail" : [
        "name"       : "Greater Snail",
        "area"       : 0,
        "health"     : 20,
        "damage"     : 10,
        "speed"      : 5,
        "gold"       : 30,
        "experience" : 20
    ],
    "Evil Shopkeep" : [
        "name"       : "Evil Shopkeep",
        "area"       : 0,
        "health"     : 80,
        "damage"     : 7,
        "speed"      : 2,
        "gold"       : 80,
        "experience" : 70
    ],
    "Lava Lord" : [
        "name"       : "Lava Lord",
        "area"       : 0,
        "health"     : 35,
        "damage"     : 20,
        "speed"      : 5,
        "gold"       : 50,
        "experience" : 50
    ],
    "Snail Junkie" : [
        "name"       : "Snail Junkie",
        "area"       : 0,
        "health"     : 50,
        "damage"     : 18,
        "speed"      : 5,
        "gold"       : 20,
        "experience" : 30
    ],
    "Rat Monkey" : [
        "name"       : "Rat Monkey",
        "area"       : 0,
        "health"     : 45,
        "damage"     : 20,
        "speed"      : 10,
        "gold"       : 60,
        "experience" : 60
    ],
    "Goblin Elite" : [
        "name"       : "Goblin Elite",
        "area"       : 0,
        "health"     : 40,
        "damage"     : 15,
        "speed"      : 6,
        "gold"       : 40,
        "experience" : 40
    ],
]
