//
//  ActivityViewController.swift
//  FoodPiper
//
//  Created by adeiji on 11/20/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import UIKit

class ActivityViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    var actions:[Action]!
    var responses:[Action]!
    var tableViewCells:[UITableViewCell]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "Activity"
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            let user = PFUser.currentUser()
            var objectKeyValues: [String : AnyObject!] = [ACTION_TO_USER:user, ACTION_VIEWED: NSNumber(bool: false)]
            self.actions = SyncManager.getParseObjectsWithClass(PARSE_CLASS_ACTION, objectKeyValues: objectKeyValues, queryType: ParseQueryType.WhereKeyEqualTo,
                containedInNot: [AnyObject](), withinKilometers:0) as! [Action]
            objectKeyValues = [ACTION_TO_USER:user, ACTION_VIEWED: NSNumber(bool: true)]
            self.responses = SyncManager.getParseObjectsWithClass(PARSE_CLASS_ACTION, objectKeyValues: objectKeyValues, queryType: ParseQueryType.WhereKeyEqualTo,
                containedInNot: [AnyObject](), withinKilometers:0) as! [Action]
            for action in self.actions {
                do {
                    try action.fromUser.fetchIfNeeded()
                }
                catch {
                    NSLog("Error while fetching user")
                }
            }
            
            for action in self.responses {
                do {
                    try action.fromUser.fetchIfNeeded()
                }
                catch {
                    NSLog("Error while fetching user")
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView!.reloadData()
            })
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ActivityViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Actions from Others"
        }
        else {
            return "Responses"
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if (actions != nil)
            {
                return actions.count
            }
        }
        else if section == 1 {
            if responses != nil {
                return responses.count
            }
        }
        return 0
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var action:Action!
        
        if indexPath.section == 0 { // Actions
            action = actions[indexPath.row]
        }
        else { // Responses
            action = responses[indexPath.row]
        }
        
        let cell = configureBasicCell(action, indexPath: indexPath)
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        var action:Action!
        
        if indexPath.section == 0 { // Actions
            action = actions[indexPath.row]
        }
        else {
            action = responses[indexPath.row]
        }
        
        let cell = configureBasicCell(action, indexPath: indexPath)
        cell.layoutIfNeeded()
        let size = cell.contentView .systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        return size.height
        
        return 0
    }
    
    func configureBasicCell (action: Action, indexPath: NSIndexPath) -> UITableViewCell {
        
        if action.type == UserAction.Message.rawValue { // If this is a message action
            return configureMessageTableViewCell(action)
        }
        else if action.type == UserAction.Invite.rawValue { // Invitation
            return configureInviteMessageTableViewCell(action)
        }
        else if action.type == UserAction.Response.rawValue {
            return configureResponseTableViewCell(action)
        }
        
        return UITableViewCell()
    }
    
    func configureResponseTableViewCell (action: Action) -> UITableViewCell {
        let cell = NSBundle.mainBundle().loadNibNamed("MessageTableViewCell", owner: self, options: nil).first as! MessageTableViewCell
        let username = action.fromUser.username
        let message = action.actionDescription
        let attributedString = colorActionUsername(message, username: username!)
        
        cell.lblMessage.attributedText = attributedString
        cell.action = action
        cell.btnNegative.hidden = true
        cell.btnPositive.hidden = true
        
        return cell
    }
    
    func configureInviteMessageTableViewCell (action: Action) -> UITableViewCell {
        let cell = NSBundle.mainBundle().loadNibNamed("MessageTableViewCell", owner: self, options: nil).first as! MessageTableViewCell
        let username = action.fromUser.username
        var message = username! + ": Invited you to a meal @ " + action.actionDescription
        if action.restaurantName != nil {
            message = message + "\n Restaurant: " + action.restaurantName!
        }
        
        let attributedString = colorActionUsername(message, username: username!)
        cell.lblMessage.attributedText = attributedString
        cell.action = action
        addActionTargetsToButton(cell, positiveAction: "acceptMealInvite:", negativeAction: "declineMealInvite:", positiveActionTitle: "Accept", negativeActionTitle: "Decline")
        
        return cell
    }
    
    func configureMessageTableViewCell (action: Action) -> UITableViewCell  {
        let cell = NSBundle.mainBundle().loadNibNamed("MessageTableViewCell", owner: self, options: nil).first as! MessageTableViewCell
        let username = action.fromUser.username
        let message = username! + ": " + action.actionDescription
        let attributedString = colorActionUsername(message, username: username!)
        cell.lblMessage.attributedText = attributedString
        cell.action = action
        addActionTargetsToButton(cell, positiveAction: "replyToMessage:", negativeAction: "deleteMessage:", positiveActionTitle: "Reply", negativeActionTitle: "Delete")
        return cell
    }
    
    func colorActionUsername (message: String, username: String) -> NSMutableAttributedString {
        let range = (message as NSString).rangeOfString(username)
        let attributedString = NSMutableAttributedString(string: message)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 62/255, green: 151/255, blue: 175/255, alpha: 1), range: range)
        attributedString.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFontOfSize(17), range: range)
        
        return attributedString
    }
    
    func addActionTargetsToButton (cell: MessageTableViewCell, positiveAction: Selector, negativeAction: Selector, positiveActionTitle: String, negativeActionTitle: String) {
        cell.btnPositive.addTarget(self, action: positiveAction, forControlEvents: UIControlEvents.TouchUpInside)
        cell.btnNegative.addTarget(self, action: negativeAction, forControlEvents: .TouchUpInside)
        
        cell.btnPositive.setTitle(positiveActionTitle, forState: .Normal)
        cell.btnNegative.setTitle(negativeActionTitle, forState: .Normal)
    }
    
    func deleteMessage (sender: UIButton) {
        
    }
    
    func replyToMessage(sender: UIButton) {
        let cell = sender.superview?.superview as! MessageTableViewCell
        let messageViewController = MessageViewController()
        
        cell.action.fromUser.fetchIfNeededInBackgroundWithBlock { (object: PFObject?, error: NSError?) -> Void in
            if object != nil {
                messageViewController.user = cell.action.fromUser
                self.navigationController?.pushViewController(messageViewController, animated: true)
            }
            if error != nil {
                NSLog("Error fetching user: ", (error?.description)!)
            }
        }
        
        removeAction(cell.action)
    }
    func declineMealInvite(sender: UIButton) {
        
        let cell = sender.superview?.superview as! MessageTableViewCell
        let previousAction = cell.action
        let action = Action()
        action.type = UserAction.InviteAccept.rawValue
        action.fromUser = PFUser.currentUser()
        action.toUser = previousAction.fromUser
        action.actionDescription = (PFUser.currentUser()?.username)! +  " declined your invitation @ " + previousAction.actionDescription
        SyncManager.saveParseObject(action, message: "Invitation Declined")
        
        let message = "Declined meal invitation @ " + previousAction.actionDescription + " with " + previousAction.fromUser.username!
        createResponseAction(message, previousAction: previousAction)
        removeAction(previousAction)
        self.tableView.reloadData()
    }
    
    func createResponseAction (message: String, previousAction: Action) {
        let action = Action()
        action.type = UserAction.Response.rawValue
        action.toUser = PFUser.currentUser()
        action.fromUser = previousAction.fromUser
        action.actionDescription = message
        action.viewed = NSNumber(bool: true)
        responses.append(action)
        SyncManager.saveParseObject(action, message: "")
    }
    
    func removeAction (action: Action) {
        var count = 0
        for myAction in actions {
            if myAction == action {
                action.deleteInBackground() // Remove this action
                actions.removeAtIndex(count)
                count--
            }
            count++
        }
    }
    
    @IBAction func acceptMealInvite(sender: UIButton) {
        
        let cell = sender.superview?.superview as! MessageTableViewCell
        let previousAction = cell.action
        let action = Action()
        action.type = UserAction.InviteAccept.rawValue
        action.fromUser = PFUser.currentUser()
        action.toUser = previousAction.fromUser
        action.actionDescription = (PFUser.currentUser()?.username)! +  " accepted your invitation @ " + previousAction.actionDescription
        SyncManager.saveParseObject(action, message: "Invitation Accepted")
        
        let message = "Accepted meal invite @ " + previousAction.actionDescription + " with " + previousAction.fromUser.username!
        createResponseAction(message, previousAction: previousAction)
        removeAction(previousAction)
        self.tableView.reloadData()
        
    }
}

