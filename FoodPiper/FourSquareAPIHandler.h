//
//  FourSquareAPIHandler.h
//  FoodPiper
//
//  Created by adeiji on 10/21/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FourSquareAPIHandler : NSObject

typedef void (^completionBlock) (NSString *value, NSString *foursquareId, NSString *photoWidth, NSString *photoHeight);

+ (void) getPhotoFromId:(NSString *) foursquareId CompletionBlock:(completionBlock)callback;

@end
