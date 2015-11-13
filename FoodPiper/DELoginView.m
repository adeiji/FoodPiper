//
//  DELoginView.m
//  whatsgoinon
//
//  Created by adeiji on 8/8/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DELoginView.h"
#import "PaintCodeBackgrounds.h"

@implementation DELoginView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    
    return self;
}

- (void) removeFirstResponder {
    // When the user taps the image, resign the first responder
    [_txtPassword resignFirstResponder];
    [_txtUsernameOrEmail resignFirstResponder];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self removeFirstResponder];
}



@end
