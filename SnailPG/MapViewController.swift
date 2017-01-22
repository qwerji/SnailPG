//
//  MapViewController.swift
//  Snail Fantasy
//
//  Created by Tyler Warren on 1/21/17.
//  Copyright © 2017 Benjamin Swanson. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapScrollView: UIScrollView!
    var loggedInHero: Hero?
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        
        if sender.tag == 0 {
            if (loggedInHero?.level)! < 6 {
                loggedInHero?.area = Int64(sender.tag)
            } else {
                // Level too high
            }
        } else if sender.tag == 2 {
            if (loggedInHero?.level)! >= 6 {
                loggedInHero?.area = Int64(sender.tag)
            } else {
                // Level not high enough
            }
        } else {
            loggedInHero?.area = Int64(sender.tag)
        }
        
        ad.saveContext()
        
    }
    override func viewWillLayoutSubviews() {
        mapScrollView.contentOffset = CGPoint(x: 0.0, y: 430.5)
    }
}
