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
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        super.drawRect(rect)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetStrokeColorWithColor(context, UIColor.redColor().CGColor)
        CGContextSetLineWidth(context, 2.0)
        CGContextMoveToPoint(context, btnCrowd.center.x, btnCrowd.center.y)
        CGContextAddLineToPoint(context, btnComment.center.x, btnComment.center.y)
        CGContextStrokePath(context)
    }


}
