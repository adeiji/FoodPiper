//
//  PeepMenuIcons.swift
//  FoodPiper
//
//  Created by adeiji on 11/29/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import UIKit

class PeepMenuIcons: UIButton {

    let PROFILE = "Profile"
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        switch self.restorationIdentifier {
        case PROFILE?:
            FoodPiperIcons.drawProfileIconWithFrame(rect)
            break
        default:break
        }
    }


}
