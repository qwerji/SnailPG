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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let heroRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Hero")
        heroRequest.predicate = NSPredicate(format: "%K <= %D", "health", 0)
        do {
            let results = try context.fetch(heroRequest)
            graveyard = results as! [Hero]
        } catch {
            print("\(error)")
        }
        
        graveyardTable.delegate = self
        graveyardTable.dataSource = self
        
        graveyardTable.reloadData()

    }
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

}
