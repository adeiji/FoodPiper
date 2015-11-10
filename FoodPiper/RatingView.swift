//
//  RatingView.swift
//  FoodPiper
//
//  Created by adeiji on 10/29/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import UIKit

class RatingView: UIScrollView {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var txtComment: UITextView!
    
    override func drawRect(rect: CGRect) {
        PaintCodeBackgrounds.drawFoodBackgroundViewWithFrame(rect)
    }
    
}
