//
//  HeroSelectViewController.swift
//  SnailPG
//
//  Created by Ben Swanson on 1/12/17.
//  Copyright © 2017 Benjamin Swanson. All rights reserved.
//

import UIKit
import CoreData

class HeroSelectViewController: UIViewController {
    @IBOutlet weak var previousHeroesLabel: UILabel!
    @IBOutlet weak var previousHeroesTable: UITableView!
    var previousHeroes = [Hero]()
    var loggedInHero: Hero?
    
    @IBAction func unwindToWelcome(segue: UIStoryboardSegue) {
        update()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! MainViewController
        controller.loggedInHero = self.loggedInHero
    }
    
    func update() {
        // Get previous heroes that are not dead
        let heroRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Hero")
        heroRequest.predicate = NSPredicate(format: "%K > %D", "health", 0)
        do {
            let results = try context.fetch(heroRequest)
            previousHeroes = results as! [Hero]
        } catch {
            print("\(error)")
        }
        
        if previousHeroes.isEmpty {
            previousHeroesTable.isHidden = true
            previousHeroesLabel.isHidden = true
        } else {
            previousHeroesTable.isHidden = false
            previousHeroesLabel.isHidden = false
        }
        previousHeroesTable.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        previousHeroesTable.dataSource = self
        previousHeroesTable.delegate = self
        update()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        update()
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}

extension HeroSelectViewController: UITableViewDataSource, UITableViewDelegate {
    
    // Get row count
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return previousHeroes.count
    }
    
    // Set rows to previous hero names
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "continueCell", for: indexPath) as! continueCell
        cell.configureCell(for: previousHeroes[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    // When pressed, log into that hero
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        loggedInHero = previousHeroes[indexPath.row]
        self.performSegue(withIdentifier: "heroCreation", sender: nil)
    }
    
}
