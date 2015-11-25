//
//  DEViewEventsViewController.m
//  whatsgoinon
//
//  Created by adeiji on 8/5/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DEViewRestaurantsViewController.h"
#import "Constants.h"
#import "Reachability.h"
#import "FoodPiper-Swift.h"

NSString *const VIEW_RESTAURANTS_VIEW = @"ViewRestaurantsView";
NSString *const VIEW_FILTER = @"FilterView";
NSString *const VIEW_FILTER_CATEGORY = @"FilterCategoryView";

@interface DEViewRestaurantsViewController ()

@end

#define POST_HEIGHT 251
#define POST_WIDTH 140
#define IPHONE_DEVICE_WIDTH 320
#define TOP_MARGIN 20
#define SCROLL_VIEW_DISTANCE_FROM_TOP 30
#define MAIN_MENU_Y_POS 0

const int NO_USER_EVENTS = 5;
NSString *IS_FIRST_TIME_VIEWING_SCREEN = @"com.happsnap.isfirsttimeviewingscreen";

@implementation DEViewRestaurantsViewController

struct TopMargin {
    int column;
    int height;
};

- (void) addObservers {
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayPost:) name:NOTIFICATION_CENTER_ALL_EVENTS_LOADED object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addLaterEvents) name:NOTIFICATION_LATER_EVENTS_ADDED object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSelectorToNewCity) name:kNOTIFICATION_CENTER_IS_CITY_CHANGE object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayUsersEvents:) name:NOTIFICATION_CENTER_USERS_EVENTS_LOADED object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orbClicked) name:NOTIFICATION_CENTER_ORB_CLICKED object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNoInternetConnectionScreen:) name:kReachabilityChangedNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayPostFromNewCity) name:NOTIFICATION_CENTER_CITY_CHANGED object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayPastEpicEvents:) name:NOTIFICATION_CENTER_NO_DATA object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayNoDataInCategory:) name:NOTIFICATION_CENTER_NONE_IN_CATEGORY object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayUserSavedEvents:) name:NOTIFICATION_CENTER_SAVED_EVENTS_LOADED object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayNoSavedEvents) name:NOTIFICATION_CENTER_NO_SAVED_EVENTS object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeAllPostFromScreen) name:kNOTIFICATION_CENTER_USER_INFO_USER_PROCESS_NEW object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayPastEpicEvents:) name:NOTIFICATION_CENTER_PAST_EPIC_EVENTS_LOADED object:nil];
}

#pragma mark - Activity Spinners

- (void) startActivitySpinner
{
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.center = self.view.center;
    spinner.hidesWhenStopped = YES;
    [self.view addSubview:spinner];
    [spinner startAnimating];
}

- (void) stopActivitySpinner {
    [spinner hidesWhenStopped];
    [spinner stopAnimating];
}

- (void) loadFirstTimeView {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *isFirstTimeViewingScreen = (NSNumber *) [userDefaults objectForKey:IS_FIRST_TIME_VIEWING_SCREEN];
    welcomeScreen = NO;
    
    if (!isFirstTimeViewingScreen)
    {

    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //Load the posts first so that we can see how big we need to make the scroll view's content size.
    [self addObservers];
    if (!_shouldNotDisplayPosts)
    {
#warning Google Analytics
//        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
//        [tracker set:kGAIScreenName value:@"Trending"];
//        [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
//
#warning may want to comment this out at some point
//        [[DEScreenManager sharedManager] showGettingEventsIndicatorWitText:@"Getting Events"];
        [self startActivitySpinner];
    
        [self loadFirstTimeView];
    }
    /* 
     
     Check to see if this is their first time going to this part of the application
     If it is their first time then show the welcome screen.
     Otherwise go straight to the viewing of the post
     Add the gesture recognizer which will be used to show and hide the main menu view
     
    */
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self setUpSearchBar];
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"Map View" style:UIBarButtonItemStylePlain target:self action:@selector(displayMapView)];
    [self.navigationItem setRightBarButtonItem:button];
    [self addPeepMenuButton];
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(displayFilterView)];
    [self.navigationItem setLeftBarButtonItem:leftButton];
}

- (void) displayFilterView {

    FilterViewController *viewController = [[FilterViewController alloc] initWithNibName:@"FilterView" bundle:nil];
    viewController.currentLocation = _currentLocation;
    viewController.viewRestaurantsViewController = self;
    [self.navigationController pushViewController:viewController animated:YES];
    
}

- (void) addPeepMenuButton {
    PeepIcon *button = [[PeepIcon alloc] initWithFrame:CGRectMake(25, self.view.frame.size.height - 140, 70, 70)];
    [button setShowsTouchWhenHighlighted:YES];
    [button setBackgroundColor:[UIColor clearColor]];
    [button addTarget:self action:@selector(showPeepMenu) forControlEvents:UIControlEventTouchUpInside];
    [button.layer setZPosition:1.0];
    [self.view addSubview:button];
}

- (void) showPeepMenu {
    
#warning Using a string that's not a constant for the xib name
    PipeMenuView *peepMenuView = [[[NSBundle mainBundle] loadNibNamed:@"ViewPeepMenu" owner:self options:nil] firstObject];
    UIView *mainWindow = [[[[UIApplication sharedApplication] keyWindow] subviews] lastObject];
    [mainWindow addSubview:peepMenuView];
    [peepMenuView setFrame:mainWindow.bounds];
    [peepMenuView animateButtons];
}
- (IBAction)closePeepMenuView:(UIButton *)sender {
    
    [sender.superview removeFromSuperview];
    
}

- (void) displayMapView {
    MapViewController *viewController = [MapViewController new];
    viewController.currentLocation = _currentLocation;
    viewController.restaurants = _restaurants;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void) removeFirstResponder {
    [_searchBar resignFirstResponder];
}

- (void) setUpSearchBar
{
    [self.searchBar setInputAccessoryView:[DEScreenManager createInputAccessoryView]];
    [self.searchBar setBackgroundImage:[UIImage new]];
    
    for (UIView *view in self.searchBar.subviews) {
        for (UIView *subview in view.subviews) {
            if ([subview isKindOfClass:[UITextField class]])
            {
                [subview setBackgroundColor:[UIColor colorWithRed:0.0/255.0f green:0.0/255.0f blue:0.0/255.0f alpha:.30]];
            }
        }
    }
}

- (void) enableClickOnEvents : (BOOL) clickable {
    for (UIView *subview in [_scrollView subviews]) {
        if (clickable) {
            [subview setUserInteractionEnabled:YES];
        }
        else {
            [subview setUserInteractionEnabled:NO];
        }
    }
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    // Check to see if the this View Controller is still in the view controller hierarchy, if not then we remove all the images
    if (![self.navigationController.viewControllers containsObject:self])
    {
        for (UIView *subview in [_scrollView subviews]) {
            if ([subview isKindOfClass:[DEViewRestaurantsView class]])
            {
                ((DEViewRestaurantsView *) subview).imgMainImageView.image = nil;
                [subview removeFromSuperview];
            }
            
        }
        
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    
    self.view.hidden = YES;
    [_scrollView setDelegate:nil];
}

- (void) viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    [self.view setHidden:YES];
    
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.scrollView setDelegate:self];
    _isNewProcess = YES;
    [self displayRestaurant:nil];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.hidden = NO;
    
}

- (void) hideOrbView
{
    if (!welcomeScreen)
    {
        orbView.hidden = YES;
        outerView.hidden = YES;
    }
}

- (void) showOrbView
{
    orbView.hidden = NO;
    outerView.hidden = NO;
}

- (void) displayPostFromNewCity
{
    for (UIView *subview in [_scrollView subviews]) {
        [subview removeFromSuperview];
    }
}

- (IBAction) showSortScreen : (id) sender {

#warning Google Analytics
//    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
//    [tracker set:kGAIScreenName value:@"SortMenu"];
//    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
}

- (IBAction)hideSortScreen:(id)sender {

}

- (IBAction)sortTrending:(id)sender {

}

- (void) sortArrayByKeyAndDisplay : (NSString *) key {
    

}

- (IBAction)sortNearMe:(id)sender {
    
    [self sortArrayByKeyAndDisplay:PARSE_CLASS_EVENT_DISTANCE];
}

- (IBAction)sortStartTime:(id)sender {
    [self sortArrayByKeyAndDisplay:PARSE_CLASS_EVENT_START_TIME];
}

- (void) moveViewToCenterOfScrollViewView : (UIView *) view {
    CGPoint center = view.center;
    center.x = _scrollView.center.x;
    [view setCenter:center];
}

/*
 
 Check to see if there is an internet connection and if we find none then go to the main screen
 
 */
- (void) showNoInternetConnectionScreen : (NSNotification *) object {
    Reachability *reach = [object valueForKey:@"object"];
    
    if ([reach currentReachabilityStatus] == NotReachable)
    {
        if ([[_scrollView subviews] count] == 2)
        {
            UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"ViewNoInternet" owner:self options:nil] firstObject];
            
            for (UIView *subview in [view subviews]) {
                if ([subview isKindOfClass:[UIButton class]])
                {
                    UIButton *button = (UIButton *) subview;
                    [[button layer] setCornerRadius:BUTTON_CORNER_RADIUS];
                }
            }
            
            [view setFrame:[[UIScreen mainScreen] bounds]];
            
            [DEAnimationManager fadeOutWithView:self.view ViewToAdd:view];
            [[DEScreenManager sharedManager] stopActivitySpinner];
        }
        
        [self hideOrbView];
    }
}

- (void) displayCategory : (NSString *) myCategory
{
    self.lblCategoryHeader.text = myCategory;
}

// Remove all the events/posts currently on the screen and free the images from memory
- (void) removeAllPostFromScreen {
    // Always hide the main menu when we show anything new on the screen
    for (UIView *subview in [_scrollView subviews]) {
        if ([subview isKindOfClass:[DEViewRestaurantsView class]])
        {
            ((DEViewRestaurantsView *) subview).imgMainImageView.image = nil;
            [subview removeFromSuperview];
        }
        
        [subview removeFromSuperview];
    }
}


- (void) displayRestaurant : (NSNotification *) notification {
    _isNewProcess = YES;
    
    if (_restaurants.count != 0)
    {
        [self removeAllPostFromScreen];
        [self stopActivitySpinner];
        [self displayRestaurantWithTopMargin:0 PostArray:nil];
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
        [self loadVisiblePost:_scrollView];
    }
    else {
        [SyncManager showSuccessIndicator:@"No Restaurants Found"];
    }
}

- (void) displayRestaurantWithTopMargin : (CGFloat) topMargin
                              PostArray : (NSArray *) postArray
{
    
    [self addEventsToScreen : 0
                   PostArray:_restaurants
                   ShowBlank:YES];
        

    [self loadVisiblePost:_scrollView];
}

/*
 
 Display to the user that he has no events that he posted, and show a button which will allow the user to post an event.
 
 */
- (void) showNoPostedEventsByUser {
    [self removeAllPostFromScreen];
    UIView *noPostedEventsView = [[[NSBundle mainBundle] loadNibNamed:@"ViewEventsView" owner:self options:nil] objectAtIndex:NO_USER_EVENTS];
    [noPostedEventsView setFrame:[[UIScreen mainScreen] bounds]];
    [_scrollView addSubview:noPostedEventsView];
    CGRect frame = [noPostedEventsView frame];
    frame.size.height = _scrollView.frame.size.height;
    [noPostedEventsView setFrame:frame];
    CGSize contentSize = [_scrollView contentSize];
    contentSize.height = _scrollView.frame.size.height;
    [_scrollView setContentSize:contentSize];

    [self hideOrbView];
}

- (void) getEventsFromEventIdsInGoingAndMaybe {
    
}

- (void) setUpScrollViewForPostsWithTopMargin : (NSInteger) topMargin
{
    //The calculation for the height gets the number of posts divided by two and then adds whatever the remainder is.  This makes sure that if there are for example 9 posts, we make sure that we do POST_HEIGHT * 5, and not 4, because the last post needs to show.
    CGSize size = _scrollView.contentSize;
    size.height = size.height + topMargin;
    _scrollView.contentSize = size;
}

- (void) addEventsToScreen : (CGFloat) topMargin
                 PostArray : (NSArray *) postArray
                 ShowBlank : (BOOL) showBlank
{
    static CGFloat column = 0;
    static int postCounter = 1;
    static CGFloat columnOneMargin = 0;
    static CGFloat columnTwoMargin = 0;
    static CGFloat margin = 0;
    static NSInteger numberOfPostOnScreen = 0;
    CGFloat scrollViewContentSizeHeight = 0;
    __block BOOL validated;
    static int count = 0;
    validated = NO;
    BOOL addPost = YES;

    
    if (_isNewProcess)     /*   If we've finished loading all the
                                events then we reset everything back
                                to zero so that next time we load
                                events it will show them correctly*/
    {
        column = 0;
        postCounter = 1;
        columnOneMargin = 0;
        columnTwoMargin = 0;
        margin = 0;
        scrollViewContentSizeHeight = 0;
        numberOfPostOnScreen = 0;
        postCounter = 0;
        _isNewProcess = NO;
        count = 0;
    }
    
    if (count < [postArray count])
    {
        for (int i = 0; i < 10; i ++) {
            if ([postArray count] != 0 && count < [postArray count])
            {
                if ((numberOfPostOnScreen >= 50))
                {
                    addPost = NO;
                }
                
                if (addPost)
                {
                    Restaurant *restaurant = postArray[count];
//                    validated = [self isValidToShowEvent:obj PostNumber : postCounter];
                    validated = YES;
                    // Show the event on the screen
//                    if (([obj[@"loaded"] isEqual:@NO] || !obj[@"loaded"])  && validated)
                    if (validated)
                    {
                        [self loadRestaurant:restaurant
                                     Margin1:&columnOneMargin
                                     Margin2:&columnTwoMargin
                                      Column:&column
                                   TopMargin:topMargin
                                 PostCounter:&postCounter
                                   ShowBlank:showBlank];
                    }
                    
                    count ++;
                    numberOfPostOnScreen ++;
                }
            }
        }


        // Add the column one or column two margin, depending on which is greater to the height of the scroll view's content size
        if (columnOneMargin > columnTwoMargin)
        {
            scrollViewContentSizeHeight += (columnOneMargin) + topMargin;
        }
        else {
            scrollViewContentSizeHeight += (columnTwoMargin) + topMargin;
        }
        
        CGSize size = _scrollView.contentSize;
        size.height = scrollViewContentSizeHeight;
        [_scrollView setContentSize:size];
    }
    
}

- (NSArray *) setAllPostsToNotLoaded : (NSArray *) posts {
    for (PFObject *obj in posts) {
        obj[@"loaded"] = @NO;
    }
    
    return posts;
}

/*
 
 Display to the user that there were no events that the user has saved
 
 */

- (void) displayNoSavedEvents {
    [self removeAllPostFromScreen];
    UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"ViewEventsView" owner:self options:nil] objectAtIndex:3];
    [_scrollView addSubview:view];
    [self moveViewToCenterOfScrollViewView:view];
    [_scrollView setContentSize:view.frame.size];
    [self showOrbView];
    
    [self scrollToTopOfScrollView];
    _lblCategoryHeader.text = @"Going/Maybe Events";
}

/*
 
 Check to see if it is valid to show this event on the screen
 
 */

- (BOOL) isValidToShowEvent : (PFObject *) obj
                 PostNumber : (int) postCounter
{
    BOOL validated = NO;
    
    if (postCounter < 50)
    {
        if ([obj[PARSE_CLASS_EVENT_POST_RANGE] isEqual:@0])
        {
            validated = YES;
        }
        else {
            validated = NO;
        }
    }

    
    return validated;
}

/*
 
 Set up the view events view.  Add the event, and display it properly with its image
 
 */
- (void) setUpViewEventsFrame : (CGFloat) columnOneMargin
                       Margin : (CGFloat) columnTwoMargin
                   Restaurant : (Restaurant *) post
                       Column : (int) column
          ViewRestaurantsView : (DEViewRestaurantsView *) view
             HeightDifference : (CGFloat) heightDifference
                    TopMargin : (CGFloat) topMargin

{
    CGFloat margin;
    [[view layer] setCornerRadius:5.0f];
    static double widthMargin = 13;
    
    if (column == 0)
    {
        margin = columnOneMargin;
    }
    else {
        margin = columnTwoMargin;
    }
    
    CGFloat screenSizeRelativeToiPhone5Width = [[UIScreen mainScreen]  bounds].size.width / 320;
    
    CGFloat viewEventsViewHeight = (POST_HEIGHT) + heightDifference;
    CGRect frame = CGRectMake((column * (POST_WIDTH * screenSizeRelativeToiPhone5Width)) + ((widthMargin * screenSizeRelativeToiPhone5Width) * (column + 1)), topMargin + (margin), (POST_WIDTH * screenSizeRelativeToiPhone5Width), viewEventsViewHeight);

    view.frame = frame;
}

/*
 
 Load the event
 
 */
- (void) loadRestaurant : (Restaurant *) restaurant
                Margin1 : (CGFloat *) columnOneMargin
                Margin2 : (CGFloat *) columnTwoMargin
                 Column : (CGFloat *) column
              TopMargin : (CGFloat) topMargin
            PostCounter : (int *) postCounter
              ShowBlank : (BOOL) showBlank
{
    CGFloat viewRestaurantsViewFrameHeight = POST_HEIGHT;
    
//    [DEPost getPostFromPFObject:obj];
    
    DEViewRestaurantsView *viewRestaurantsView = [[[NSBundle mainBundle] loadNibNamed:VIEW_RESTAURANTS_VIEW owner:self options:nil] objectAtIndex:0];
    [viewRestaurantsView setCurrentLocation:_currentLocation];
    [viewRestaurantsView setSearchBar:_searchBar];
    [viewRestaurantsView renderViewWithRestaurant:restaurant
                                   ShowBlank:showBlank];
    [viewRestaurantsView setRestaurant:restaurant];
    
    CGFloat heightDifference = [self getLabelHeightDifference:viewRestaurantsView];
    heightDifference += [self getEventImageHeightDifferenceOfImage:restaurant AndView:viewRestaurantsView];
    
    [self setUpViewEventsFrame:*columnOneMargin
                        Margin:*columnTwoMargin
                    Restaurant:restaurant
                        Column:*column
           ViewRestaurantsView:viewRestaurantsView
              HeightDifference:heightDifference
                     TopMargin:topMargin];
    
    [_scrollView addSubview:viewRestaurantsView];
    [viewRestaurantsView loadImage];
    if (*column == 0)
    {
        *column = 1;
        *columnOneMargin += viewRestaurantsViewFrameHeight + heightDifference + TOP_MARGIN;
    }
    else {
        *column = 0;
        *columnTwoMargin += viewRestaurantsViewFrameHeight + heightDifference + TOP_MARGIN;
        *postCounter = *postCounter + 1;
    }
}

/*
 
 Get the difference of height between the label with no description, and the label with the size necessary to fit to the description
 
 */
- (CGFloat) getLabelHeightDifference : (DEViewRestaurantsView *) view {
    // Set the height of the UITextView for the description to the necessary height to fit all the information
    CGSize sizeThatFitsTextView = [[view lblSubtitle] sizeThatFits:CGSizeMake(view.frame.size.width, 1000)];
    // Get the heightDifference from what it's original size is and what it's size will be
    CGFloat heightDifference = ceilf(sizeThatFitsTextView.height) - [view lblSubtitle].frame.size.height;
    
    return heightDifference;
}

- (CGFloat) getEventImageHeightDifferenceOfImage : (Restaurant *) restaurant
                                         AndView : (DEViewRestaurantsView *) view
{
    if (restaurant.image)
    {
        CGFloat height = [restaurant.imageHeight doubleValue];
        CGFloat width = [restaurant.imageWidth doubleValue];
        
        return [self resizeViewEventsImageView:view ImageWidth:width ImageHeight:height];
    }
    else {
        CGFloat screenSizeRelativeToiPhone5Width = [[UIScreen mainScreen]  bounds].size.width / 320;
        return screenSizeRelativeToiPhone5Width * view.imgMainImageView.frame.size.height - view.imgMainImageView.frame.size.height;
    }
    
    return 0;
}

- (CGFloat) resizeViewEventsImageView : (DEViewRestaurantsView *) view
                        ImageWidth : (double) width
                       ImageHeight : (double) height
{
    CGFloat correctImageViewHeight = (view.imgMainImageView.frame.size.width / width) * height;
    
    if (correctImageViewHeight < view.imageViewHeightConstraint.constant) {
        [view.imgMainImageView setContentMode:UIViewContentModeScaleAspectFill];
    }
    else {
         view.imageViewHeightConstraint.constant = correctImageViewHeight;
    }
    
    return view.imageViewHeightConstraint.constant - view.imgMainImageView.frame.size.height;
}

- (void) getDistanceFromCurrentLocationOfEvent : (PFObject *) event {

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeSlowConnectionBox:(id)sender {
    
    UIButton *button = (UIButton *) sender;
    [DEAnimationManager animateViewOut:[button superview] WithInsets:UIEdgeInsetsZero];
    
}


#pragma mark - Scroll View Delegate Methods
- (void) scrollToTopOfScrollView
{
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    [_scrollView setContentSize:_scrollView.frame.size];
    [self loadVisiblePost:_scrollView];
}

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self loadVisiblePost:scrollView];
}

- (void) scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [self loadVisiblePost:scrollView];
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadVisiblePost:scrollView];
    BOOL scrollDown= NO;
    
    if (scrollView.contentOffset.y > lastContentOffset)
    {
        scrollDown = YES;
    }
    
    if (scrollDown && scrollView.contentOffset.y > scrollView.contentSize.height - 1000)
    {
        [self addEventsToScreen : 0
                       PostArray:_restaurants
                       ShowBlank:YES];
        
        NSLog(@"Load events again");
    }
    
    lastContentOffset = scrollView.contentOffset.y;
}

- (void) loadVisiblePost : (UIScrollView *) scrollView
{
    for (UIView *view in [scrollView subviews]) {
        if ([view isKindOfClass:[DEViewRestaurantsView class]])
        {
            if (CGRectIntersectsRect(scrollView.bounds, view.frame))
            {
                [((DEViewRestaurantsView *) view) showImage];

            }
            else {
                [((DEViewRestaurantsView *) view) hideImage];
            }
        }
    }
    
}

- (void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    _searchPosts = [NSMutableArray new];
    _restaurantsCopy = [_restaurants copy];
}

- (void) searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self removeAllPostFromScreen];
    
    for (PFObject *obj in _restaurants)
    {
        obj[@"loaded"] = @NO;
    }
    
    _isNewProcess = YES;
    [self addEventsToScreen:0
                  PostArray:_restaurants
                  ShowBlank:NO];
    [self loadVisiblePost:_scrollView];
}

#pragma mark - Search Bar Delegate Methods
- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self removeAllPostFromScreen];
    
    if (![[searchText stringByReplacingOccurrencesOfString:@" " withString:@"" ] isEqualToString:@""])
    {
        [_restaurantsCopy enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Restaurant *restaurant = (Restaurant *) obj;
            if ([[restaurant.name lowercaseString] rangeOfString:[searchText lowercaseString] ].location != NSNotFound
                )
            {
                [_searchPosts addObject:obj];
            }
        }];
        
        _restaurants = _searchPosts;
        _isNewProcess = YES;
        [self addEventsToScreen:0
                      PostArray:_restaurants
                      ShowBlank:NO];
        [self loadVisiblePost:_scrollView];
        _searchPosts = [NSMutableArray new];
    }
    else {
        _restaurants = [_restaurantsCopy copy];
        
        for (PFObject *obj in _restaurants) {
            obj[@"loaded"] = @NO;
        }
        _isNewProcess = YES;
        [self addEventsToScreen:0
                      PostArray:_restaurants
                      ShowBlank:NO];
        [self loadVisiblePost:_scrollView];
    }
}



#pragma mark - Gesture Recognizer Delegate Methods 
- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
