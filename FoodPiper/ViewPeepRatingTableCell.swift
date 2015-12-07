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
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var ratingIcon: FoodPiperButtons!
    @IBOutlet weak var fiveStarView: UIView!
    var rating:Rating!
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
