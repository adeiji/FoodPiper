//
//  MessageWithTextLimitView.swift
//  FoodPiper
//
//  Created by adeiji on 11/12/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import UIKit

class MessageWithTextLimitView: UIView, UITextViewDelegate {

    
    @IBOutlet weak var lblMinCharacters: UILabel!
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let newLength = (textView.text?.characters.count)! + text.characters.count - range.length
        let targetLength = 150 - newLength
        
        if targetLength > -1 {
            self.lblMinCharacters.text = String(150 - newLength)
        }
        else {
            self.lblMinCharacters.text = "0"
            return false
        }
        
        return true
    }
    
    
}
