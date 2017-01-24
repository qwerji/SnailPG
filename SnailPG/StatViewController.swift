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
    @IBOutlet weak var addToStatBtn: UIButton!
    @IBOutlet weak var removeFromStatBtn: UIButton!
    @IBAction func addToStatPressed(_ sender: UIButton) {
    }
    @IBAction func removeFromStatPressed(_ sender: UIButton) {
    }
    override func viewWillAppear(_ animated: Bool) {
        addToStatBtn.setTitle("\u{25B2}", for: UIControlState.normal)
        removeFromStatBtn.setTitle("\u{25BC}", for: UIControlState.normal)
        var currentStats = [loggedInHero?.maxHealth,loggedInHero?.strength,loggedInHero?.dexterity, loggedInHero?.intelligence,loggedInHero?.statPoints]
        hpLabel.text = "\((loggedInHero?.maxHealth)!)"
        strLabel.text = String(describing:loggedInHero?.strength)
        dexLabel.text = String(describing:loggedInHero?.dexterity)
        intLabel.text = String(describing:loggedInHero?.intelligence)
    }
    
    
    
    

}
