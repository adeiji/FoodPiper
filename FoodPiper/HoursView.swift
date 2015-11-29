//
//  HoursView.swift
//  FoodPiper
//
//  Created by adeiji on 10/29/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import UIKit

class HoursView: UIView {

    let PM_TEXTBOX_TAG = 7
    @IBOutlet var txtTimeDisplays: [UILabel]!
    @IBOutlet weak var lblHours: UILabel!
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.CGColor
        }
    }
    
    func displayRestaurantHours (hours: String) -> Bool {
        // This tag will correspond to the tag of the UILabel which will store the time
        self.lblHours.text = hours;
        
        return true
    }
}
