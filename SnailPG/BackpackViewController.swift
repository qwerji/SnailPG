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
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
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
        appDelegate.saveContext()
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backpackTable.delegate = self
        backpackTable.dataSource = self
        
        update()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "item")!
        cell.textLabel?.text = "\(backpack[indexPath.row])"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return backpack.count
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
            armorLabel.text = "Armor: Empty"
        }
        
        healthLabel.text = "Health: \((loggedInHero?.health)!)"
        intelligenceLabel.text = "Intelligence: \((loggedInHero?.intelligence)!)"
        dexterityLabel.text = "Dexterity: \((loggedInHero?.dexterity)!)"
        
        // Compute Strength Label
        var strengthText = "Strength: \((loggedInHero?.strength)!)"
        var additionalStrength = 0
        if let lh = loggedInHero?.leftHand {
            additionalStrength += WeaponList[lh]?["damage"] as! Int
        }
        if let rh = loggedInHero?.rightHand {
            additionalStrength += WeaponList[rh]?["damage"] as! Int
        }
        if additionalStrength > 0 {
            strengthText += " +\(additionalStrength)"
        }
        
        strengthLabel.text = strengthText
        
        // Compute Defense Label
        var defense = 0
        if let armor = loggedInHero?.armor {
            defense = ArmorList[armor]?["defense"] as! Int
        }
        
        defenseLabel.text = "Defense: \(defense)"
        
        // Get Items
        for itemName in loggedInHero?.backpack as! NSMutableArray {
            backpack.append(itemName as! String)
        }
        
        backpackTable.reloadData()
    }
    
}
