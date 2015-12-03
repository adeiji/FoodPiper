//
//  FoodPiperButtons.swift
//  FoodPiper
//
//  Created by adeiji on 12/2/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import UIKit

class FoodPiperButtons: UIButton {

    enum RestorationIdentifiers : String {
        case WaitTime = "waittime"
        case Food = "food"
        case Deals = "deals"
        case Message = "message"
        case Decor = "decor"
        case Crowd = "crowd"
        case CheckIn = "checkin"
        case Picture = "picture"
        case Service = "service"
        case Email = "email"
        case Call = "call"
        case Website = "website"
        case Hours = "hours"
        case Directions = "directions"
        case Favorites = "favorites"
        case Reservation = "reservation"
        case Peep = "peep"
        case Percent = "percent"
        case Free = "free"
        case Dollar = "dollar"
        case Profile = "profile"
        case Fast = "fast"
        case SoSo = "soso"
        case Slow = "slow"
        case SlowCrowd = "slowcrowd"
        case GoodCrowd = "goodcrowd"
        case PackedCrowd = "packedcrowd"
        case NotHotCrowd = "nothotcrowd"
        case HotCrowd = "hotcrowd"
        case SoSoCrowd = "sosocrowd"
        case Comment = "comment"
        case Friends = "friends"
        case Remove = "remove"
        case Pipe = "pipe"
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        switch self.restorationIdentifier {
        case RestorationIdentifiers.WaitTime.rawValue?:
            FoodPiperIcons.drawHoursIconWithFrame(rect)
            break
        case RestorationIdentifiers.Hours.rawValue?:
            FoodPiperIcons.drawHoursIconWithFrame(rect)
            break
        case RestorationIdentifiers.Food.rawValue?:
            FoodPiperIcons.drawFoodIconWithFrame(rect)
            break
        case RestorationIdentifiers.Deals.rawValue?:
            FoodPiperIcons.drawDealsIconWithFrame(rect)
            break
        case RestorationIdentifiers.Comment.rawValue?:
            FoodPiperIcons.drawCommentIconWithFrame(rect)
            break
        case RestorationIdentifiers.Decor.rawValue?:
            FoodPiperIcons.drawDecorIconWithFrame(rect)
            break
        case RestorationIdentifiers.Crowd.rawValue?:
            FoodPiperIcons.drawCrowdIconWithFrame(rect)
            break
        case RestorationIdentifiers.Picture.rawValue?:
            FoodPiperIcons.drawCameraIconWithFrame(rect)
            break
        case RestorationIdentifiers.Service.rawValue?:
            FoodPiperIcons.drawServiceIcon()
            break
        case RestorationIdentifiers.Email.rawValue?:
            FoodPiperIcons.drawSendMessageIconWithFrame(rect)
            break
        case RestorationIdentifiers.Message.rawValue?:
            FoodPiperIcons.drawSendMessageIconWithFrame(rect)
            break
        case RestorationIdentifiers.Call.rawValue?:
            FoodPiperIcons.drawPhoneIconWithFrame(rect)
            break
        case RestorationIdentifiers.Website.rawValue?:
            FoodPiperIcons.drawWebsiteIconWithFrame(rect)
            break
        case RestorationIdentifiers.Hours.rawValue?:
            FoodPiperIcons.drawHoursIconWithFrame(rect)
            break
        case RestorationIdentifiers.Directions.rawValue?:
            FoodPiperIcons.drawDirectionIconWithFrame(rect)
            break
        case RestorationIdentifiers.Favorites.rawValue?:
            FoodPiperIcons.drawViewFavoritesIconWithFrame(rect)
            break
        case RestorationIdentifiers.Reservation.rawValue?:
            FoodPiperIcons.drawReservationIconWithFrame(rect)
            break
        case RestorationIdentifiers.Peep.rawValue?:
            FoodPiperIcons.drawPeepIconWithFrame(rect)
            break
        case RestorationIdentifiers.CheckIn.rawValue?:
            FoodPiperIcons.drawCheckInIconWithFrame(rect)
            break
        case RestorationIdentifiers.Percent.rawValue?:
            FoodPiperIcons.drawPercentOffIconWithFrame(rect)
            break
        case RestorationIdentifiers.Free.rawValue?:
            FoodPiperIcons.drawFreeIconWithFrame(rect)
            break
        case RestorationIdentifiers.Dollar.rawValue?:
            FoodPiperIcons.drawDollarOffIconWithFrame(rect)
            break
        case RestorationIdentifiers.Profile.rawValue?:
            FoodPiperIcons.drawProfileIconWithFrame(rect)
            break
        case RestorationIdentifiers.Fast.rawValue?:
            FoodPiperIcons.drawFastIconWithFrame(rect)
            break
        case RestorationIdentifiers.SoSo.rawValue?:
            FoodPiperIcons.drawSoSoIcon()
            break
        case RestorationIdentifiers.Slow.rawValue?:
            FoodPiperIcons.drawSlowIconWithFrame(rect)
            break
        case RestorationIdentifiers.SlowCrowd.rawValue?:
            FoodPiperIcons.drawCrowdSlowIconWithFrame(rect)
            break
        case RestorationIdentifiers.GoodCrowd.rawValue?:
            FoodPiperIcons.drawCrowdGoodIcon()
            break
        case RestorationIdentifiers.PackedCrowd.rawValue?:
            FoodPiperIcons.drawCrowdPackedIconWithFrame(rect)
            break
        case RestorationIdentifiers.NotHotCrowd.rawValue?:
            FoodPiperIcons.drawNotHotIconWithFrame(rect)
            break
        case RestorationIdentifiers.SoSoCrowd.rawValue?:
            FoodPiperIcons.drawSoSoIcon()
            break
        case RestorationIdentifiers.Comment.rawValue?:
            FoodPiperIcons.drawCommentIconWithFrame(rect)
            break
        case RestorationIdentifiers.Friends.rawValue?:
            FoodPiperIcons.drawFriendsIconWithFrame(rect)
            break
        case RestorationIdentifiers.Remove.rawValue?:
            FoodPiperIcons.drawCancelIconLarge()
            break
        case RestorationIdentifiers.Pipe.rawValue?:
            FoodPiperIcons.drawPipeIconWithFrame(rect)
            break
        default:break
        }
        
    }


}
