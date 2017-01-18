//
//  ShopViewController.swift
//  Snail Fantasy
//
//  Created by Ben Swanson on 1/16/17.
//  Copyright © 2017 Benjamin Swanson. All rights reserved.
//

import UIKit
import CoreData

class ShopViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var heroGoldLabel: UILabel!
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
  
    var loggedInHero: Hero?
    var storeInventory = [Item]()
    @IBOutlet weak var storeInventoryTable: UITableView!
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell")!
        cell.textLabel?.text = "\(storeInventory[indexPath.row].name!) - \(storeInventory[indexPath.row].price)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storeInventory.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = storeInventory[indexPath.row]
        if (loggedInHero?.gold)! >= item.price {
            loggedInHero?.gold -= item.price
            loggedInHero?.addToInventory(item)
        } else {
            print("Not enough monies")
        }
        heroGoldLabel.text = "\((loggedInHero?.name!)!)'s Gold: \((loggedInHero?.gold)!)"
        appDelegate.saveContext()
    }
    
    @IBAction func exitButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        heroGoldLabel.text = "\((loggedInHero?.name)!)'s Gold: \((loggedInHero?.gold)!)"
        
        let itemRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
        do {
            let results = try managedObjectContext.fetch(itemRequest)
            storeInventory = results as! [Item]
            
        } catch {
            print("\(error)")
        }
        
        heroGoldLabel.text = "\((loggedInHero?.name!)!)'s Gold: \((loggedInHero?.gold)!)"
        
        storeInventoryTable.delegate = self
        storeInventoryTable.dataSource = self
        
        storeInventoryTable.reloadData()
    }
    
}
