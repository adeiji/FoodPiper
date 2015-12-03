//
//  UserProfileView.swift
//  FoodPiper
//
//  Created by adeiji on 11/18/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import UIKit

class UserProfileView: UIView {
    @IBOutlet weak var image: UIButton!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtUserSince: UITextField!
    
    override func drawRect(rect: CGRect) {
        PaintCodeBackgrounds.drawFoodBackgroundViewWithFrame(rect)
    }
}
