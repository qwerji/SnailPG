//
//  continueCell.swift
//  Snail Fantasy
//
//  Created by Ben Swanson on 1/23/17.
//  Copyright © 2017 Benjamin Swanson. All rights reserved.
//

import UIKit

class continueCell: UITableViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var heroNameLabel: UILabel!

    func configureCell(for hero: Hero) {
        icon.image = hero.icon as! UIImage?
        locationLabel.text = "Location: \(AreaDataForIndex[Int(hero.area)]!["name"] as! String)"
        jobLabel.text = "Job: \(hero.job!)"
        levelLabel.text = "Level: \(hero.level)"
        heroNameLabel.text = hero.name
    }

}
