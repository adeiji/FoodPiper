//
//  DECreateAccountView.m
//  whatsgoinon
//
//  Created by adeiji on 8/8/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DECreateAccountView.h"
#import "Constants.h"

@implementation DECreateAccountView

#define ERROR_CODE_EMAIL_TAKEN @203

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

- (void) setUpView {
    
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UITextField class]])
        {
            UITextField *textField = (UITextField *) view;
            textField.delegate = self;
        }
    }
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UITextField class]])
        {
            [view resignFirstResponder];
        }
    }
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (void) setUpValidators {
    [_txtEmail addRegx:@"[A-Z0-9a-z._%+-]{3,}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}" withMsg:@"Must enter a valid email"];
    [_txtPassword addRegx:@"^(?!\\s*$).+" withMsg:@"Must enter a password"];
    [_txtUsername addRegx:@"^.{0,30}$" withMsg:@"Username must not be more than 30 characters."];
    [_txtConfirmPassword addConfirmValidationTo:_txtPassword withMsg:@"Passwords do not match"];
    
    [_txtEmail setPresentInView:self];
    [_txtPassword setPresentInView:self];
    [_txtUsername setPresentInView:self];
    [_txtConfirmPassword setPresentInView:self];
    
    
}

- (BOOL) validateTextFields
{
    if ([_txtEmail validate] &
        [_txtPassword validate] &
        [_txtUsername validate] &
        [_txtConfirmPassword validate])
    {
        // Success
        return YES;
    }
    
    return NO;
}



@end
