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
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var healthLabel: UILabel!
    @IBOutlet weak var goldLabel: UILabel!
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var loggedInHero: Hero?
    
    @IBAction func unwindToMain(segue: UIStoryboardSegue){}
    
    // To Welcome
    @IBAction func exitButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
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
        default:
            print("error")
        }
    }
    
    func update() {
        // Set hero stats labels
        heroNameLabel.text = loggedInHero?.name!
        jobLabel.text = loggedInHero?.job!
        levelLabel.text = String(describing: loggedInHero!.level)
        healthLabel.text = String(describing: loggedInHero!.health)
        goldLabel.text = String(describing: loggedInHero!.gold)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        update()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        update()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
