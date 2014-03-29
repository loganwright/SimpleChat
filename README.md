SimpleChat
==========

An Easy To Use Bubble Chat UI Alternative

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

####Step 3: Add Delegate Method & Convenience Sender

Whenever the user sends a message from inside of the ChatController, it will pass a string to the delegate.
If you'd like to show this on the UI, you'll need to pass it back into the controller, like below.

```ObjC

// Will be called when user presses send
- (void) chatController:(ChatController *)chatController didSendMessage:(NSString *)messageString {
    NSLog(@"Send message:%@", messageString);
    
    // We must add the message to the chat if we want to see it
    [self addNewMessageToChat:messageString];
}

// Just a convenience method to add messageString to messageObject
// This looks pointless now because all we see is a string; however, you will likely want to pass additional parameters along with the message (ie: timestamp, sentBy, sentFrom, etc...)
- (void) addNewMessageToChat:(NSString *)messageString {

    // Received String -- > Convert to message to send ...
    NSMutableDictionary * newMessageOb = [NSMutableDictionary new];
    newMessageOb[kMessageContent] = messageString;
    
    // Add Message Right To Collection
    [_chatController addNewMessage:newMessageOb];
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
 Change Overall Tint (send btn, top bar, and opponent bubbles) - Use this for a quick theme change
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
```ObjC
You can run these if you'd like to notify the user that their connection to the server is inactive.  Call isOffline to show the notification, call isOnline to hide it.  It is safe to call these repeatedly.

/*!
 Notify UI that user is: Offline
 */
- (void) isOffline;
/*!
 Notify UI that user is: Online
 */
- (void) isOnline;
```

