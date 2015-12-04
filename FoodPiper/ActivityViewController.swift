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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "Activity"
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            let user = PFUser.currentUser()
            let objectKeyValues: [String : AnyObject!] = [ACTION_TO_USER:user, ACTION_VIEWED: NSNumber(bool: false)]
            self.actions = SyncManager.getParseObjectsWithClass(PARSE_CLASS_ACTION, objectKeyValues: objectKeyValues, queryType: ParseQueryType.WhereKeyEqualTo, containedInNot: [AnyObject]()) as! [Action]
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
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (actions != nil)
        {
            return actions.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let action = actions[indexPath.row]
        let cell = configureBasicCell(action, indexPath: indexPath)
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let action = actions[indexPath.row]
        let cell = configureBasicCell(action, indexPath: indexPath)
        cell.layoutIfNeeded()
        let size = cell.contentView .systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        return size.height
    }
    
    func configureBasicCell (action: Action, indexPath: NSIndexPath) -> UITableViewCell {
        if action.type == UserAction.Message.rawValue { // If this is a message action
            let cell = NSBundle.mainBundle().loadNibNamed("MessageTableViewCell", owner: self, options: nil).first as! MessageTableViewCell
            cell.lblMessage.text = action.actionDescription
            cell.action = action
            
            return cell
        }
        else if action.type == UserAction.Invite.rawValue {
            let cell = NSBundle.mainBundle().loadNibNamed("InviteTableViewCell", owner: self, options: nil).first as! MessageTableViewCell
            cell.lblMessage.text = "Invited you to a meal @ " + action.actionDescription
            cell.action = action
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    @IBAction func replyToMessageButtonPressed(sender: UIButton) {
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
    }
    @IBAction func declineMealInvite(sender: UIButton) {
        
        let cell = sender.superview?.superview as! MessageTableViewCell
        let previousAction = cell.action
        let action = Action()
        action.type = UserAction.InviteAccept.rawValue
        action.fromUser = PFUser.currentUser()
        action.toUser = previousAction.fromUser
        action.actionDescription = (PFUser.currentUser()?.username)! +  " declined your invitation @ " + previousAction.actionDescription
        SyncManager.saveParseObject(action, message: "Invitation Declined")
        
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
        
    }
}

