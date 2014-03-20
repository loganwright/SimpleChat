//
//  TopBar.m
//  LowriDevs
//
//  Created by Logan Wright on 11/18/13.
//  Copyright (c) 2013 Logan Wright. All rights reserved.
//


/*
 Mozilla Public License
 Version 2.0
 */


#import "TopBar.h"
#import "MyMacros.h"

@interface TopBar ()

@property (strong, nonatomic) CAGradientLayer * shadowLine;
@property (strong, nonatomic) UIToolbar * bgToolbar;

@end

@implementation TopBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (CGRectEqualToRect(frame, CGRectZero)) {
            if (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
                self.frame = CGRectMake(0, 0, ScreenWidth(), 60);
            }
            else {
                self.frame = CGRectMake(0, 0, ScreenHeight(), 60);
            }
        }
        
        self.clipsToBounds = NO;
        self.layer.masksToBounds = NO;
        self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        
        // Default Blue
        _tintColor = [UIColor colorWithRed:0.142954 green:0.60323 blue:0.862548 alpha:1];
        
        _bgToolbar = [[UIToolbar alloc]init];
        _bgToolbar.frame = self.bounds;
        _bgToolbar.autoresizingMask= UIViewAutoresizingFlexibleWidth;
        [self addSubview:_bgToolbar];
        
        _leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _leftBtn.frame = CGRectMake(4, 20, 40, 40);
        [_leftBtn setTintColor:_tintColor];
        [_leftBtn addTarget:self action:@selector(topLeftBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        _leftBtn.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        _leftBtn.imageEdgeInsets = UIEdgeInsetsMake(7, 7, 7, 7);
        [_leftBtn setImage:[UIImage imageNamed:@"Previous.png"] forState:UIControlStateNormal];
        [self addSubview:_leftBtn];
        
        _rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _rightBtn.frame = CGRectMake(width(self) - 4, 20, -40, 40);
        [_rightBtn setTintColor:_tintColor];
        [_rightBtn addTarget:self action:@selector(topRightBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        _rightBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [self addSubview:_rightBtn];
        
        _middleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _middleBtn.bounds = CGRectMake(0, 0, 180, 30);
        _middleBtn.center = CGPointMake(self.center.x, self.center.y + 10); // 10 for system bar (20px)
        [_middleBtn setTitleColor:_tintColor forState:UIControlStateNormal];
        [_middleBtn.titleLabel setFont:[UIFont systemFontOfSize:18.0]];
        _middleBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        _middleBtn.titleLabel.minimumScaleFactor = 0.5;
        [_middleBtn addTarget:self action:@selector(topMiddleBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        _middleBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:_middleBtn];
        
        _shadowLine = [CAGradientLayer layer];
        _shadowLine.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, -0.5);
        _shadowLine.colors = [NSArray arrayWithObjects:(id)[[UIColor lightGrayColor] CGColor], (id)[[UIColor clearColor] CGColor], nil];
        _shadowLine.opacity = .6;
        [self.layer addSublayer:_shadowLine];
    }
    return self;
}

- (void) removeFromSuperview {
    
    [_shadowLine removeFromSuperlayer];
    _shadowLine = nil;
    
    [_leftBtn removeFromSuperview];
    _leftBtn = nil;
    
    [super removeFromSuperview];
}

- (void) layoutSubviews {
    _shadowLine.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, -0.5);
}

#pragma mark BUTTON PRESSES

- (void)topLeftBtnPressed:(id)sender {
    [_delegate topLeftPressed];
}

- (void)topRightBtnPressed:(id)sender {
    [_delegate topRightPressed];
}

- (void)topMiddleBtnPressed:(id)sender {
    [_delegate topMiddlePressed];
}

#pragma mark GETTERS | SETTERS

- (void) setTitle:(NSString *)title {
    if (_middleBtn) [_middleBtn setTitle:title forState:UIControlStateNormal];
    _title = title;
}

- (void) setTintColor:(UIColor *)tintColor {
    [_leftBtn setTintColor:tintColor];
    [_rightBtn setTintColor:tintColor];
    [_middleBtn setTitleColor:tintColor forState:UIControlStateNormal];
    
    _tintColor = tintColor;
}

@end
