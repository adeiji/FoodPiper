//
//  PipeMenuView.swift
//  FoodPiper
//
//  Created by adeiji on 10/30/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import UIKit

@IBDesignable

class PipeMenuView: UIView {

    @IBOutlet weak var btnCrowd: UIButton!
    @IBOutlet weak var btnComment: UIButton!
    @IBOutlet var bottomConstraints: [NSLayoutConstraint]!
    @IBOutlet var buttons: [UIButton]!
    
    func animateButtons () {
        for constraint in bottomConstraints {
            let multiplier = Int(constraint.identifier!)
            let originaConstraintConstant = constraint.constant
            constraint.constant = self.frame.height + CGFloat(multiplier! * 100)
            self.layoutIfNeeded()
            
            let delay = Double(Double(multiplier!) * 0.05);
            // Have all the buttons ease down to the bottom screen in a cool little waterfall affect
            UIView.animateWithDuration(0.3, delay: delay, options: .CurveEaseOut, animations: { () -> Void in
                constraint.constant = originaConstraintConstant
                self.layoutIfNeeded()
                }, completion: nil)
            
        }
    }
    
    override func drawRect(rect: CGRect) {
        PaintCodeBackgrounds.drawFoodBackgroundViewWithFrame(rect)
    }


}
