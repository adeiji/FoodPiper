//
//  FoodPiperPaintCodeButton.swift
//  FoodPiper
//
//  Created by adeiji on 11/10/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import UIKit

let PASSWORD_ICON:String! = "PasswordIcon"
let USERNAME_ICON = "UsernameIcon"

class FoodPiperPaintCodeButton: UIButton {

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        if self.restorationIdentifier == PASSWORD_ICON {
            FoodPiperIcons.drawPasswordIconWithFrame(rect)
        }
        else if self.restorationIdentifier == USERNAME_ICON {
            FoodPiperIcons.drawUsernameIconWithFrame(rect)
        }
    }


}
