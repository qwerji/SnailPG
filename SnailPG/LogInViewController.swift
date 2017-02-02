//
//  LogInViewController.swift
//  Snail Fantasy
//
//  Created by Ben Swanson on 2/1/17.
//  Copyright © 2017 Benjamin Swanson. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class LogInViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var firebaseErrorTextField: UILabel!
    
    @IBAction func logInButtonPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
                if let e = error {
                    self.firebaseErrorTextField.text = e.localizedDescription
                } else {
                    self.firebaseErrorTextField.text = "Logged in!"
                    if let navController = self.navigationController {
                        navController.popViewController(animated: true)
                    }
                }
            }
        }
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
                if let e = error {
                    self.firebaseErrorTextField.text = e.localizedDescription
                } else {
                    self.firebaseErrorTextField.text = "Registered and Logged in!"
                    
                    // Set achievements up
                    ref.child("users").child((user?.uid)!).setValue([
                        "achievements": ["achievement":false],
                        "totalVictories": 0,
                    ])
                    
                    if let navController = self.navigationController {
                        navController.popViewController(animated: true)
                    }
                }
            }
        }
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        firebaseErrorTextField.text = ""
    }

}
