
//
//  FoodPiperConstants.swift
//  FoodPiper
//
//  Created by adeiji on 10/30/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import UIKit

let RATING_FOOD = "Food"
let RATING_DECOR = "Decor"
let RATING_SERVICE = "Service"
let RATING_WAIT_TIME = "Wait Time"
let RATING_CROWD = "Crowd"
let FIVE_STAR_RATING_VIEW = "FiveStarRatingView"
let WAIT_TIME_VIEW = "WaitTimeView"
let RATE_CROWD_VIEW = "RateCrowdView"
let PIPE_MENU_VIEW = "PipeMenuView"
let VIEW_INDIVIDUAL_RESTAURANT_XIB = "ViewIndividualRestaurant"
let PIPE_PARSE_CLASS = "Pipe"
let PIPE_RESTAURANT = "Restaurant"
let PIPE_IMAGE = "image"
let PIPE_USER = "user"
let PIPE_RESTAURANT_FACTUAL_ID = "restaurantFactualId"
let PARSE_RESTAURANT_LOCATION = "location"

let VIEW_RESTAURANTS_VIEW_CONTROLLER = "ViewRestaurantsViewController"
let VIEW_RESTAURANTS_STORYBOARD = "ViewRestaurants"
let VIEW_FILTER = "FilterView"
let VIEW_FILTER_CATEGORY = "FilterCategoryView"
let VIEW_FILTER_AVAILABILITY = "FilterAvailabilityView"
let VIEW_MAKE_RESERVATION = "MakeReservationView"
let VIEW_SUCCESS_INDICATOR_VIEW = "SuccessIndicatorView"
let VIEW_FRIENDS_LIST = "FriendsListView"
let VIEW_NO_FRIENDS = "NoFriendsView"
let VIEW_SETTINGS_ACCOUNT = "ViewSettingsAccount"
let VIEW_FRIEND = "FriendView"
let VIEW_INVITE_EAT_VIEW = "InviteEatView"
let VIEW_ACTIVITY = "ActivityView"

let PARSE_USER_FAVORITE_RESTAURANTS = "favoriteRestaurants"
let PARSE_USER_POINTS = "points"
let PARSE_USER_FRIENDS = "friends"
let PARSE_USER_FAVORITE_PIPES = "favoritePipes"
let PARSE_CLASS_ACTION = "Action"
let PARSE_RESTAURANT_IMAGE_URL = "image_url"
let PARSE_RESTAURANT_IMAGE_WIDTH = "image_width"
let PARSE_RESTAURANT_IMAGE_HEIGHT = "image_height"
let ACTION_TO_USER = "toUser"
let ACTION_VIEWED = "viewed"

let FILTER_CATEGORY_KEY = "category"
let FILTER_PRICE_KEY = "price"
let FILTER_AVAILABILITY_KEY = "availability"
let FILTER_DISTANCE_KEY = "distance"

let STORYBOARD_ID_PROMPT_LOGIN = "promptLoginViewController"

enum UserAction : String {
    case Message = "message"
    case Invite = "invite"
    case InviteAccept = "acceptInvite"
    case Response = "response"
}

enum ParseQueryType {
    case WhereKeyExists
    case WhereKeyDoesNotExists
    case WhereKeyEqualTo
    case WhereKeyLessThan
    case WhereKeyLessThanOrEqual
    case WhereKeyGreaterThan
    case WhereKeyGreaterThanOrEqual
    case WhereKeyNotEqualTo
    case WhereKeyContainedIn
    case WhereKeyNotContainedIn
    case WhereKeyContainsAllObjectsInArray
    case WhereKeyNearGeoPointWithinKilometers
}

enum RestorationIdentifiers : String {
    case SmallFood = "smallfood"
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

let FACTUAL_API_KEY = "MleIByZblcsN1V7TRLMh58AezBg5OvqT1EtZzKRM"
let FACTUAL_SECRET_KEY = "HKu1BsZY0Xzeo02mPRsywbC7LlzyZVcUrIjkTCt5"
