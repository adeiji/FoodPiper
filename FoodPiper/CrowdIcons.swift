//
//  CrowdIcons.swift
//  FoodPiper
//
//  Created by adeiji on 11/29/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import UIKit

class CrowdIcons: UIButton {

    let SLOW = "Slow", GOOD = "Good", PACKED = "Packed", NOT_HOT = "NotHot", HOT = "Hot", SO_SO = "Soso"
    
    override func drawRect(rect: CGRect) {
        switch self.restorationIdentifier
        {
        case SLOW?:
            FoodPiperIcons.drawCrowdSlowIconWithFrame(rect)
            break
        case GOOD?:
            FoodPiperIcons.drawCrowdGoodIcon()
            break
        case PACKED?:
            FoodPiperIcons.drawCrowdPackedIconWithFrame(rect)
            break
        case NOT_HOT?:
            FoodPiperIcons.drawNotHotIconWithFrame(rect)
            break
        case HOT?:
            FoodPiperIcons.drawHotIconWithFrame(rect)
            break
        case SO_SO?:
            FoodPiperIcons.drawSoSoIcon()
            break
        default:break
        }
    }
    
}
