//
//  FoodPiperTextField.swift
//  FoodPiper
//
//  Created by adeiji on 12/4/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import UIKit

class FoodPiperTextField: TextFieldValidator {

    enum BorderColor : String {
        case Green = "green"
        case Red = "red"
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        switch self.restorationIdentifier {
        case BorderColor.Green.rawValue?:
            self.layer.borderColor = UIColor(red: 76/255, green: 161/255, blue: 182/255, alpha: 1).CGColor
            break
        case BorderColor.Red.rawValue?:
            self.layer.borderColor = UIColor(red: 203/255, green: 80/255, blue: 134/255, alpha: 1).CGColor
            break
        default:break
        }
    }


}
