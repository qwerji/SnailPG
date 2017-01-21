//
//  HealthBar.swift
//  Snail Fantasy
//
//  Created by Tyler Warren on 1/20/17.
//  Copyright © 2017 Benjamin Swanson. All rights reserved.
//

import UIKit

class HealthBar: UISlider {
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var newBounds = super.trackRect(forBounds: bounds)
        newBounds.size.height = 18
        return newBounds
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
