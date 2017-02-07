//
//  LeaderboardViewController.swift
//  Snail Fantasy
//
//  Created by Ben Swanson on 2/1/17.
//  Copyright © 2017 Benjamin Swanson. All rights reserved.
//

import UIKit
import FirebaseAuth

class LeaderboardViewController: UIViewController {

    @IBAction func backButtonPressed(_ sender: UIButton) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
    @IBAction func logOutButtonPressed(_ sender: UIButton) {
        do {
            try FIRAuth.auth()?.signOut()
            if let navController = self.navigationController {
                navController.popViewController(animated: true)
            }
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }

}
