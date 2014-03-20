//
//  TopBar.h
//  LowriDevs
//
//  Created by Logan Wright on 11/18/13.
//  Copyright (c) 2013 Logan Wright. All rights reserved.
//


/*
 Mozilla Public License
 Version 2.0
 */


#import <UIKit/UIKit.h>

@protocol TopBarDelegate

- (void) topLeftPressed;
- (void) topRightPressed;
- (void) topMiddlePressed;

@end

@interface TopBar : UIView

@property (retain, nonatomic) id <TopBarDelegate> delegate;

@property (strong, nonatomic) NSString * title;
@property (strong, nonatomic) UIButton * leftBtn;
@property (strong, nonatomic) UIButton * rightBtn;
@property (strong, nonatomic) UIButton * middleBtn;
@property (strong, nonatomic) UIColor * tintColor;

@end
