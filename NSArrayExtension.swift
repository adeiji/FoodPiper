//
//  NSArrayExtension.swift
//  FoodPiper
//
//  Created by adeiji on 10/23/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import Foundation

extension Array
{
    /*

    Convert an array of strings into a single line

    */
    func convertArrayDataToString() -> String {
        var dataAsString:String = String()
    
        for myString in self {
            
            dataAsString = dataAsString + String(myString) + ", "
        }
        
        return dataAsString
    }
}