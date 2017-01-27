//
//  AchievementModalViewController.swift
//  Snail Fantasy
//
//  Created by Ben Swanson on 1/25/17.
//  Copyright © 2017 Benjamin Swanson. All rights reserved.
//

import UIKit

class AchievementModalViewController: UIViewController {
    
    @IBOutlet weak var achievementNameLabel: UILabel!
    @IBOutlet weak var achievementDescriptionLabel: UILabel!
    @IBOutlet weak var achievementIcon: UIImageView!
    
    var achievementName: String?
    var achievementDescription: String?
    var achievementImage: UIImage?
    
    @IBAction func dismissButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func configureModal(name: String, description: String, icon: UIImage) {
        achievementName = name
        achievementDescription = description
        achievementImage = icon
    }
    
    override func viewWillAppear(_ animated: Bool) {
        achievementNameLabel.text = achievementName
        achievementDescriptionLabel.text = achievementDescription
        achievementIcon.image = achievementImage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

}
