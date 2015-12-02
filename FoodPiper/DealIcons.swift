//
//  DealIcons.swift
//  FoodPiper
//
//  Created by adeiji on 11/29/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import UIKit

class DealIcons: UIButton {

    let PERCENT = "Percent", FREE = "Free", DOLLAR = "Dollar"
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        switch self.restorationIdentifier {
        case PERCENT?:
            FoodPiperIcons.drawPercentOffIconWithFrame(rect)
            break
        case FREE?:
            FoodPiperIcons.drawFreeIconWithFrame(rect)
            break
        case DOLLAR?:
            FoodPiperIcons.drawDollarOffIconWithFrame(rect)
            break
        default:break
        }
        
    }


}
