//
//  ViewIndividualRestaurantView.swift
//  FoodPiper
//
//  Created by adeiji on 10/24/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import UIKit

class ViewIndividualRestaurantView: UIScrollView {

    @IBOutlet weak var txtCuisine: UILabel!
    @IBOutlet weak var txtAddress: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var ratingView: UIView!
    var pipeButtonView:UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func drawRect(rect: CGRect) {
        PaintCodeBackgrounds.drawFoodBackgroundViewWithFrame(rect)
    }

}
