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
    @IBOutlet weak var lblTo: UILabel!
    var restaurant:Restaurant!
    var pipe:Pipe!
    var user:PFUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        txtMessage.becomeFirstResponder()
        
        if restaurant != nil {
            lblTo.text = "To: " + restaurant.name
        }
        else if user != nil {
            lblTo.text = "To: " + user.username!
        }
        else {
            lblTo.text = ""
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    
    Add the comment to the pipe and save it if it's a comment
    If it's a message, send that message to the user
    
    */
    @IBAction func saveMessage(sender: UIButton) {
        
        if pipe != nil {
            saveCommentToPipe() // Save the comment created to the current pipe
        }
        else if user != nil {
            saveAction() // Store the action on the server
        }
        
        self.navigationController?.popViewControllerAnimated(true)

    }
    
    func saveAction () {
        let action = Action()
        
        if PFUser.currentUser() != nil {
            action.fromUser = PFUser.currentUser()
        }
        else {
            return
        }
        
        action.type = ACTION_TYPE_MESSAGE
        action.actionDescription = txtMessage.text
        action.time = NSDate()
        action.toUser = user;
        action.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
            if error == nil {
                NSLog("Action with id - " + action.objectId! + " - saved to server")
            }
        })
    }
    
    func saveCommentToPipe () {
        // If this is a pipe comment, than save this to the pipe
        if pipe.comments == nil {
            pipe.comments = Array<String>()
        }
        
        pipe.comments.append(txtMessage!.text)
        
        pipe.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
            if error == nil {
                NSLog("Saved comment to pipe")
            }
        })
        
        
        let view = NSBundle.mainBundle().loadNibNamed(VIEW_SUCCESS_INDICATOR_VIEW, owner: self, options: nil).first as! UIView
        let lblTitle = view.subviews.first as! UILabel
        lblTitle.text = "Saved Comment"
        DEAnimationManager.savedAnimationWithView(view)
    }

    @IBAction func cancelButtonPressed(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
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
