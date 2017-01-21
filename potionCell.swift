//
//  potionCell.swift
//  Snail Fantasy
//
//  Created by Ben Swanson on 1/20/17.
//  Copyright © 2017 Benjamin Swanson. All rights reserved.
//

import UIKit

class PotionCell: UITableViewCell {
    
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var potionNameLabel: UILabel!
    @IBOutlet weak var effectLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    func configureCell(for item: [String:Any]) {
        potionNameLabel.text = item["name"] as! String?
        effectLabel.text = "Effect: \(item["effect"]!)"
        priceLabel.text = "Price: \(item["price"]!) gold"
    }
    
}
