//
//  DESyncManager.h
//  whatsgoinon
//
//  Created by adeiji on 8/5/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "DEScreenManager.h"

@class DEPost;

@interface DESyncManager : NSObject

// Get all the values from the Parse database
+ (void) updatePFObject : (PFObject *) postObject
     WithValuesFromPost : (DEPost *) post;
+ (void) saveReportWithEventId : (NSString * )objectId
                    WhatsWrong : (NSDictionary *) whatsWrong
                         Other : (NSString *) other;
+ (void) saveEventAsMiscategorizedWithEventId : (NSString *) objectId
                                     Category : (NSString *) category;
+ (void) saveObjectFromDictionary : (NSDictionary *) dictionary;
+ (void) updateObjectWithId : (NSString *) objectId
               UpdateValues : (NSDictionary *) values
             ParseClassName : (NSString *) className;
+ (void) saveCommentWithEventId : (NSString *) objectId
                        Comment : (NSString *) comment
                         Rating : (NSInteger) rating;
+ (void) getNumberOfPostByUser : (NSString *) username;
+ (void) saveUpdatedPFObjectToServer : (PFObject *) post;
+ (void) getEventsPostedByUser : (NSString *) username;
+ (void) getPFObjectForEventObjectIdAndUpdate:(NSString *)objectId
                                          WithPost : (DEPost *) post;

// Pull all the comments for this specific event
+ (NSArray *) getAllCommentsForEventId : (NSString *) objectId;

@end
