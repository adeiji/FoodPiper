//
//  ViewRestaurantsView+Swift.swift
//  FoodPiper
//
//  Created by adeiji on 12/10/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import UIKit

extension DEViewRestaurantsView {
    // Load the deals from Parse with the Restaurants Factual ID as the lookup
    func loadDeals () {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            self.deals = SyncManager.getParseObjectsWithClass(ParseClass.Deal.rawValue, objectKeyValues: [ ParseKey.DealRestaurantFactualId.rawValue : self.restaurant.factualId ], queryType: ParseQueryType.WhereKeyEqualTo, containedInNot: nil, withinKilometers: 0)
        })
    }
    
    func displayDeals () {
        let scrollView = UIScrollView(frame: self.bounds)
        var xPos:CGFloat = 0
        for deal in deals {
            let dealLabel = UILabel(frame: CGRectMake(xPos, 0, self.frame.width, self.frame.height) )
            dealLabel.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
            dealLabel.textColor = UIColor.whiteColor()
            dealLabel.text = (deal[ParseKey.DealDealDescription.rawValue] as! String)
            scrollView.addSubview(dealLabel)
            xPos +=  self.frame.width
        }
        scrollView.contentSize = CGSizeMake(xPos, self.frame.height)
        self.addSubview(scrollView)
    }
}
