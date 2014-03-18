//
//  ViewController.m
//  SimpleChat
//
//  Created by Logan Wright on 3/17/14.
//  Copyright (c) 2014 Logan Wright. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    ChatController * chatController;
}

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
}

- (void) handleTap:(UITapGestureRecognizer *)tap {
    
    if (!chatController) chatController = [ChatController new];
    chatController.delegate = self;
    chatController.chatTitle = @"Simple Chat";
    chatController.opponentImg = [UIImage imageNamed:@"tempUser.png"];
    [self presentViewController:chatController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark CHAT CONTROLLER DELEGATE

- (void) sendNewMessage:(NSString *)messageString {
    
    // Received String -- > Convert to message to send ...
    NSMutableDictionary * newMessageOb = [NSMutableDictionary new];
    newMessageOb[kMessageContent] = messageString;
    
    // Add Message Right To Collection
    [chatController addNewMessage:newMessageOb];
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
