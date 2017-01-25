//
//  TitleViewController.swift
//  Snail Fantasy
//
//  Created by Tyler Warren on 1/21/17.
//  Copyright © 2017 Benjamin Swanson. All rights reserved.
//

import UIKit

class TitleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func graveyardButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "graveyardSegue", sender: nil)
    }
    
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        //settingsSegue
    }
    

}
