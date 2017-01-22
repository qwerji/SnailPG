//
//  MainViewController.swift
//  SnailPG
//
//  Created by Ben Swanson on 1/12/17.
//  Copyright © 2017 Benjamin Swanson. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController {
    @IBOutlet weak var heroNameLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var healthLabel: UILabel!
    @IBOutlet weak var goldLabel: UILabel!
    @IBOutlet weak var experienceSlider: UISlider!
    @IBOutlet weak var healthSlider: UISlider!
    @IBOutlet weak var locationLabel: UILabel!
    
    var loggedInHero: Hero?
    
    @IBAction func unwindToMain(segue: UIStoryboardSegue){}
    
    // To Title
    @IBAction func exitButtonPressed(_ sender: UIButton) {
        ad.saveContext()
        performSegue(withIdentifier: "unwindToTitle", sender: nil)
    }
    
    // To Battle
    @IBAction func toBattleButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "battleSegue", sender: nil)
    }
    
    // To Shop
    @IBAction func toShopButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "mainToShopSegue", sender: nil)
    }
    
    // To Backpack
    @IBAction func backpackButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "backpack", sender: nil)
    }
    //To Map
    @IBAction func mapButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "mapSegue", sender: nil)
    }
    //To Hero select
    @IBAction func changeHeroButtonPressed(_ sender: Any) {
        ad.saveContext()
        dismiss(animated: true, completion: nil)
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
        default:
            print("error")
        }
    }
    
    func update() {
        // Set hero stats labels
        heroNameLabel.text = "\((loggedInHero?.name!)!) the \((loggedInHero?.job!)!)"
        levelLabel.text = String(describing: loggedInHero!.level)
        healthLabel.text = String(describing: loggedInHero!.health)
        goldLabel.text = String(describing: loggedInHero!.gold)
        experienceSlider.value = Float(loggedInHero!.experience)
        experienceSlider.maximumValue = Float(loggedInHero!.expToLevel)
        healthSlider.value = Float(loggedInHero!.health)
        healthSlider.maximumValue = Float(loggedInHero!.maxHealth)
        let area = AreaDataForIndex[Int((loggedInHero?.area)!)]!
        locationLabel.text = area["name"] as! String?
        ad.saveContext()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        update()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
