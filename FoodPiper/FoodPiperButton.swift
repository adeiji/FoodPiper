//
//  FoodPiperButton.swift
//  FoodPiper
//
//  Created by adeiji on 10/19/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import UIKit

class FoodPiperButton: UIButton {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        
        self.layer.cornerRadius = 3.0;
        self.titleLabel?.font = UIFont(name: "Gill Sans", size: 14.0);
        self.titleLabel?.textColor = UIColor.whiteColor();
    }
}

extension UIButton {
    @IBInspectable var cornerRadius : CGFloat {
        get {
            return layer.cornerRadius
        
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth : CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
            layer.masksToBounds = newValue > 0
        }
    }

    @IBInspectable var borderColor : CGColor {
        get {
            return layer.borderColor!
        }
        set {
            layer.borderColor = newValue
        }
    }
}