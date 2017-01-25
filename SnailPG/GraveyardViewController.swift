//
//  GraveyardViewController.swift
//  Snail Fantasy
//
//  Created by Tyler Warren on 1/21/17.
//  Copyright © 2017 Benjamin Swanson. All rights reserved.
//

import UIKit
import CoreData

class GraveyardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var graveyardTable: UITableView!

    var graveyard: [Hero] = []
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if let cell = graveyardTable.cellForRow(at: indexPath) as? graveyardCell {
            if cell.revivable {
                return true
            }
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let cell = graveyardTable.cellForRow(at: indexPath) as! graveyardCell
        let hero = graveyard[indexPath.row]
        let revive = UITableViewRowAction(style: .destructive, title: "Revive Hero") { (action, indexPath) in
            hero.health = hero.maxHealth / 10
            hero.removeFromBackpack(at: cell.potionIndex!)
            ad.saveContext()
            self.update()
            self.graveyardTable.reloadData()
        }
        
        revive.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        
        return [revive]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "graveyardCell", for: indexPath) as! graveyardCell
        cell.configureCell(for: graveyard[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return graveyard.count
    }
    
    func update() {
        let heroRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Hero")
        heroRequest.predicate = NSPredicate(format: "%K <= %D", "health", 0)
        do {
            let results = try context.fetch(heroRequest)
            graveyard = results as! [Hero]
        } catch {
            print("\(error)")
        }
        graveyardTable.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        graveyardTable.delegate = self
        graveyardTable.dataSource = self

        update()
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }

}
