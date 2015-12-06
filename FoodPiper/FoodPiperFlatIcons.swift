//
//  FoodPiperFlatIcons.swift
//  FoodPiper
//
//  Created by adeiji on 12/5/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import UIKit

class FoodPiperFlatIcons: UIButton {

    
    enum RestorationIdentifiers : String {
        case Address = "address"
        case Distance = "distance"
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        switch self.restorationIdentifier {
        case RestorationIdentifiers.Address.rawValue?:
            FlatIcons.drawAddressIconWithFrame(rect)
            break
        case RestorationIdentifiers.Distance.rawValue?:
            FlatIcons.drawCarIconWithFrame(rect)
            break
        default:break
        }
    }
    
    

}
