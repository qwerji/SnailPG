//
//  BattleLogCell.swift
//  Snail Fantasy
//
//  Created by Ben Swanson on 1/24/17.
//  Copyright © 2017 Benjamin Swanson. All rights reserved.
//

import UIKit

class BattleLogCell: UITableViewCell {
    
    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var rightImage: UIImageView!
    @IBOutlet weak var logText: UILabel!
    
    func configureCell(with config: BattleCellConfig) {
        logText.text = config.text
        leftImage.image = config.image1
        rightImage.image = config.image2
        contentView.backgroundColor = config.color.0
        logText.textColor = config.color.1
    }

}

struct BattleCellConfig {
    var text: String
    var color: (UIColor,UIColor)
    var image1: UIImage
    var image2: UIImage
    init(text: String, color: String, image1: UIImage, image2: UIImage){
        
        let colors: [String:(UIColor,UIColor)] = [
            "Base Damage" : (#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)),
            "Base Hit"    : (#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1),#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)),
            "Miss"        : (#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)),
            "Gold"        : (#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1),#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)),
            "Experience"  : (#colorLiteral(red: 0.4500938654, green: 0.9813225865, blue: 0.4743030667, alpha: 1),#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)),
            "Victory"     : (#colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)),
            "Defeat"      : (#colorLiteral(red: 0.370555222, green: 0.3705646992, blue: 0.3705595732, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)),
            "Item"        : (#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)),
            "Spell Cast"  : (#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1),#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1))
        ]
        
        self.text = text
        self.color = colors[color]!
        self.image1 = image1
        self.image2 = image2
    }
}
