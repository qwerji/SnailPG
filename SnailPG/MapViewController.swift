//
//  MapViewController.swift
//  Snail Fantasy
//
//  Created by Tyler Warren on 1/21/17.
//  Copyright © 2017 Benjamin Swanson. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {
    @IBOutlet weak var snailMeadow: UIButton!
    @IBOutlet weak var hauntedForest: UIButton!
    @IBOutlet weak var goblinOutpost: UIButton!
    
    @IBOutlet weak var mapScrollView: UIScrollView!
    
    var loggedInHero: Hero?
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hauntedForest.setTitle("🔒 Level Required: 5", for: UIControlState.normal)
        goblinOutpost.setTitle("🔒 Level Required: 10", for: UIControlState.normal)
        
        let level = Int((loggedInHero?.level)!)
        
        if level >= 5 {
            hauntedForest.setTitle("Haunted Forest", for: UIControlState.normal)
        }
        if level >= 10 {
            goblinOutpost.setTitle("Goblin Outpost", for: UIControlState.normal)
            snailMeadow.setTitle("🔒", for: UIControlState.normal)
        }
        
    }
    
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        
        let level = Int((loggedInHero?.level)!)
        
        if sender.tag == 0 {
            if level < 10 {
                loggedInHero?.area = Int64(sender.tag)
            } else {
                // Level too high
            }
        } else if sender.tag == 1 {
            if level < 15  && level >= 5 {
                loggedInHero?.area = Int64(sender.tag)
            } else {
                // Level not high enough
            }
        } else if sender.tag == 2 {
            if level < 20  && level >= 10 {
                loggedInHero?.area = Int64(sender.tag)
            } else {
                // Level not high enough
            }
        }
        
        ad.saveContext()
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    override func viewWillLayoutSubviews() {
        mapScrollView.contentOffset = CGPoint(x: 0.0, y: 430.5)
    }
}
