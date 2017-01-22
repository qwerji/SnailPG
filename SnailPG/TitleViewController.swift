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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func heroSelectPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "heroSelectSegue", sender: nil)
        
    }
    @IBAction func graveyardButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "graveyardSegue", sender: nil)
    }
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        //settingsSegue
    }
    @IBAction func unwindToTitle(sender: UIStoryboardSegue){}

}
