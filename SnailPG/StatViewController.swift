//
//  StatViewController.swift
//  Snail Fantasy
//
//  Created by Tyler Warren on 1/23/17.
//  Copyright © 2017 Benjamin Swanson. All rights reserved.
//

import UIKit

class StatViewController: UIViewController {
    var loggedInHero: Hero?
    
    @IBOutlet weak var intLabel: UILabel!
    @IBOutlet weak var dexLabel: UILabel!
    @IBOutlet weak var strLabel: UILabel!
    @IBOutlet weak var hpLabel: UILabel!
    @IBOutlet weak var statPointsLabel: UILabel!
    @IBOutlet weak var heroNameLabel: UILabel!
    @IBOutlet weak var heroLevelLabel: UILabel!
    @IBOutlet weak var heroIconImage: UIImageView!
    var isFromMain = false
    
    var currentStats = [Int64]()
    override func viewWillAppear(_ animated: Bool) {
        currentStats = [(loggedInHero?.maxHealth)!,(loggedInHero?.strength)!,(loggedInHero?.dexterity)!, (loggedInHero?.intelligence)!,(loggedInHero?.statPoints)!]
        heroNameLabel.text = "\((loggedInHero?.name!)!) the \((loggedInHero?.job!)!)"
        heroIconImage.image = loggedInHero?.icon as! UIImage?
        heroLevelLabel.text = "\((loggedInHero?.level)!)"
        update()
        
    }
    @IBAction func addToStatPressed(_ sender: UIButton) {
        if (loggedInHero?.statPoints)! > 0 {
            print(sender.tag)
            loggedInHero?.addToStat(with: sender.tag)
            update()
        }
    }
    @IBAction func removeFromStatPressed(_ sender: UIButton) {
        loggedInHero?.removeFromStat(with: sender.tag, minStat: Int(currentStats[sender.tag]))
        update()
    }
    @IBAction func resetButtonPressed(_ sender: UIButton) {
        loggedInHero?.maxHealth = currentStats[0]
        loggedInHero?.strength = currentStats[1]
        loggedInHero?.dexterity = currentStats[2]
        loggedInHero?.intelligence = currentStats[3]
        loggedInHero?.statPoints = currentStats[4]
        update()
    }
    func update(){
        statPointsLabel.text = "\((loggedInHero?.statPoints)!)"
        hpLabel.text = "\((loggedInHero?.maxHealth)!)"
        strLabel.text = "\((loggedInHero?.strength)!)"
        dexLabel.text = "\((loggedInHero?.dexterity)!)"
        intLabel.text = "\((loggedInHero?.intelligence)!)"
    }
    @IBAction func saveStatsPressed(_ sender: UIButton) {
        ad.saveContext()
        if isFromMain {
            if let navController = self.navigationController {
                navController.popViewController(animated: true)
            }
        } else {
            performSegue(withIdentifier: "loadPreviousForNewHeroSegue", sender: nil)
            performSegue(withIdentifier: "newHeroCompletedSegue", sender: nil)
            var stack = self.navigationController?.viewControllers
            stack!.remove(at: 1)
            stack!.remove(at: 2)
        }
 
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newHeroCompletedSegue"{
            let mainVC = segue.destination as! MainViewController
            mainVC.loggedInHero = loggedInHero
        }
    }
    
    

}
