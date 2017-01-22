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
    }
    override func viewWillLayoutSubviews() {
        mapScrollView.contentOffset = CGPoint(x: 0.0, y: 430.5)
    }
}
