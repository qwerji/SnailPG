//
//  weaponCell.swift
//  Snail Fantasy
//
//  Created by Ben Swanson on 1/20/17.
//  Copyright © 2017 Benjamin Swanson. All rights reserved.
//

import UIKit

class WeaponCell: UITableViewCell {
    
    @IBOutlet weak var weaponNameLabel: UILabel!
    @IBOutlet weak var damageLabel: UILabel!
    @IBOutlet weak var handedLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    
    func configureCell(for item: [String:Any]) {
        weaponNameLabel.text = item["name"] as! String?
        damageLabel.text = "Damage: \(item["damage"]!)"
        handedLabel.text = "Handed: \(item["handed"]!)"
        priceLabel.text = "Price: \(item["price"]!) gold"
    }
    
}
