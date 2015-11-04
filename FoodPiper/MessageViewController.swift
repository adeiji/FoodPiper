//
//  MessageViewController.swift
//  FoodPiper
//
//  Created by adeiji on 11/2/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {

    @IBOutlet weak var txtMessage: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        txtMessage.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
