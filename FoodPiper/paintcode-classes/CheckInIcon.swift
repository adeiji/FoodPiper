//
//  CheckInIcon.swift
//  FoodPiper
//
//  Created by adeiji on 11/9/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import UIKit

class CheckInIcon: UIButton {

    override func drawRect(rect: CGRect) {
        FoodPiperIcons.drawCheckInIconWithFrame(rect)
    }


}
