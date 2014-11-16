SimpleChat
==========

#Welcome To SimpleChat 2.0!

##New Features

1. Completely redesigned implementation in Swift
2. Supports iOS 7.1+
3. New Screen Size Support

#SimpleChat

An easy to use bubble chat UI as an alternative to the traditional iOS talk bubbles.

<p align="center">
  <!-- <img src="http://i.stack.imgur.com/OrRIO.png?raw=true"><img /> -->
</p>


###Getting Started

####1. Add The `LGSimpleChat` Folder To Xcode

- Drag the folder into your Xcode project
- Make sure "Copy items into destination group's folder (if needed)" is selected

####2. ObjC

- Import `<#YourProductModule#>-Swift.h`
- Conform to `LGChatControllerDelegate`
- Call `[self launchChatController]` (specified below)

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
    LGChatMessage *helloWorld = [[LGChatMessage alloc] initWithContent:@"Hello World" sentByString:[LGChatMessage SentByUserString]];
    chatController.messages = @[helloWorld]; // Pass your messages here.
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
LGChatMessage *helloWorld = [[LGChatMessage alloc] initWithContent:@"Hello World" sentByString:[LGChatMessage SentByUserString]];

or

LGChatMessage *helloWorld = [[LGChatMessage alloc] initWithContent:@"Hello World" sentByString:[LGChatMessage SentByOpponentString] timeStamp: someTimestamp];
```

### Stylization Options

#### Chat Input

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

#### Message Cell

```ObjC
- (void)styleMessageCell
{
    [LGChatMessageCell setAppearanceFont:<#UIFont#>];
    [LGChatMessageCell setAppearanceOpponentColor:[<#UIColor#>];
    [LGChatMessageCell setAppearanceUserColor:<#UIColor#>];
}
```

####2. Swift

- Import `<#YourProductModule#>-Swift.h`
- Conform to `LGChatControllerDelegate`
- Call `[self launchChatController]` (specified below)

In `<#YourViewController#>.swift`

```Swift

import UIKit

class SwiftExampleViewController: UIViewController, LGChatControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: Launch Chat Controller

    func launchChatController() {
        let chatController = LGChatController()
        chatController.opponentImage = UIImage(named: "User")
        chatController.title = "Simple Chat"
        let helloWorld = LGChatMessage(content: "Hello World!", sentBy: .User)
        chatController.messages = [helloWorld]
        chatController.delegate = self
        self.navigationController?.pushViewController(chatController, animated: true)
    }

    // MARK: LGChatControllerDelegate

    func chatController(chatController: LGChatController, didAddNewMessage message: LGChatMessage) {
        println("Did Add Message: \(message.content)")
    }

    func shouldChatController(chatController: LGChatController, addMessage message: LGChatMessage) -> Bool {
        /*
        Use this space to prevent sending a message, or to alter a message.  For example, you might want to hold a message until its successfully uploaded to a server.
        */
        return true
    }

}

```

### Initializing a Message

```ObjC
let message = LGChatMessage(content: "Hello World!", sentBy: .User)

-- or --

let message = LGChatMessage(content: "Hello World!", sentBy: .Opponent, timeStamp: someTimestamp)
```

### Stylization Options

#### Chat Input

```Swift
func stylizeChatInput() {
    LGChatInput.Appearance.backgroundColor = <#UIColor#>
    LGChatInput.Appearance.includeBlur = <#Bool#>
    LGChatInput.Appearance.textViewFont = <#UIFont#>
    LGChatInput.Appearance.textViewTextColor = <#UIColor#>
    LGChatInput.Appearance.tintColor = <#UIColor#>
    LGChatInput.Appearance.textViewBackgroundColor = <#UIColor#>
}
```

#### Message Cell

```ObjC
func stylizeMessageCell() {
    LGChatMessageCell.Appearance.font = <#UIFont#>
    LGChatMessageCell.Appearance.opponentColor = <#UIColor#>
    LGChatMessageCell.Appearance.userColor = <#UIColor#>
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
