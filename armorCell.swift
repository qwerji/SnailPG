//
//  armorCell.swift
//  Snail Fantasy
//
//  Created by Ben Swanson on 1/20/17.
//  Copyright © 2017 Benjamin Swanson. All rights reserved.
//

import UIKit

class ArmorCell: UITableViewCell {
    
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var armorNameLabel: UILabel!
    @IBOutlet weak var defenseLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    func configureCell(for item: [String:Any]) {
        armorNameLabel.text = item["name"] as! String?
        defenseLabel.text = "Defense: \(item["defense"]!)"
        priceLabel.text = "Price: \(item["price"]!) gold"
    }
    
}
