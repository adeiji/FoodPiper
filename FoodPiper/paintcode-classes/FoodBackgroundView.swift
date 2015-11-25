//
//  FoodBackgroundView.swift
//  FoodPiper
//
//  Created by adeiji on 11/9/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import UIKit

class FoodBackgroundView: UIView {
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        PaintCodeBackgrounds.drawFoodBackgroundViewWithFrame(rect)
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clearColor()
        self.clearsContextBeforeDrawing = false
    }
}

class FoodBackgroundScrollView : UIScrollView {
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        PaintCodeBackgrounds.drawFoodBackgroundViewWithFrame(rect)
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clearColor()
        self.clearsContextBeforeDrawing = false
    }
}
