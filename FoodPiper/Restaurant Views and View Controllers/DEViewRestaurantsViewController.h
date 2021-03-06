//
//  DEViewEventsViewController.h
//  whatsgoinon
//
//  Created by adeiji on 8/5/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DEViewRestaurantsView.h"
#import "DEScreenManager.h"
#import <Masonry/Masonry.h>


@interface DEViewRestaurantsViewController : UIViewController <UIScrollViewDelegate, MFMailComposeViewControllerDelegate, UISearchBarDelegate, UIGestureRecognizerDelegate, UIPageViewControllerDelegate, UIPageViewControllerDataSource>
{
    DEViewMainMenu *viewMainMenu;
    BOOL menuDisplayed;
    NSString *category;
    UIView *outerView;
    UIButton *orbView;
    SEL postSelector;
    CGFloat lastContentOffset;
    UIActivityIndicatorView *spinner;
    BOOL welcomeScreen;
    UIView *tutorialView;
    UIGestureRecognizer *tapGestureCloseMenuRecognizer;
    UIVisualEffectView *blurView;
}

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainViewLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainViewRightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *lblCategoryHeader;
@property (strong, nonatomic) NSArray *restaurants;
@property (strong, nonatomic) NSMutableArray *restaurantsCopy;
@property (strong, nonatomic) NSMutableArray *searchPosts;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) UIView *tileView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *categoryHeightConstraint;
@property BOOL shouldNotDisplayPosts;
@property BOOL overlayDisplayed;
@property BOOL now;
@property BOOL isNewProcess;


- (IBAction)sortTrending:(id)sender;
- (IBAction)sortNearMe:(id)sender;
- (IBAction)sortStartTime:(id)sender;


@end
