//
//  HeroInit.swift
//  Snail Fantasy
//
//  Created by Ben Swanson on 1/25/17.
//  Copyright © 2017 Benjamin Swanson. All rights reserved.
//

import UIKit

extension Hero {
    
    func config(for _job: Int, with _name: String){
        switch _job {
        case 0:
            job          = "Warrior"
            strength     = 10
            dexterity    = 6
            intelligence = 2
            icon         = #imageLiteral(resourceName: "warrior")
            break
        case 1:
            job          = "Mage"
            strength     = 2
            dexterity    = 6
            intelligence = 10
            icon         = #imageLiteral(resourceName: "mage")
            break
        case 2:
            job          = "Thief"
            strength     = 2
            dexterity    = 10
            intelligence = 6
            icon         = #imageLiteral(resourceName: "thief")
            break
        default: break
        }
        
        maxArea    = 0
        area       = 0
        maxHealth  = 50
        defense    = 0
        health     = 50
        maxMana    = intelligence * 5
        mana       = intelligence * 5
        level      = 1
        experience = 0
        expToLevel = 100
        statPoints = 5
        victories  = 0
        name       = _name
        backpack   = NSArray()
    }
    
}
