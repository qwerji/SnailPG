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
    @IBOutlet weak var shopNameLabel: UILabel!
    @IBOutlet weak var heroGoldLabel: UILabel!
    @IBOutlet weak var purchasedItemLabel: UILabel!
    @IBOutlet weak var purchasedItemModal: UIView!
    var timer = Timer()
  
    var loggedInHero: Hero?
    var shopInventory = [[String:Any]]()
    var shop = [String:Any]()
    
    @IBOutlet weak var storeInventoryTable: UITableView!
    
    @IBAction func sortSegmentPressed(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            update(with: "Weapon")
            break
        case 1:
            update(with: "Armor")
            break
        case 2:
            update(with: "Potion")
            break
        default:
            update(with: "All")
        }
        
    }
    
    func update(with sorter: String) {

        shopInventory = []
        let itemStrings = shop["items"] as! [String]
        
        if sorter != "All" {
            for key in itemStrings {
                if ItemList[key]?["type"] as! String == sorter {
                    shopInventory.append(ItemList[key]!)
                }
            }
        } else {
            for key in itemStrings {
                shopInventory.append(ItemList[key]!)
            }
        }
        
        shopInventory.sort {
            ($0["price"] as! Int) < ($1["price"] as! Int)
        }
        
        storeInventoryTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        let item = shopInventory[indexPath.row]
        let itemType = item["type"] as! String
        
        if itemType == "Weapon" {

            cell = tableView.dequeueReusableCell(withIdentifier: "weaponCell", for: indexPath) as! WeaponCell
            let weaponCell = cell as! WeaponCell
            weaponCell.configureCell(for: item)
            return weaponCell
            
        } else if itemType == "Armor" {

            cell = tableView.dequeueReusableCell(withIdentifier: "armorCell", for: indexPath) as! ArmorCell
            let armorCell = cell as! ArmorCell
            armorCell.configureCell(for: item)
            return armorCell
            
        } else {

            cell = tableView.dequeueReusableCell(withIdentifier: "potionCell", for: indexPath) as! PotionCell
            let potionCell = cell as! PotionCell
            potionCell.configureCell(for: item)
            return potionCell
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shopInventory.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = shopInventory[indexPath.row]
        let itemPrice = item["price"] as! Int
        if Int((loggedInHero?.gold)!) >= itemPrice {
            loggedInHero?.gold -= itemPrice
            loggedInHero?.addToBackpack(item["name"] as! String)
            purchasedItemLabel.text = "Purchased \((item["name"])!)"
            purchasedItemModal.backgroundColor = #colorLiteral(red: 0.1070112661, green: 0.5596725941, blue: 0, alpha: 1)
        } else {
            purchasedItemLabel.text = "You don't have enough gold."
            purchasedItemModal.backgroundColor = #colorLiteral(red: 0.9880134463, green: 0.2317890823, blue: 0.2497095466, alpha: 1)
        }
        
        purchasedItemModal.isHidden = false
        purchasedItemLabel.isHidden = false
        
        timer.invalidate()
        
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(modalTimerEnd), userInfo: nil, repeats: false)
        
        heroGoldLabel.text = "\((loggedInHero?.name!)!)'s Gold: \((loggedInHero?.gold)!)"
        ad.saveContext()
    }
    
    func modalTimerEnd() {
        purchasedItemLabel.isHidden = true
        purchasedItemModal.isHidden = true
    }
    
    @IBAction func exitButtonPressed(_ sender: UIButton) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        heroGoldLabel.text = "\((loggedInHero?.name)!)'s Gold: \((loggedInHero?.gold)!)"
        
        let area = Int((loggedInHero?.area)!)
        
        shop = AreaDataForIndex[area]!["shop"] as! [String : Any]
        
        shopNameLabel.text = shop["name"] as! String?
        
        update(with: "Weapon")
        
        storeInventoryTable.delegate = self
        storeInventoryTable.dataSource = self
        
        purchasedItemLabel.isHidden = true
        purchasedItemModal.isHidden = true
        
        storeInventoryTable.reloadData()
    }
    
}
