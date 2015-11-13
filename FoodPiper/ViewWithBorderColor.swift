//
//  ViewWithBorderColor.swift
//  FoodPiper
//
//  Created by adeiji on 11/12/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import UIKit

class ViewWithBorderColor: UIView {

    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.CGColor
        }
    }

}
