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
    
    init(_ rawData: [String:Any]) {
        self.name       = rawData["name"] as! String
        self.health     = rawData["health"] as! Int
        self.gold       = rawData["gold"] as! Int
        self.damage     = rawData["damage"] as! Int
        self.drop       = rawData["drop"] as! String?
        self.experience = rawData["experience"] as! Int
        self.speed      = rawData["speed"] as! Int
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
        var blockedDmg = 0
        let blockChance = Int(arc4random_uniform(100))+1
        if computedDamage > 0 && blockChance <= Int(hero.defense) {
            log += " \(hero.defense) blocked by armor. Total damage(\(computedDamage - Int(hero.defense)))"
            blockedDmg = Int(hero.defense)
        } else {
            blockedDmg = 0
        }
        
        if computedDamage - blockedDmg > 0 {
            hero.health -= (computedDamage - blockedDmg)
        }
        
        return (log, result)
    }
}

class MonsterManager {
    static let sharedInstance = MonsterManager()
    
    func getMonster(for hero: Hero) -> Monster {
        
        let areaData = AreaDataForIndex[Int(hero.area)]
        let monsterPoolPick = Int(arc4random_uniform(100)) + 1
        var areaMonsters = [String]()
        if monsterPoolPick <= 5 {
            areaMonsters = areaData?["elites"] as! [String]
        } else {
            areaMonsters = areaData?["monsters"] as! [String]
        }
        let randomMonsterIdx = Int(arc4random_uniform(UInt32(areaMonsters.count)))
        let monsterName = areaMonsters[randomMonsterIdx]
        let monsterChoice = MonsterList[monsterName]!
        
        return Monster(monsterChoice)
    }
    
    let MonsterList: [String:[String:Any]] = [
        //Trash mob - Area 0
        "Evil Dandelion" : [
            "name"       : "Evil Dandelion",
            "area"       : 0,
            "health"     : 15,
            "damage"     : 2,
            "speed"      : 3,
            "gold"       : 1,
            "experience" : 3
        ],
        //Trash mob - Area 0
        "Zoop Zoop" : [
            "name"       : "Zoop Zoop",
            "area"       : 0,
            "health"     : 15,
            "damage"     : 2,
            "speed"      : 3,
            "gold"       : 1,
            "experience" : 3
        ],
        //Trash mob - Area 0
        "Angry Squirrel" : [
            "name"       : "Angry Squirrel",
            "area"       : 0,
            "health"     : 20,
            "damage"     : 4,
            "speed"      : 2,
            "gold"       : 3,
            "experience" : 10
        ],
        //Trash mob - Area 0
        "Overgrown Centipede" : [
            "name"       : "Overgrown Centipede",
            "area"       : 0,
            "health"     : 40,
            "damage"     : 2,
            "speed"      : 2,
            "gold"       : 5,
            "experience" : 10
        ],
        //Trash mob - Area 0
        "King Zooper" : [
            "name"       : "King Zooper, King of Zoop Zoops",
            "area"       : 0,
            "health"     : 50,
            "damage"     : 3,
            "speed"      : 2,
            "gold"       : 5,
            "experience" : 10
        ],
        //Trash mob - Area 1
        "Farm Snail" : [
            "name"       : "Farm Snail",
            "area"       : 1,
            "health"     : 95,
            "damage"     : 2,
            "speed"      : 3,
            "gold"       : 20,
            "experience" : 60
        ],
        //Trash mob - Area 1
        "Basic Snail" : [
            "name"       : "Basic Snail",
            "area"       : 1,
            "health"     : 60,
            "damage"     : 10,
            "speed"      : 2,
            "gold"       : 15,
            "experience" : 50
        ],
        //Trash mob - Area 1
        "Slimer" : [
            "name"       : "Slimer",
            "area"       : 1,
            "health"     : 145,
            "damage"     : 5,
            "speed"      : 4,
            "gold"       : 30,
            "experience" : 35
        ],
        //Trash mob - Area 1
        "Prancing Pony" : [
            "name"       : "Prancing Pony",
            "area"       : 1,
            "health"     : 155,
            "damage"     : 4,
            "speed"      : 8,
            "gold"       : 16,
            "experience" : 30
        ],
        //Elite mob - Area 1
        "Greater Snail" : [
            "name"       : "Greater Snail",
            "area"       : 1,
            "health"     : 260,
            "damage"     : 14,
            "speed"      : 4,
            "gold"       : 35,
            "experience" : 100
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
        "Mecha Snail" : [
            "name"       : "Mecha Snail",
            "area"       : 0,
            "health"     : 18,
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
        "Snail Dragon" : [
            "name"       : "Snail Dragon",
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
            "health"     : 30,
            "damage"     : 15,
            "speed"      : 5,
            "gold"       : 35,
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
    
}
