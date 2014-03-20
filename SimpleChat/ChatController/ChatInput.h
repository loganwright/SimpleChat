//
//  ChatInput.h
//  ChatInput
//
//  Created by Logan Wright on 2/6/14.
//  Copyright (c) 2014 Logan Wright. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChatInputDelegate

/*!
 The user has sent a message
 */
@required - (void) chatInputNewMessageSent:(NSString *)messageString;

@end

@interface ChatInput : UIView <UITextViewDelegate>

// -- DELEGATE -- //

/*!
 Delegate
 */
@property (retain, nonatomic) id<ChatInputDelegate>delegate;

// -- CUSTOMIZATION PROPERTIES -- //

/*!
 Set text property to show placeholder
 */
@property (strong, nonatomic) UILabel * placeholderLabel;
/*!
 The color of the send btn - Active State
 */
@property (strong, nonatomic) UIColor * sendBtnActiveColor;
/*!
 The color of the send btn - Inactive State
 */
@property (strong, nonatomic) UIColor * sendBtnInactiveColor;

// -- BEHAVIOR CUSTOMIZATION -- //

/*!
 Set to YES to prevent auto close behavior
 */
@property BOOL stopAutoClose;
/*!
 The maximum point on the Y axis that simpleInput can extend to - default: 60
 */
@property (strong, nonatomic) NSNumber * maxY;
/*!
 Maximum character count allowed
 */
@property (strong, nonatomic) NSNumber * maxCharacters;

// -- CLOSING | OPENING -- //

/*!
 Closes keyboard and resigns first responder
 */
- (void) close;
/*!
 Opens keyboard and makes simple input first responder.
 */
- (void) open;

// -- CALLED DURING ROTATION -- //

/*!
 Should ONLY be called in Parent View Controller's Rotation Callbacks - SEE DOCS
 */
- (void) willRotate;
/*!
 Should ONLY be called in Parent View Controller's Rotation Callbacks - SEE DOCS
 */
- (void) isRotating;
/*!
 Should ONLY be called in Parent View Controller's Rotation Callbacks - SEE DOCS
 */
- (void) didRotate;

// -- CALLED DURING AUTOCORRECT ON SEND BTN PRESS -- //

/*!
 Autocorrect throws keyboard notifications.  This is used to ignore them.
 */
@property BOOL shouldIgnoreKeyboardNotifications;

@end


/////////////////// ******** MUST IMPLEMENT FOR ROTATION ******** ///////////////////

// -- Copy these methods into simpleInput's parent view controller

/* ---------------------------------------------
 
 - (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
 [simpleInput willRotate];
 }
 - (void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
 [  simpleInput isRotating];
 }
 - (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
 [simpleInput didRotate];
 }
 
 --------------------------------------------- */


 
 // ** CUSTOMIZATION ** //
 //
 // -- Customization Options
 // simpleInput.customBackgroundColor = ...; // (UIColor *)
 // simpleInput.inputBorderColor = ...; // (UIColor *)
 // simpleInput.textViewBackgroundColor = ...; // (UIColor *)
 // simpleInput.textViewTextColor = ...; // (UIColor *)
 // simpleInput.placeholderTextColor = ...; // (UIColor *)
 // simpleInput.sendBtnInactiveColor = ...; // (UIColor *)
 // simpleInput.sendBtnActiveColor = ...; // (UIColor *)
 // simpleInput.inputBorderColor = ...; // (UIColor *)
 // simpleInput.customKeyboard = ...; // (UIKeyboardAppearance)
 // simpleInput.placeholderString = ...; // (NSString *)
 //
 // -- light blue theme example -- //
 // simpleInput.customBackgroundColor = [UIColor colorWithRed:0.142954 green:0.60323 blue:0.862548 alpha:1];
 // simpleInput.sendBtnInactiveColor = [UIColor colorWithWhite:1 alpha:.5];
 // simpleInput.sendBtnActiveColor = [UIColor whiteColor];
 // simpleInput.inputBorderColor = [UIColor lightGrayColor];
 // -- end light blue theme example -- //
 //
 // -- soft lounge theme example -- //
 // simpleInput.customBackgroundColor = [UIColor colorWithRed:0.959305 green:0.901052 blue:0.737846 alpha:1];
 // simpleInput.textViewBackgroundColor = [UIColor colorWithRed:109.0/255.0 green:37.0/255.0 blue:38.0/255.0 alpha:.35];
 // simpleInput.textViewTextColor = [UIColor colorWithWhite:1 alpha:.9];//[UIColor colorWithRed:0.959305 green:0.901052 blue:0.737846 alpha:1];
 // simpleInput.placeholderTextColor = [UIColor colorWithWhite:1 alpha:.5];
 // simpleInput.sendBtnInactiveColor = [UIColor colorWithRed:109.0/255.0 green:37.0/255.0 blue:38.0/255.0 alpha:.35];
 // simpleInput.sendBtnActiveColor = [UIColor colorWithRed:109.0/255.0 green:37.0/255.0 blue:38.0/255.0 alpha:1];
 // simpleInput.inputBorderColor = [UIColor lightGrayColor];//[UIColor clearColor];
 // simpleInput.customKeyboard = UIKeyboardAppearanceDark;
 // -- end soft lounge theme example -- //
 //
 // ** ------------------------------------------------------------ ** //
 
 
 //  *** IMPORTANT NOTES *** //
 //
 // -- DO NOT ADJUST SIMPLE INPUT FRAME
 // -- PLACEMENT - MUST BE ON TOP OF VIEW HIERARCHY TO PROPERLY HANDLE AUTOCLOSE
 // -- IN THE DELEGATE METHOD ' simpleInputResizing ' DO NOT INCLUDE ANIMATIONS
 // -- STARTING HEIGHT IS 40px SIMPLE INPUT WILL BE ON BOTTOM OF VIEW
 //
 //  ***      DONE      *** //
