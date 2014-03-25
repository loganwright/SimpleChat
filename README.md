SimpleChat
==========

An Easy To Use Bubble Chat UI Alternative

<p align="center">
  <img src="http://i.stack.imgur.com/OrRIO.png?raw=true"><img />
</p>


###QuickStart

####Step 1: Add Delegate Protocol

ViewController.h

```ObjC
import <UIKit/UIKit.h>

#import "ChatController.h"

@interface ViewController : UIViewController <ChatControllerDelegate>

@property (strong, nonatomic) ChatController * chatController;

@end
```

####Step 2: Add Delegate Method & Convenience Sender

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

####Step 3: Launch

```ObjC
if (!_chatController) _chatController = [ChatController new];
_chatController.delegate = self;

// If you'd like to open with existing messages, you could do this:

// _chatController.messages = someArrayOfMessages;

/*

Messages are dictionaries.  The text to display should be stored with the key `kMessageContent'

*/


[self presentViewController:_chatController animated:YES completion:nil];
```    
    
    
To open with an array of already retrieved or cached messages:

```ObjC
if (!_chatController) _chatController = [ChatController new];
_chatController.delegate = self;

// add this
_chatController.messages = // some array of MessageOb Objects

[self presentViewController:_chatController animated:YES completion:nil];
```

####Step 4: Customize SentBy Logic

- In ChatController.m, find this section:

if (!message[kMessageRuntimeSentBy]) {
        
    // Random just for now, set at runtime
    int sentByNumb = arc4random() % 2;
    message[kMessageRuntimeSentBy] = [NSNumber numberWithInt:(sentByNumb == 0) ? kSentByOpponent : kSentByUser];

}

It is currently set to random, just so you can see how the conversation would look hypothetically. You should replace this with your own custom logic, for instance, you could create a currentUserId property and add a sentBy key to your message dictionaries and do this:

if (!message[kMessageRuntimeSentBy]) {
        
    // See if the sentBy associated with the message matches our currentUserId
    if ([_currentUserId isEqualToString:message[@"sentByUserId"]]) {
        message[kMessageRuntimeSentBy = [NSNumber numberWithInt:kSentByUser];
    }
    else {
        message[kMessageRuntimeSentBy = [NSNumber numberWithInt:kSentByOpponent];
    }

}


