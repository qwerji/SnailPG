//
//  TitleViewController.swift
//  Snail Fantasy
//
//  Created by Tyler Warren on 1/21/17.
//  Copyright © 2017 Benjamin Swanson. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleMobileAds

class TitleViewController: UIViewController {
    
    @IBOutlet weak var bannerView: GADBannerView!
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bannerView.adUnitID = "ca-app-pub-8794803295602930/3148545408"
        bannerView.rootViewController = self
        let request = GADRequest()
        request.testDevices = ["c34fd2a75f9a60034420f74f9d278924"]
        bannerView.load(request)
    }
    
}
