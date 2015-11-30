//
//  WaitTimeIcons.swift
//  FoodPiper
//
//  Created by adeiji on 11/29/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import UIKit

class WaitTimeIcons: UIButton {
    
    let FAST = "Fast", SO_SO = "Soso", SLOW = "Slow"
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        switch self.restorationIdentifier {
        case FAST?:
            FoodPiperIcons.drawFastIconWithFrame(rect)
            break
        case SO_SO?:
            FoodPiperIcons.drawSoSoIcon()
            break
        case SLOW?:
            FoodPiperIcons.drawSlowIconWithFrame(rect)
            break
        default:break;
        }
        
    }

}
