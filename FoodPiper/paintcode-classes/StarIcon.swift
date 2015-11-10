//
//  StarIcon.swift
//  FoodPiper
//
//  Created by adeiji on 11/9/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import UIKit

class StarIcon: UIButton {

    var filled = false
    var halfFilled = false
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        if halfFilled == false {
            if filled == false {
                FoodPiperIcons.drawStarEmptyIconWithFrame(rect)
            }
            else {
                FoodPiperIcons.drawStarFilledIconWithFrame(rect)
            }
        }
        else {
            FoodPiperIcons.drawHalfFilledStarWithFrame(rect)
        }
    }

}
