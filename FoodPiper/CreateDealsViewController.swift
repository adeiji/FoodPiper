//
//  CreateDealsViewController.swift
//  FoodPiper
//
//  Created by adeiji on 11/25/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import UIKit

class CreateDealsViewController: UIViewController {

    @IBOutlet weak var txtItem: UITextField!
    @IBOutlet weak var txtDeal: UITextField!
    
    @IBOutlet weak var btnPercentOff: UIButton!
    @IBOutlet weak var secondItem: UITextField!
    
    var txtDealPlaceholder:String!
    var txtItemPlaceholder:String!
    var txtSecondItemPlaceholder:String!
    
    var restaurant:Restaurant!
    var dealType:DealType!
    
    let PERCENT_OFF_ITEM = 1, PRICE_OFF_ITEM = 2, BUY_ONE_GET_ONE_PERCENT = 3, BUY_ONE_GET_ONE_FREE = 4, BUY_ONE_GET_ONE_PRICE = 5
    
    enum DealType : String {
        case BuyOneGetOneFree = "buyOneGetOneFree"
        case BuyOneGetOnePercentOff = "buyOneGetOnePercentOff"
        case BuyOneGetOnePriceOff = "buyOneGetOnePriceOff"
        case PercentOffItemOrEntireBill = "percentOffItemOrEntireBill"
        case PriceOffItemOrEntireBill = "priceOffItemOrEntireBill"
        case FreeItem = "freeItem"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if btnPercentOff != nil {
            btnPercentOff.layer.borderColor = UIColor(red: 32/255, green: 137/255, blue: 163/255, alpha: 1).CGColor
        }
        
        if txtItem != nil {
            txtItem.layer.borderColor = UIColor(red: 186/255, green: 25/255, blue: 96/255, alpha: 1).CGColor
        }
        if txtDeal != nil {
            txtDeal.layer.borderColor = UIColor(red: 32/255, green: 137/255, blue: 163/255, alpha: 1).CGColor
        }
        
        if txtItemPlaceholder != nil {
            txtItem.placeholder = txtItemPlaceholder
        }
        if txtDealPlaceholder != nil {
            txtDeal.placeholder = txtDealPlaceholder
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneButtonPressed(sender: UIButton) {
        
        let deal = Deal()
        deal.dealType = dealType.rawValue
        
        switch dealType as DealType {
        case DealType.PercentOffItemOrEntireBill:
            deal.deal = txtDeal.text! + "% Off " + txtItem.text!
            break
        case DealType.PriceOffItemOrEntireBill:
            deal.deal = txtDeal.text! + "$ Off " + txtItem.text!
            break
        case DealType.BuyOneGetOneFree:
            deal.deal = "Buy One " + txtItem.text! + " Get One " + secondItem.text! + " Free"
            break
        case DealType.BuyOneGetOnePercentOff:
            deal.deal = "Buy One " + txtItem.text! + " Get One " + secondItem.text! + " " + txtDeal.text! + "% Off"
            break
        case DealType.BuyOneGetOnePriceOff:
            deal.deal = "Buy One " + txtItem.text! + " Get One " + secondItem.text! + " " + txtDeal.text! + "$ Off"
            break
        default:break
        }
        
        saveDeal(deal)
        
    }
    
    @IBOutlet weak var txtFreeItem: UITextField!
    
    @IBAction func freeItemDoneButtonPressed(sender: UIButton) {
        
        let deal = Deal()
        deal.dealType = dealType.rawValue
        deal.deal = "Get Free " + txtFreeItem.text!
        saveDeal(deal)
        
    }
    
    func saveDeal (deal: Deal) {
        deal.restaurant = restaurant.factualId
        SyncManager.saveParseObject(deal, message: "Deal Saved")
        let viewControllers = self.navigationController!.viewControllers
        let restaurantViewController = viewControllers[viewControllers.count - 3]
        self.navigationController?.popToViewController(restaurantViewController, animated: true)
    }
    
    @IBAction func entireBillPressed(sender: UIButton) {
        txtItem.text = "Entire Bill"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let viewController = segue.destinationViewController as! CreateDealsViewController
        
        viewController.restaurant = restaurant
        switch (sender as! UIButton).tag
        {
        case PERCENT_OFF_ITEM:
            viewController.txtDealPlaceholder = "% off"
            viewController.dealType = DealType.PercentOffItemOrEntireBill
            break
        case PRICE_OFF_ITEM:
            viewController.txtDealPlaceholder = "$ off"
            viewController.dealType = DealType.PriceOffItemOrEntireBill
            break
        case BUY_ONE_GET_ONE_PERCENT:
            viewController.txtDealPlaceholder = "% off"
            viewController.dealType = DealType.BuyOneGetOnePercentOff
            break
        case BUY_ONE_GET_ONE_PRICE:
            viewController.txtDealPlaceholder = "$ off"
            viewController.dealType = DealType.BuyOneGetOnePriceOff
            break
        case BUY_ONE_GET_ONE_FREE:
            viewController.txtDealPlaceholder = "Free"
            viewController.dealType = DealType.BuyOneGetOneFree
            break
        default: break
        }
    }
}

public class Deal : PFObject, PFSubclassing {
    
    @NSManaged var deal:String
    @NSManaged var restaurant:String
    @NSManaged var dealType:String
    
    public class func parseClassName() -> String {
        return "Deal"
    }
    
    public override class func initialize() {
        struct Static {
            static var onceToken: dispatch_once_t = 0
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
}