//
//  GraveyardDetailViewController.swift
//  Snail Fantasy
//
//  Created by Ben Swanson on 1/25/17.
//  Copyright © 2017 Benjamin Swanson. All rights reserved.
//

import UIKit

class GraveyardDetailViewController: UIViewController {
    @IBOutlet weak var heroIcon: UIImageView!
    @IBOutlet weak var heroNameLabel: UILabel!
    @IBOutlet weak var jobAndLevelLabel: UILabel!
    @IBOutlet weak var victoriesLabel: UILabel!
    @IBOutlet weak var leftHandLabel: UILabel!
    @IBOutlet weak var rightHandLabel: UILabel!
    @IBOutlet weak var armorLabel: UILabel!
    @IBOutlet weak var strengthLabel: UILabel!
    @IBOutlet weak var intelligenceLabel: UILabel!
    @IBOutlet weak var dexterityLabel: UILabel!
    @IBOutlet weak var defenseLabel: UILabel!

    var hero: Hero!
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        heroIcon.image = hero.icon as? UIImage
        heroNameLabel.text = hero.name
        jobAndLevelLabel.text = "Level \(hero.level) \(hero.job!)"
        victoriesLabel.text = "\(hero.victories)"
        
        if let lh = hero.leftHand {
            leftHandLabel.text = lh
        } else {
            leftHandLabel.text = "Empty"
        }
        
        if let rh = hero.rightHand {
            rightHandLabel.text = rh
        } else {
            rightHandLabel.text = "Empty"
        }
        
        if let armor = hero.armor {
            armorLabel.text = armor
        } else {
            armorLabel.text = "Naked"
        }
        
        strengthLabel.text = "\(hero.strength)"
        intelligenceLabel.text = "\(hero.intelligence)"
        dexterityLabel.text = "\(hero.dexterity)"
        defenseLabel.text = "\(hero.defense)"
        
    }


}
