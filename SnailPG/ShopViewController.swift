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
    var storeInventory = [[String:Any]]()
    @IBOutlet weak var storeInventoryTable: UITableView!
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell")!
        cell.textLabel?.text = "\(storeInventory[indexPath.row]["name"]!)"
        cell.detailTextLabel?.text = "\(storeInventory[indexPath.row]["price"]!)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storeInventory.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = storeInventory[indexPath.row]
        let itemPrice = item["price"] as! Int
        if Int((loggedInHero?.gold)!) >= itemPrice {
            loggedInHero?.gold -= itemPrice
            loggedInHero?.addToBackpack(item["name"] as! String)
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
        
        for (key, _) in ItemList {
            storeInventory.append(ItemList[key]!)
        }
        
        storeInventoryTable.delegate = self
        storeInventoryTable.dataSource = self
        
        storeInventoryTable.reloadData()
    }
    
}
