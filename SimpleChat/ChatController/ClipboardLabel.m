//
//  ClipboardLabel.m
//  SimpleChat
//
//  Created by Logan Wright on 5/10/14.
//  Copyright (c) 2014 Logan Wright. All rights reserved.
//


/*
 Mozilla Public License
 Version 2.0
 */


#import "ClipboardLabel.h"

@implementation ClipboardLabel

#pragma mark LOADING AND SETUP

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        // Add TapGesture
        [self addTapGestureRecognizer];
        
        // Make sure it will trigger
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void) awakeFromNib {
    [super awakeFromNib];
    [self addTapGestureRecognizer];
}

#pragma mark GESTURE RECOGNIZERS

- (void) addTapGestureRecognizer {
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]init];
    [tap addTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:tap];
}

- (void) handleTap:(UITapGestureRecognizer *)tap {
    
    [self becomeFirstResponder];
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setTargetRect:self.frame inView:self.superview];
    [menu setMenuVisible:YES animated:YES];
}

#pragma mark Clipboard

- (void) copy:(id) sender {
    [UIPasteboard generalPasteboard].string = self.text;
}

- (BOOL) canPerformAction:(SEL)action withSender:(id)sender {
    return (action == @selector(copy:));
}

- (BOOL) canBecomeFirstResponder
{
    return YES;
}

@end
