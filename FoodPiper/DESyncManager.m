//
//  DESyncManager.m
//  whatsgoinon
//
//  Created by adeiji on 8/5/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DESyncManager.h"
#import <Parse/Parse.h>
#import "Constants.h"
#import "Reachability.h"

static PFQuery *globalQuery;

@implementation DESyncManager

static NSString *const kEventsUserPromptedForComment = @"com.happsnap.eventsUserPromptedForComment";

// Get all the future values from the server and store this information, then when the user wants to get Now or Later events, they will come from this list rather then be pulled down from the server
+ (void) getAllValues {
    [self checkForInternet];
    
    __block PFQuery *query = [PFQuery queryWithClassName:PARSE_CLASS_NAME_EVENT];
    //Get all the events that are currently active
    NSDate *nowDate = [NSDate date];
    
    [query orderByAscending:PARSE_CLASS_EVENT_START_TIME];
    [query whereKey:PARSE_CLASS_EVENT_ACTIVE equalTo:[NSNumber numberWithBool:true]];
    [query whereKey:PARSE_CLASS_EVENT_START_TIME greaterThan:nowDate];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            //Store the events pulled down from the server
//            [sharedManager setPosts:objects];
//            [sharedManager setAllEvents:objects];
//            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CENTER_ALL_EVENTS_LOADED object:nil];
            NSLog(@"Notification sent, events loaded");

        }
        else {
            // The find failed, let the customer know
            NSLog(@"Error: %@", [error description]);
        }
    }];
}


+ (PFQuery *) getBasePFQueryForNow : (BOOL) now {
    PFQuery *query = [PFQuery queryWithClassName:PARSE_CLASS_NAME_EVENT];
    
    //Get all the events that are currently active and less than three hours away to start
    NSDate *date = [NSDate date];
    NSTimeInterval threeHours = (3 * 60 * 60) - 1;
    NSDate *later = [date dateByAddingTimeInterval:threeHours];
    
    [query orderByDescending:PARSE_CLASS_EVENT_THUMBS_UP_COUNT];
    [query orderByDescending:PARSE_CLASS_EVENT_NUMBER_GOING];
    [query orderByDescending:PARSE_CLASS_EVENT_VIEW_COUNT];
    [query whereKey:PARSE_CLASS_EVENT_ACTIVE equalTo:[NSNumber numberWithBool:true]];
    [query setLimit:1000];
    
    if (now)
    {
        [query whereKey:PARSE_CLASS_EVENT_END_TIME greaterThan:[NSDate date]];
        [query whereKey:PARSE_CLASS_EVENT_START_TIME lessThan:later];
    }
    else
    {
        [query whereKey:PARSE_CLASS_EVENT_START_TIME greaterThan:later];
    }
    
    return query;
}


// Show a view that shows that it's taken too long to connect to the server
+ (void) takingTooLongToConnect {
    

}



// Pull all the comments for this specific event
+ (NSArray *) getAllCommentsForEventId : (NSString *) objectId
{
    PFQuery *query = [PFQuery queryWithClassName:PARSE_CLASS_NAME_COMMENT];
    [query whereKey:PARSE_CLASS_COMMENT_EVENT_ID equalTo:objectId];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        // Post a notification saying that the comments have been loaded
       if (!error)
       {

       }
    }];
    
    return nil;
}

+ (void) checkForInternet
{
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.google.com"];
    
    // Start the notifier, which will case the reachability object to retain itself
    [reach startNotifier];
}

+ (void) saveObjectFromDictionary:(NSDictionary *)dictionary
{
    
}

+ (void) updateObjectWithId:(NSString *)objectId
               UpdateValues:(NSDictionary *)values
             ParseClassName:(NSString *) className;
{
    PFQuery *query = [PFQuery queryWithClassName:className];
    
    [query getObjectInBackgroundWithId:objectId block:^(PFObject *object, NSError *error) {
        for (NSString *key in values) {
            id value = [values objectForKey:key];
            object[key] = value;
        }
        
        [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error)
            {
                NSLog(@"Saved successfully");
            }
            else
            {
                NSLog(@"Oh snap, something happened! - %@", error.description);
            }
        }];
    }];
}

+ (void) updatePFObject : (PFObject *) postObject
     WithValuesFromPost : (DEPost *) post {
    [postObject setObject:@NO forKey:@"loaded"];
    [postObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"happsnap.objectupdated");
        }
        else {
            NSLog(@"happsnap.updatefailedforobject");
        }
    }];
}

+ (void) getPFObjectForEventObjectIdAndUpdate:(NSString *)objectId
                                 WithPost : (DEPost *) post{
    PFQuery *query = [PFQuery queryWithClassName:PARSE_CLASS_NAME_EVENT];
    [query whereKey:PARSE_CLASS_EVENT_OBJECT_ID equalTo:objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
       if (!error)
       {
           PFObject *object = [objects firstObject];
           // Update the object with the new values
           [DESyncManager updatePFObject:object WithValuesFromPost:post];
       }
    }];
}


+ (void) updatePostCountForUser {
    PFQuery *query = [PFUser query];
    [query whereKey:PARSE_CLASS_USER_USERNAME equalTo:[[PFUser currentUser] username]];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        int postCount = [object[PARSE_CLASS_USER_POST_COUNT] intValue];
        object[PARSE_CLASS_USER_POST_COUNT] = [NSNumber numberWithInt:postCount + 1];
        [object saveEventually];
    }];
}


+ (void) saveEventAsMiscategorizedWithEventId : (NSString *) objectId
                                     Category : (NSString *) category
{
    PFObject *miscategorizedEventObject = [PFObject objectWithClassName:PARSE_CLASS_NAME_MISCATEGORIZED_EVENT];
    miscategorizedEventObject[PARSE_CLASS_MISCATEGORIZED_EVENT_ID] = objectId;
    miscategorizedEventObject[PARSE_CLASS_MISCATEGORIZED_EVENT_CATEGORY] = category;
    
    [miscategorizedEventObject saveEventually:^(BOOL succeeded, NSError *error){
        if (succeeded)
        {
            NSLog(@"You set the current object as miscategorized successfully");
        }
    }];
}

// Save the comment with the Event's id, and the actual comment, along with the user information

+ (void) saveCommentWithEventId : (NSString *) objectId
                        Comment : (NSString *) comment
                         Rating : (NSInteger) rating
{
    PFObject *commentObject = [PFObject objectWithClassName:PARSE_CLASS_NAME_COMMENT];
    commentObject[PARSE_CLASS_COMMENT_COMMENT] = comment;
    if ([PFUser currentUser])
    {
        commentObject[PARSE_CLASS_COMMENT_USER] = [PFUser currentUser];
    }
    
    commentObject[PARSE_CLASS_COMMENT_EVENT_ID] = objectId;
    
    if (rating > 0)
    {
        commentObject[PARSE_CLASS_COMMENT_THUMBS_UP] = [NSNumber numberWithBool:YES];
    }
    else
    {
        commentObject[PARSE_CLASS_COMMENT_THUMBS_UP] = [NSNumber numberWithBool:NO];
    }
    
    [commentObject saveEventually:^(BOOL succeeded, NSError *error) {
       if (succeeded)
       {
           NSLog(@"The comment was saved to the database");
       }
       else
       {
           NSLog(@"Error saving the comment: %@", [error description]);
       }
    }];
}

+ (void) saveReportWithEventId : (NSString * )objectId
                    WhatsWrong : (NSDictionary *) whatsWrong
                         Other : (NSString *) other
{
    
    PFObject *reportObject = [PFObject objectWithClassName:PARSE_CLASS_NAME_REPORT];
    
    reportObject[PARSE_CLASS_REPORT_EVENT_ID] = objectId;
    reportObject[PARSE_CLASS_REPORT_WHATS_WRONG] = whatsWrong;
    reportObject[PARSE_CLASS_REPORT_OTHER] = other;
    
    [reportObject saveEventually:^(BOOL succeeded, NSError *error) {
        if (succeeded)
        {
            NSLog(@"The report was saved to the server");
        }
    }];
}

+ (void) getNumberOfPostByUser : (NSString *) username {
    PFQuery *query = [PFUser query];
    [query whereKey:PARSE_CLASS_USER_USERNAME equalTo:username];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        NSNumber *postCount = object[PARSE_CLASS_USER_POST_COUNT];
        
        if (postCount == nil)
        {
            postCount = [NSNumber numberWithInt:0];
        }
        
    }];
}

+ (NSMutableArray *) getImagesArrayWithArray : (NSArray *) imageArray
{
    NSMutableArray *images = [NSMutableArray new];
    
    for (NSData *imageData in imageArray) {
        
        UIImage *image = [UIImage imageWithData:imageData];
        CGFloat width = [image size].width;
        CGFloat height = [image size].height;
        
        PFFile *imageFile = [PFFile fileWithName:[NSString stringWithFormat:@"post-image%@%f%@%f", IMAGE_DIMENSION_WIDTH, width, IMAGE_DIMENSION_HEIGHT, height] data:imageData];
        
        [images addObject:imageFile];
    }
    
    return images;
}

+ (void) saveUpdatedPFObjectToServer : (PFObject *) post {
    
    [post saveEventually:^(BOOL succeeded, NSError *error) {
        if (succeeded)
        {
            NSLog(@"The post object was saved successfuly: %@", post.objectId);
        }
        else {
            NSLog(@"Error saving the post object: %@", [error description]);
        }
    }];
}

+ (void) getEventsPostedByUser:(NSString *)username {
    [globalQuery cancel];
    PFQuery *query = [PFQuery queryWithClassName:PARSE_CLASS_NAME_EVENT];

    [query whereKey:PARSE_CLASS_EVENT_USERNAME equalTo:username];
    [query whereKey:PARSE_CLASS_EVENT_ACTIVE equalTo:[NSNumber numberWithBool:true]];
    [query whereKey:PARSE_CLASS_EVENT_END_TIME greaterThan:[NSDate date]];
    [query setLimit:1000];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error)
            {

            }
    }];
}


@end
