//
//  TitleViewController.swift
//  Snail Fantasy
//
//  Created by Tyler Warren on 1/21/17.
//  Copyright © 2017 Benjamin Swanson. All rights reserved.
//

import UIKit
import FirebaseAuth

class TitleViewController: UIViewController {
    
    @IBOutlet weak var logInAndLeaderboardButton: UIButton!
    
    @IBAction func logInAndLeaderboardButtonPressed(_ sender: UIButton) {
        if FIRAuth.auth()?.currentUser != nil {
            performSegue(withIdentifier: "leaderboardSegue", sender: nil)
        } else {
            performSegue(withIdentifier: "logInSegue", sender: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if FIRAuth.auth()?.currentUser != nil {
            logInAndLeaderboardButton.setTitle("Leaderboard", for: UIControlState.normal)
        } else {
            logInAndLeaderboardButton.setTitle("Log In / Register", for: UIControlState.normal)
        }
    }
    
    @IBAction func graveyardButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "graveyardSegue", sender: nil)
    }
    
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        //settingsSegue
    }
    
}
