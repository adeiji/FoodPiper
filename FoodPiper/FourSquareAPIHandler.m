//
//  FourSquareAPIHandler.m
//  FoodPiper
//
//  Created by adeiji on 10/21/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

#import "FourSquareAPIHandler.h"

@implementation FourSquareAPIHandler

#define FOURSQUARE_PHOTO_URL @"https://api.foursquare.com/v2/venues/%@/photos?client_id=BJD14F53JE1APNINSUZYQRVZ0MDBMNGMKELBABBW0LG1JJO0&client_secret=E35PNTIOUHO5CPYMQHYAAZPMRR4F1S4GM333EY30R5KGPV0M&v=20151021"

static const NSString *GOOGLE_API_RESULTS = @"results";

+ (void) getPhotoFromId:(NSString *) foursquareId
        CompletionBlock:(completionBlock)callback {
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:FOURSQUARE_PHOTO_URL, foursquareId]]];
    
    NSOperationQueue *queue = [NSOperationQueue new];
    queue.name = @"Foursquare Photos API Queue";
    queue.maxConcurrentOperationCount = 3;
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data != nil)
        {
            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            NSDictionary *photo_details = jsonData[@"response"][@"photos"][@"items"][0];
            
            NSString *photo_url_prefix = photo_details[@"prefix"];
            NSString *photo_url_suffix = photo_details[@"suffix"];
            NSString *photo_width = photo_details[@"width"];
            NSString *photo_height = photo_details[@"height"];
            NSString *photo_url = [NSString stringWithFormat:@"%@%@x%@%@", photo_url_prefix, photo_width, photo_height, photo_url_suffix];
            
            if (![jsonData[@"status"] isEqualToString:@"ZERO_RESULTS"])
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    // Make sure that we call this method on the main thread so that it updates properly as supposed to
                    callback(photo_url);
                });
            }
        }
    }];
}
@end
