//
//  ExpansionView.swift
//  FoodPiper
//
//  Created by adeiji on 11/25/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import UIKit

class ExpansionView: UIView {

    var collapsed:Bool! = true
    @IBOutlet var heightConstraint:NSLayoutConstraint!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.borderColor = UIColor(red: 186/255, green: 25/255, blue: 96/255, alpha: 1).CGColor
    }
    
}
