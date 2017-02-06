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
        
        let name: String
        let health: Int
        let gold: Int
        let damage: Int
        let drop: String? = nil
        let experience: Int
        let speed: Int
        
        switch monsterName {
        //Trash mob - Area 0
        case "Evil Dandelion":
            name       = "Evil Dandelion"
            health     = 15
            damage     = 2
            speed      = 3
            gold       = 1
            experience = 3
            break
        //Trash mob - Area 0
        case "Zoop Zoop":
            name       = "Zoop Zoop"
            health     = 15
            damage     = 2
            speed      = 3
            gold       = 1
            experience = 3
            break
        //Trash mob - Area 0
        case "Angry Squirrel":
            name       = "Angry Squirrel"
            health     = 20
            damage     = 4
            speed      = 2
            gold       = 3
            experience = 10
            break
        //Trash mob - Area 0
        case "Overgrown Centipede":
            name       = "Overgrown Centipede"
            health     = 40
            damage     = 2
            speed      = 2
            gold       = 5
            experience = 10
            break
        //Trash mob - Area 0
        case "King Zooper":
            name       = "King Zooper, King of Zoop Zoops"
            health     = 50
            damage     = 3
            speed      = 2
            gold       = 5
            experience = 10
            break
        //Trash mob - Area 1
        case "Farm Snail":
            name       = "Farm Snail"
            health     = 95
            damage     = 2
            speed      = 3
            gold       = 20
            experience = 60
            break
        //Trash mob - Area 1
        case "Basic Snail":
            name       = "Basic Snail"
            health     = 60
            damage     = 10
            speed      = 2
            gold       = 15
            experience = 50
            break
        //Trash mob - Area 1
        case "Slimer":
            name       = "Slimer"
            health     = 145
            damage     = 5
            speed      = 4
            gold       = 30
            experience = 35
            break
        //Trash mob - Area 1
        case "Prancing Pony":
            name       = "Prancing Pony"
            health     = 155
            damage     = 4
            speed      = 8
            gold       = 16
            experience = 30
            break
        //Elite mob - Area 1
        case "Greater Snail":
            name       = "Greater Snail"
            health     = 260
            damage     = 14
            speed      = 4
            gold       = 35
            experience = 100
            break
        case "Lesser Dragon":
            name       = "Lesser Dragon"
            health     = 40
            damage     = 15
            speed      = 6
            gold       = 50
            experience = 50
            break
        case "Mecha Snail":
            name       = "Mecha Snail"
            health     = 18
            damage     = 10
            speed      = 7
            gold       = 10
            experience = 15
            break
        case "Vampire Snail":
            name       = "Vampire Snail"
            health     = 20
            damage     = 12
            speed      = 4
            gold       = 15
            experience = 20
            break
        case "Land Shark":
            name       = "Land Shark"
            health     = 40
            damage     = 20
            speed      = 6
            gold       = 100
            experience = 100
            break
        case "Snail Dragon":
            name       = "Snail Dragon"
            health     = 20
            damage     = 10
            speed      = 5
            gold       = 30
            experience = 20
            break
        case "Evil Shopkeep":
            name       = "Evil Shopkeep"
            health     = 80
            damage     = 7
            speed      = 2
            gold       = 80
            experience = 70
            break
        case "Lava Lord":
            name       = "Lava Lord"
            health     = 35
            damage     = 20
            speed      = 5
            gold       = 50
            experience = 50
            break
        case "Snail Junkie":
            name       = "Snail Junkie"
            health     = 30
            damage     = 15
            speed      = 5
            gold       = 35
            experience = 30
            break
        case "Rat Monkey":
            name       = "Rat Monkey"
            health     = 45
            damage     = 20
            speed      = 10
            gold       = 60
            experience = 60
            break
        case "Goblin Elite":
            name       = "Goblin Elite"
            health     = 40
            damage     = 15
            speed      = 6
            gold       = 40
            experience = 40
            break
        default:
            name       = "Evil Dandelion"
            health     = 15
            damage     = 2
            speed      = 3
            gold       = 1
            experience = 3
            break
        }
        
        return Monster(name: name, health: health, gold: gold, damage: damage, drop: drop, experience: experience, speed: speed)
    }
}
