//
//  HoursView.swift
//  FoodPiper
//
//  Created by adeiji on 10/29/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import UIKit

class HoursView: UIView {

    let PM_TEXTBOX_TAG = 7
    @IBOutlet var txtTimeDisplays: [UILabel]!
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.CGColor
        }
    }
    
    func displayRestaurantHours (hours: [String:String]) -> Bool {
        // This tag will correspond to the tag of the UILabel which will store the time
        var dayTag = 0;
        
        for (day, time) in hours {

            let openTimeString = time.substringToIndex((time.rangeOfString(",")?.startIndex)!)
            let closeTimeString = time.substringFromIndex((time.rangeOfString(",")?.endIndex)!)
            
            let df = NSDateFormatter()
            df.dateFormat = "HH:mm"
            
            if let openTime = df.dateFromString(openTimeString) {
                df.timeZone = NSTimeZone(forSecondsFromGMT: 0)
                df.dateFormat = "h:mm a"
                let openTimeConvertedString = df.stringFromDate(openTime)
                let timeLabel = self.viewWithTag(dayTag) as! UILabel
                timeLabel.text = openTimeConvertedString
                df.dateFormat = "HH:mm"
                if let closeTime = df.dateFromString(closeTimeString) {
                    df.timeZone = NSTimeZone(forSecondsFromGMT: 0)
                    df.dateFormat = "h:mm a"
                    let closeTimeConvertedString = df.stringFromDate(closeTime)
                    let timeLabel = self.viewWithTag(dayTag + 7) as! UILabel;
                    timeLabel.text = closeTimeConvertedString;
                }
                else {
                    return false
                }
                
                dayTag = dayTag + 1

            }
            else {
                // The time is not available
                return false
            }
        }
        
        return true
    }

    @IBAction func closeView(sender: UIButton) {
        
        DEAnimationManager.animateViewOut(self, withInsets: UIEdgeInsetsZero);
        
    }
}
