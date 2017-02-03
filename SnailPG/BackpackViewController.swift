//
//  BackpackViewController.swift
//  Snail Fantasy
//
//  Created by Ben Swanson on 1/19/17.
//  Copyright © 2017 Benjamin Swanson. All rights reserved.
//

import UIKit
import CoreData

class BackpackViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var loggedInHero: Hero?
    var backpack = [String]()
    
    @IBOutlet weak var backpackTable: UITableView!
    
    @IBOutlet weak var defenseLabel: UILabel!
    @IBOutlet weak var dexterityLabel: UILabel!
    @IBOutlet weak var intelligenceLabel: UILabel!
    @IBOutlet weak var strengthLabel: UILabel!
    @IBOutlet weak var healthLabel: UILabel!
    @IBOutlet weak var armorLabel: UILabel!
    @IBOutlet weak var rightHandLabel: UILabel!
    @IBOutlet weak var leftHandLabel: UILabel!
    @IBOutlet weak var heroNameLabel: UILabel!
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        ad.saveContext()
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backpackTable.delegate = self
        backpackTable.dataSource = self
        
        update()
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let itemCost = ItemList[backpack[indexPath.row]]?["price"] as! Int
        let itemReturn = itemCost/4
        
        let sell = UITableViewRowAction(style: .destructive, title: "Sell for \(itemReturn) gold") { (action, indexPath) in
            self.loggedInHero?.removeFromBackpack(at: indexPath.row)
            self.loggedInHero?.getGold(amount: itemReturn)
            ad.saveContext()
            self.update()
        }
        
        sell.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        
        return [sell]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemName = backpack[indexPath.row]
        
        if itemName == "Escape Potion" {
            return
        }
        if itemName == "Health Potion" && loggedInHero?.health == loggedInHero?.maxHealth {
            return
        }
        
        
        let item = ItemList[itemName]
        loggedInHero?.removeFromBackpack(at: indexPath.row)
        
        switch item?["type"] as! String {
        case "Weapon":
            if let lh = loggedInHero?.leftHand {
                if let rh = loggedInHero?.rightHand {
                    loggedInHero?.addToBackpack(rh)
                }
                if item?["handed"] as! Int == 2 {
                    loggedInHero?.addToBackpack(lh)
                    loggedInHero?.rightHand = nil
                } else {
                    if ItemList[(loggedInHero?.leftHand)!]?["handed"] as! Int == 1 {
                        loggedInHero?.rightHand = loggedInHero?.leftHand
                    } else {
                        loggedInHero?.addToBackpack(lh)
                    }
                }
            }
            loggedInHero?.leftHand = itemName
            break
        case "Potion":
            if item?["name"] as! String == "Health Potion" {
                let maxHealth = Int((loggedInHero?.maxHealth)!)
                let curHealth = Int((loggedInHero?.health)!)
                if curHealth + 20 > maxHealth {
                    loggedInHero?.health = Int64(maxHealth)
                } else {
                    loggedInHero?.health += 20
                }
            }
            if item?["name"] as! String == "Mana Potion" {
                let maxMana = Int((loggedInHero?.maxMana)!)
                let curMana = Int((loggedInHero?.mana)!)
                if curMana + 20 > maxMana {
                    loggedInHero?.mana = Int64(maxMana)
                } else {
                    loggedInHero?.mana += 20
                }
            }
            break
        case "Armor":
            if let armor = loggedInHero?.armor {
                loggedInHero?.addToBackpack(armor)
            }
            loggedInHero?.armor = itemName
            loggedInHero?.equip(armorPiece: itemName)
            break
        default:
            print("error")
        }
        ad.saveContext()
        update()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemName = backpack[indexPath.row]
        let item = ItemList[itemName]
        let cell: UITableViewCell
        
        let itemType = item?["type"] as! String
        
        if itemType == "Weapon" {
            
            cell = tableView.dequeueReusableCell(withIdentifier: "weaponCell", for: indexPath) as! WeaponCell
            let weaponCell = cell as! WeaponCell
            weaponCell.configureCell(for: item!)
            return weaponCell
            
        } else if itemType == "Armor" {
            
            cell = tableView.dequeueReusableCell(withIdentifier: "armorCell", for: indexPath) as! ArmorCell
            let armorCell = cell as! ArmorCell
            armorCell.configureCell(for: item!)
            return armorCell
            
        } else {
            
            cell = tableView.dequeueReusableCell(withIdentifier: "potionCell", for: indexPath) as! PotionCell
            let potionCell = cell as! PotionCell
            potionCell.configureCell(for: item!)
            return potionCell
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return backpack.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func update() {
        heroNameLabel.text = "\((loggedInHero?.name!)!) the \((loggedInHero?.job!)!)"
        
        if let lh = loggedInHero?.leftHand {
            leftHandLabel.text = "Left Hand: \(lh)"
        } else {
            leftHandLabel.text = "Left Hand: Empty"
        }
        
        if let rh = loggedInHero?.rightHand {
            rightHandLabel.text = "Right Hand: \(rh)"
        } else {
            rightHandLabel.text = "Right Hand: Empty"
        }
        
        if let armor = loggedInHero?.armor {
            armorLabel.text = "Armor: \(armor)"
        } else {
            armorLabel.text = "Armor: Naked"
        }
        
        healthLabel.text = "Health: \((loggedInHero?.health)!)"
        intelligenceLabel.text = "Intelligence: \((loggedInHero?.intelligence)!)"
        dexterityLabel.text = "Dexterity: \((loggedInHero?.dexterity)!)"
        
        // Compute Strength Label
        var strengthText = "Strength: \((loggedInHero?.strength)!)"
        var additionalStrength = 0
        if let lh = loggedInHero?.leftHand {
            additionalStrength += ItemList[lh]?["damage"] as! Int
        }
        if let rh = loggedInHero?.rightHand {
            additionalStrength += ItemList[rh]?["damage"] as! Int
        }
        if additionalStrength > 0 {
            strengthText += " +\(additionalStrength)"
        }
        
        strengthLabel.text = strengthText
        
        // Compute Defense Label
        var defense = 0
        if let armor = loggedInHero?.armor {
            defense = ItemList[armor]?["defense"] as! Int
        }
        
        defenseLabel.text = "Defense: \(defense)"
        
        // Get Items
        backpack = []
        for itemName in loggedInHero?.backpack as! [String] {
            backpack.append(itemName)
        }
        
        backpackTable.reloadData()
    }
    
}
