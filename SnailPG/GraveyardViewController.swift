//
//  GraveyardViewController.swift
//  Snail Fantasy
//
//  Created by Tyler Warren on 1/21/17.
//  Copyright © 2017 Benjamin Swanson. All rights reserved.
//

import UIKit
import CoreData

class GraveyardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var graveyardSearchBar: UISearchBar!
    @IBOutlet weak var graveyardTable: UITableView!
    
    var graveyard: [Hero] = []
    var refinedGraveyard: [Hero] = []
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "graveyardDetailSegue", sender: refinedGraveyard[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if let cell = graveyardTable.cellForRow(at: indexPath) as? graveyardCell {
            if cell.revivable {
                return true
            }
        }
        return false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            refinedGraveyard = graveyard
            graveyardTable.reloadData()
        } else {
            refineSearch(with: searchText)
        }
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let cell = graveyardTable.cellForRow(at: indexPath) as! graveyardCell
        let hero = refinedGraveyard[indexPath.row]
        let revive = UITableViewRowAction(style: .destructive, title: "Revive Hero") { (action, indexPath) in
            hero.health = hero.maxHealth / 10
            hero.removeFromBackpack(at: cell.potionIndex!)
            self.update()
            self.graveyardTable.reloadData()
        }
        
        revive.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        
        return [revive]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "graveyardCell", for: indexPath) as! graveyardCell
        cell.configureCell(for: refinedGraveyard[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return refinedGraveyard.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "graveyardDetailSegue" {
            let controller = segue.destination as! GraveyardDetailViewController
            controller.hero = sender as! Hero
        }
    }
    
    func update() {
        if let deadHeroes = Hero.allDead() {
            graveyard = deadHeroes
            refinedGraveyard = graveyard
        }
        graveyardTable.reloadData()
    }
    
    func refineSearch(with terms: String) {
        refinedGraveyard = []
        for hero in graveyard {
            if (hero.name?.lowercased().contains(terms.lowercased()))! {
                refinedGraveyard.append(hero)
            }
        }
        graveyardTable.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        graveyardTable.delegate = self
        graveyardTable.dataSource = self
        graveyardSearchBar.delegate = self
        
        graveyardSearchBar.showsCancelButton = false
        
        update()
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }

}
