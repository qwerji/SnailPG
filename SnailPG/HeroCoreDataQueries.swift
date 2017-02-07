//
//  HeroCoreDataQueries.swift
//  Snail Fantasy
//
//  Created by Ben Swanson on 2/7/17.
//  Copyright © 2017 Benjamin Swanson. All rights reserved.
//

import CoreData

extension Hero {
    
    class func createNewHero(job: Int, name: String) -> Hero {
        let hero = NSEntityDescription.insertNewObject(forEntityName: "Hero", into: context) as! Hero
        hero.config(for: job, with: name)
        return hero
    }
    
    class func allLiving() -> [Hero]? {
        let heroRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Hero")
        heroRequest.predicate = NSPredicate(format: "%K > %D", "health", 0)
        do {
            return try context.fetch(heroRequest) as? [Hero]
        } catch {
            print("\(error)")
        }
        return nil
    }
    
    class func allDead() -> [Hero]? {
        let heroRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Hero")
        heroRequest.predicate = NSPredicate(format: "%K <= %D", "health", 0)
        do {
            return try context.fetch(heroRequest) as? [Hero]
        } catch {
            print("\(error)")
        }
        return nil
    }
    
}
