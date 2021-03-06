//
//  RandomNameGenerator.swift
//  Snail Fantasy
//
//  Created by Ben Swanson on 1/25/17.
//  Copyright © 2017 Benjamin Swanson. All rights reserved.
//

import Foundation

class RandomNameGenerator {
    
    let firstNames = ["Jill","Bill","Phil","Stranky","Mooper","Bryit","Andu","Vulf","Victor","Timmy","Wilthas","Ophelia","Pappy","Pamela","Vicki","Coni","Amber","Sara","Leah","Dan","Benjamin","Michelle","Nasim","Luca","Algore","Maloc","Brandon","Doj","Porkle","Pem","Fiaz","Django","Nancy","Sparkle","Grampy","Jack","Glenn","Lars","Berry","Magic","Spider","Taco","Hawaiian","Magnus","Frothgar","Gorlok","The","Ty","Beanbag","Plebby","Mad","Andy","Larry","Karl","Margie","Miguel","Madame","Buzz","Alex","Yung","Bud","Greg","Kukrim","PJ","Alycia","David","Java","Giffy","Ray","Michael","Devon","Json","Liz","Roshawn","Charlie","Leo","Kathleen","Nick","Kai","TJ","Quinten","Sloop","Frobe"]
    let lastNames = ["People","Buckets","Dustkeeper","Hawkarrow","LoneMane","Boulderbreaker","Ashridge","Bryit","Deathseeker","Mandu","Snowmane","Kingslayer","Swiftfoot","Mountainscream","Moonshadow","Voidstrider","Moonthorn","Grandcrest","Stinkz","Rhythms","Pem","Ponies","Darksider","Saltshaker","Riverchaser","Wyvernbeard","Treegazer","Fogbinder","Dragonblood","Dawncrest","WildShard","Bronzefist","Shieldbearer","Gangletoes","FizzBuzz","Donglegoblin","Cloudstriker","Goodbrancher","Bluejeans","Coffee","Brian","Ben","the Pleb","Bingo","the Squillzord","the Forgotten","Choi","MacArver","Getsit","Button","Mongod","Swapi","John B","the Warrior","the Mage","the Thief","Bryant"]
    
    var getName: String {
        get {
            
            func randomInt(ceiling: Int) -> Int {
                return Int(arc4random_uniform(UInt32(ceiling)))
            }
            
            let firstNameOnly = randomInt(ceiling: 2) == 0
            
            var generatedName = ""
            
            if !firstNameOnly {
                generatedName += " " + lastNames[randomInt(ceiling: lastNames.count)]
            }
            
            generatedName = firstNames[randomInt(ceiling: firstNames.count)] + generatedName
            
            return generatedName
            
        }
    }
}
