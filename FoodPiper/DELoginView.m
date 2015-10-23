//
//  DELoginView.m
//  whatsgoinon
//
//  Created by adeiji on 8/8/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DELoginView.h"

@implementation DELoginView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (void) setUpViewForiPhone4 {
    self.constraintBackButtonToOrLabel.constant = 0;
    self.constraintLoginButtonToAccountButtons.constant = 0;
    self.constraintOrLabelToLoginLabel.constant = 0;
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
