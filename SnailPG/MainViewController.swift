//
//  MainViewController.swift
//  SnailPG
//
//  Created by Ben Swanson on 1/12/17.
//  Copyright © 2017 Benjamin Swanson. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController, UITabBarDelegate {
    @IBOutlet weak var heroNameLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var goldLabel: UILabel!
    @IBOutlet weak var experienceSlider: UISlider!
    @IBOutlet weak var healthSlider: UISlider!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var manaSlider: UISlider!
    @IBOutlet weak var victoryLabel: UILabel!
    @IBOutlet weak var mainTabBar: UITabBar!
    
    var loggedInHero: Hero?
    
    // To Title
    @IBAction func exitButtonPressed(_ sender: UIButton) {
        ad.saveContext()
        if let navController = self.navigationController {
            navController.popToRootViewController(animated: true)
        }
    }
    // To Battle
    @IBAction func toBattleButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "battleSegue", sender: nil)
    }
    //To Stats
    @IBAction func toStatsButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "mainToStatsSegue", sender: nil)
    }
    // To Shop
    @IBAction func toShopButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "mainToShopSegue", sender: nil)
    }
    // To Backpack
    @IBAction func backpackButtonPressed(_ sender: UITabBarItem) {
        self.performSegue(withIdentifier: "backpack", sender: nil)
    }
    //To Map
    @IBOutlet weak var mapButtonPressed: UITabBarItem!
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
        case 0:
            self.performSegue(withIdentifier: "mapSegue", sender: nil)
            break
        case 1:
            self.performSegue(withIdentifier: "battleSegue", sender: nil)
            break
        case 2:
            self.performSegue(withIdentifier: "mainToShopSegue", sender: nil)
            break
        case 3:
            self.performSegue(withIdentifier: "backpack", sender: nil)
            break
        case 4:
            self.performSegue(withIdentifier: "mainToStatsSegue", sender: nil)
            break
        case 5:
            ad.saveContext()
            if let navController = self.navigationController {
                navController.popViewController(animated: true)
            }
            break
        case 6:
            ad.saveContext()
            if let navController = self.navigationController {
                navController.popToRootViewController(animated: true)
            }
            break
        default: break
            
        }
        
    }
    @IBAction func mapButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "mapSegue", sender: nil)
    }
    //To Hero select
    @IBAction func changeHeroButtonPressed(_ sender: Any) {
        ad.saveContext()
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier! {
        case "battleSegue":
            let controller = segue.destination as! BattleViewController
            controller.loggedInHero = self.loggedInHero
            break
        case "mainToShopSegue":
            let controller = segue.destination as! ShopViewController
            controller.loggedInHero = self.loggedInHero
            break
        case "backpack":
            let controller = segue.destination as! BackpackViewController
            controller.loggedInHero = self.loggedInHero
            break
        case "mapSegue":
            let controller = segue.destination as! MapViewController
            controller.loggedInHero = self.loggedInHero
            break
        case "mainToStatsSegue":
            let controller = segue.destination as! StatViewController
            controller.loggedInHero = self.loggedInHero
            controller.isFromMain = true
            break
        default:
            break
        }
        
    }
    
    override func viewDidLoad() {
        mainTabBar.delegate = self
    }
    
    func update() {
        // Set hero stats labels
        heroNameLabel.text = "\((loggedInHero?.name!)!) the \((loggedInHero?.job!)!)"
        levelLabel.text = String(describing: loggedInHero!.level)
        goldLabel.text = String(describing: loggedInHero!.gold)
        experienceSlider.maximumValue = Float(loggedInHero!.expToLevel)
        experienceSlider.value = Float(loggedInHero!.experience)
        healthSlider.maximumValue = Float(loggedInHero!.maxHealth)
        healthSlider.value = Float(loggedInHero!.health)
        manaSlider.maximumValue = Float(loggedInHero!.maxMana)
        manaSlider.value = Float(loggedInHero!.mana)
        let area = AreaDataForIndex[Int((loggedInHero?.area)!)]!
        locationLabel.text = area["name"] as! String?
        victoryLabel.text = String(describing: loggedInHero!.victories)
        ad.saveContext()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        update()
    }

}
