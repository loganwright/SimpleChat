SimpleChat
==========

An easy to use bubble chat UI as an alternative to the traditional iOS talk bubbles.

<p align="center">
  <img src="http://i.stack.imgur.com/OrRIO.png?raw=true"><img />
</p>


###QuickStart

####1. Add "ChatController" Folder to Xcode

- Unzip package
- Drag ChatController Folder into your Xcode project
- Make sure "Copy items into destination group's folder (if needed)" is selected

####Step 2: Your ViewController.h file

- Import ChatController
- Set up as ChatControllerDelegate
- I like to declare a chatController property, this is optional

```ObjC
import <UIKit/UIKit.h>
#import "ChatController.h"

@interface ViewController : UIViewController <ChatControllerDelegate>

@property (strong, nonatomic) ChatController * chatController;

@end
```

####Step 3: Add Delegate Method

Whenever the user sends a message from inside of the ChatController, it will pass the message to the delegate as a dictionary.
If you'd like to show this on the UI, you'll need to pass it back into the controller, like below.  

```ObjC

// Will be called when user presses send
- (void) chatController:(ChatController *)chatController didSendMessage:(NSMutableDictionary *)message {
    // Messages come prepackaged with the contents of the message and a timestamp in milliseconds
    NSLog(@"Message Contents: %@", message[kMessageContent]);
    NSLog(@"Timestamp: %@", message[kMessageTimestamp]);
    
    // Evaluate or add to the message here for example, if we wanted to assign the current userId:
    message[@"sentByUserId"] = @"currentUserId";
    
    // Must add message to controller for it to show
    [_chatController addNewMessage:message];
}

```

This gives you the opportunity to do things like validate the message, assign a sent by, sent to, set a timestamp, or whatever operation I'd like to do before adding it to the view.  For instance, I could attempt to send the message and not display it to the user until it has successfully sent.

####Step 4: Launch

```ObjC
if (!_chatController) _chatController = [ChatController new];
_chatController.delegate = self;

// Insert Customization Options Here!! (see below)

// If you'd like to open with an already retrieved array of messages, add this:
// _chatController.messages = // some array of MessageOb Objects
/*
  Note that messages must be NSDictionaries, and at minimum, the text to display should be stored with the key `kMessageContent' 
  
  You can also store custom data here to pass into the controllerIf you'd like.  Particularly useful for figuring out who sent the message (see below)
*/

[self presentViewController:_chatController animated:YES completion:nil];
```    


####Step 5: Customize SentBy Logic

- In ChatController.m, find this section:
```ObjC
if (!message[kMessageRuntimeSentBy]) {
        
    // Random just for now, set at runtime
    int sentByNumb = arc4random() % 2;
    message[kMessageRuntimeSentBy] = [NSNumber numberWithInt:(sentByNumb == 0) ? kSentByOpponent : kSentByUser];

}
```
It is currently set to random, just so you can see how the conversation would look hypothetically. You should replace this with your own custom logic, for instance, you could create a currentUserId property and add a sentBy key to your message dictionaries and do this:
```ObjC
if (!message[kMessageRuntimeSentBy]) {
        
    // See if the sentBy associated with the message matches our currentUserId
    if ([_currentUserId isEqualToString:message[@"sentByUserId"]]) {
        message[kMessageRuntimeSentBy] = [NSNumber numberWithInt:kSentByUser];
    }
    else {
        message[kMessageRuntimeSentBy] = [NSNumber numberWithInt:kSentByOpponent];
    }

}
```


### Customization Options

```ObjC
/*!
 The color of the user's chat bubbles
 */
@property (strong, nonatomic) UIColor * userBubbleColor;
/*!
 The color of the opponent's chat bubbles
 */
@property (strong, nonatomic) UIColor * opponentBubbleColor;
/*!
 Change Overall Tint (send btn active and top bar text/icons) 
 */
@property (strong, nonatomic) UIColor * tintColor;

/*!
 The img to use for the opponent - Can be nil
 */
@property (strong, nonatomic) UIImage * opponentImg;
/*!
 To set the title
 */
@property (strong, nonatomic) NSString * chatTitle;
```
###Status Notifications

You can run these if you'd like to notify the user that their connection to the server is inactive.  Call isOffline to show the notification, call isOnline to hide it.  It is safe to call these repeatedly.
```ObjC
/*!
 Notify UI that user is: Offline
 */
- (void) isOffline;
/*!
 Notify UI that user is: Online
 */
- (void) isOnline;
```


<h3> CHANGELOG </h3>

v1.0.1 - 1 April 2014

- Fixed Japanese / Chinese Keyboard Issue
- Changed tintColor property to be more intuitive
- Changed new message delegate to package messages as dictionaries

