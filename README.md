SimpleChat
==========

An easy to use bubble chat UI as an alternative to the traditional iOS talk bubbles.

<p align="center">
  <img src="http://i.stack.imgur.com/OrRIO.png?raw=true"><img />
</p>


###QuickStart

####1. Add `LGSimpleChat.swift` To Xcode

- Drag `LGSimpleChat.swift` into your Xcode project
- Make sure "Copy items into destination group's folder (if needed)" is selected

####Step 2: Your ViewController.h file

#####ObjC

- Import `<#YourProductModule#>-Swift.h`
- Conform to `LGChatControllerDelegate`

In `<#YourViewController#>.m`

```ObjC
#import "<#YourViewController#>.h"
#import "<#YourProductModule#>-Swift.h"

@interface <#YourViewController#> () <LGChatControllerDelegate>

@end

@implementation

#pragma mark - Launch Chat Controller

- (void)launchChatController
{
    LGChatController *chatController = [LGChatController new];
    chatController.opponentImage = [UIImage imageNamed:@"<#YourImageName#>"];
    chatController.title = @"<#YourTitle#>";
    chatController.messages = @[]; // Pass your messages here.
    chatController.delegate = self;
    [self.navigationController pushViewController:chatController animated:YES];
}

#pragma mark - LGChatControllerDelegate

- (void)chatController:(LGChatController *)chatController didAddNewMessage:(LGChatMessage *)message
{
    NSLog(@"Did Add Message: %@", message.content);
}

- (BOOL)shouldChatController:(LGChatController *)chatController addMessage:(LGChatMessage *)message
{
    /*
    Use this space to prevent sending a message, or to alter a message.  For example, you might want to hold a message until its successfully uploaded to a server.
    */
    return YES;
}

@end

```

### Initializing a Message

```ObjC
LGChatMessage *helloWorld = [[LGChatMessage alloc] initWithContent:@"Hello World" sentByString:LGChatMessage.SentByUserString];

or

LGChatMessage *helloWorld = [[LGChatMessage alloc] initWithContent:@"Hello World" sentByString:LGChatMessage.SentByUserString timeStamp: someTimestamp];
```

### Stylization Options

#### Styling the Chat Input

```ObjC
- (void)styleChatInput
{
    [LGChatInput setAppearanceBackgroundColor:<#UIColor#>];
    [LGChatInput setAppearanceIncludeBlur:<#Bool#>];
    [LGChatInput setAppearanceTextViewFont:<#UIFont#>];
    [LGChatInput setAppearanceTextViewTextColor:<#UIColor#>];
    [LGChatInput setAppearanceTintColor:<#UIColor#>];
    [LGChatInput setAppearanceTextViewBackgroundColor:<#UIColor#>];
}
```

#### Styling the Message Cell (more coming)

```ObjC
- (void)styleMessageCell
{
    [LGChatMessageCell setAppearanceFont:<#UIFont#>];
    [LGChatMessageCell setAppearanceOpponentColor:[<#UIColor#>];
    [LGChatMessageCell setAppearanceUserColor:<#UIColor#>];
}
```

<!--

***** COMING SOON *****

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

-->
