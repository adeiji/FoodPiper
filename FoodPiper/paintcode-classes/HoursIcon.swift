//
//  HoursIcon.swift
//  FoodPiper
//
//  Created by adeiji on 11/9/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import UIKit

class HoursIcon: UIButton {


    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        FoodPiperIcons.drawHoursIconWithFrame(rect)
    }

}
