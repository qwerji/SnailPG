//
//  LogInViewController.swift
//  Snail Fantasy
//
//  Created by Ben Swanson on 2/1/17.
//  Copyright © 2017 Benjamin Swanson. All rights reserved.
//

import UIKit
import FirebaseAuth

class LogInViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var switchLoginRegisterButtonPressed: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var firebaseErrorTextField: UILabel!
    
    var login = true
    var created = false
    var loggedInUser: FIRUser?
    
    @IBAction func switchLoginRegisterButtonPressed(_ sender: UIButton) {
        if login {
            login = false
            usernameTextField.isHidden = false
            switchLoginRegisterButtonPressed.setTitle("Already Have An Account?", for: .normal)
            logInButton.setTitle("Register", for: .normal)
        } else {
            login = true
            usernameTextField.isHidden = true
            switchLoginRegisterButtonPressed.setTitle("Don't Have An Account?", for: .normal)
            logInButton.setTitle("Log In", for: .normal)
        }
        firebaseErrorTextField.text = ""
    }
    
    @IBAction func logInButtonPressed(_ sender: UIButton) {
        if created {
            self.setUsername()
        } else if login {
            
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
            
        } else {
            
            if let email = emailTextField.text, let password = passwordTextField.text {
                FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
                    if let e = error {
                        self.firebaseErrorTextField.text = e.localizedDescription
                    } else {
                        self.loggedInUser = user
                        self.setUsername()
                        self.created = true
                        self.switchLoginRegisterButtonPressed.isHidden = true
                        self.logInButton.setTitle("Set Username", for: .normal)
                    }
                }
            }
            
        }
        
    }
    
    func setUsername() {
        if let user = loggedInUser {
            let request = user.profileChangeRequest()
            request.displayName = usernameTextField.text!
            request.commitChanges(completion: { error in
                if let er = error {
                    self.firebaseErrorTextField.text = er.localizedDescription
                } else {
                    self.firebaseErrorTextField.text = "Registered and Logged in!"
                    
                    // Set achievements up
                    ref.child("users").child(user.uid).setValue([
                        "totalVictories": 0,
                        "name": user.displayName ?? ""
                    ])
                    
                    if let navController = self.navigationController {
                        navController.popViewController(animated: true)
                    }
                }
            })
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
        usernameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        usernameTextField.isHidden = true
    }

}
