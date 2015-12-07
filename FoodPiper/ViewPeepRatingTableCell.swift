//
//  ViewPeepRatingTableCell.swift
//  FoodPiper
//
//  Created by adeiji on 12/6/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import UIKit

class ViewPeepRatingTableCell: UIView {

    @IBOutlet weak var fiveStarViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblRatingComment: UILabel!
    @IBOutlet weak var ratingIcon: FoodPiperButtons!
    @IBOutlet weak var fiveStarView: UIView!
    var rating:Rating!
    @IBOutlet weak var lblPipeComment: UILabel!
    @IBOutlet weak var ratingDescriptionIcon: FoodPiperButtons!
    @IBOutlet weak var ratingDescriptionCrowdQualityIcon: FoodPiperButtons!
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
