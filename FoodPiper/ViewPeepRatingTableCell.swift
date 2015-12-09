//
//  ViewPeepRatingTableCell.swift
//  FoodPiper
//
//  Created by adeiji on 12/6/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import UIKit

@IBDesignable class ViewPeepRatingTableCell: UIView {

    @IBOutlet weak var fiveStarViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblRatingComment: UILabel!
    @IBOutlet weak var ratingIcon: FoodPiperButtons!
    @IBOutlet weak var fiveStarView: UIView!
    var rating:Rating!
    var pipe:Pipe!
    @IBOutlet weak var lblPipeComment: UILabel!
    @IBOutlet weak var lblRatingType: UILabel!
    @IBOutlet weak var lblRatingDescription: UILabel!
    @IBOutlet weak var lblRatingDescriptionCrowdQuality: UILabel!
    @IBOutlet weak var ratingDescriptionIcon: FoodPiperButtons!
    @IBOutlet weak var ratingDescriptionCrowdQualityIcon: FoodPiperButtons!
    var drawLine:Bool! = false
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        if drawLine == true {
            let context = UIGraphicsGetCurrentContext()
            CGContextSetStrokeColorWithColor(context, UIColor.grayColor().CGColor)
            CGContextSetLineWidth(context, 0.2)
            CGContextMoveToPoint(context, 15, rect.height - 1)
            CGContextAddLineToPoint(context, rect.width - 15, rect.height - 1)
            CGContextStrokePath(context)
        }
    }
}
