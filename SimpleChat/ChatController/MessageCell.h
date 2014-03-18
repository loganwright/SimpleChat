//
//  MessageCell.h
//  LowriDev
//
//  Created by Logan Wright on 3/17/14
//  Copyright (c) 2014 Logan Wright. All rights reserved.
//


#import <UIKit/UIKit.h>

/*!
 Who sent the message
 */
typedef enum {
    kSentByUser,
    kSentByOpponent,
} SentBy;

// Used for shared drawing btwn self & chatController
FOUNDATION_EXPORT int const outlineSpace;
FOUNDATION_EXPORT int const maxBubbleWidth;

// Message Dictionary Keys
FOUNDATION_EXPORT NSString * const kMessageSize;
FOUNDATION_EXPORT NSString * const kMessageContent;
FOUNDATION_EXPORT NSString * const kMessageRuntimeSentBy;

@interface MessageCell : UICollectionViewCell

/*
 Message Property
 */
@property (strong, nonatomic) NSDictionary * message;

/*!
 Opponent bubble color
 */
@property (strong, nonatomic) UIColor * opponentColor;
/*!
 User bubble color
 */
@property (strong, nonatomic) UIColor * userColor;

/*!
 Opponent image -- nil for blank
 */
@property (strong, nonatomic) UIImage * opponentImage;

@end
