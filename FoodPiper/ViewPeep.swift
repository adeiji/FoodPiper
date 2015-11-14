//
//  ViewPeep.swift
//  FoodPiper
//
//  Created by adeiji on 11/4/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import UIKit

class ViewPeep: UIStackView {

    let TOP_LEFT = 1, TOP_MIDDLE = 2, TOP_RIGHT = 3, BOTTOM_LEFT = 4, BOTTOM_MIDDLE = 5, BOTTOM_RIGHT = 6
    
    @IBOutlet weak var image: UIImageView!

    override func drawRect(rect: CGRect) {
        PaintCodeBackgrounds.drawFoodBackgroundViewWithFrame(rect)
    }
    
}
