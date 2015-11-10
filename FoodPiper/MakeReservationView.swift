//
//  MakeReservationView.swift
//  FoodPiper
//
//  Created by adeiji on 11/10/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import UIKit

class MakeReservationView: UIView {
    
    @IBOutlet weak var txtReservationTime: UITextField!
    @IBOutlet weak var lblDateAndTime: UILabel!
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.CGColor
        }
    }

}
