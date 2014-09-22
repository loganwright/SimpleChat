//
//  ViewController.m
//  SimpleChat
//
//  Created by Logan Wright on 3/17/14.
//  Copyright (c) 2014 Logan Wright. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UILabel * tapLabel = [UILabel new];
    tapLabel.bounds = CGRectMake(0, 0, 200, 100);
    tapLabel.text = @"** TAP TO OPEN **";
    tapLabel.textAlignment = NSTextAlignmentCenter;
    tapLabel.center = self.view.center;
    tapLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
    [self.view addSubview:tapLabel];

    UITapGestureRecognizer * tap = [UITapGestureRecognizer new];
    [tap addTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tap];
    
    self.navigationController.navigationBar.translucent = NO;
}

- (void) handleTap:(UITapGestureRecognizer *)tap {
    
    if (!_chatController) _chatController = [ChatController new];
    _chatController.delegate = self;
    _chatController.opponentImg = [UIImage imageNamed:@"tempUser.png"];
    // Modal
    // [self presentViewController:_chatController animated:YES completion:nil];
    
    // Push
    _chatController.isNavigationControllerVersion = YES;
    [self.navigationController pushViewController:_chatController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark CHAT CONTROLLER DELEGATE

- (void) chatController:(ChatController *)chatController didSendMessage:(NSMutableDictionary *)message {
    // Messages come prepackaged with the contents of the message and a timestamp in milliseconds
    NSLog(@"Message Contents: %@", message[kMessageContent]);
    NSLog(@"Timestamp: %@", message[kMessageTimestamp]);
    
    // Evaluate or add to the message here for example, if we wanted to assign the current userId:
    message[@"sentByUserId"] = @"currentUserId";
    
    // Must add message to controller for it to show
    [_chatController addNewMessage:message];
}



/* Optional
- (void) closeChatController {
    [chatController dismissViewControllerAnimated:YES completion:^{
        [chatController removeFromParentViewController];
        chatController = nil;
    }];
}
*/

@end
