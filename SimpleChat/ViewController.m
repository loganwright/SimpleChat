//
//  ViewController.m
//  SimpleChat
//
//  Created by Logan Wright on 3/17/14.
//  Copyright (c) 2014 Logan Wright. All rights reserved.
//

#import "ViewController.h"
#import "SimpleChat-Swift.h"

@interface ViewController () <LGChatControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

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

- (void)handleTap:(UITapGestureRecognizer *)tap
{
    [self launchChatController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Styling

//- (void)styleChatInput
//{
//    [LGChatInput setAppearanceBackgroundColor:<#UIColor#>];
//    [LGChatInput setAppearanceIncludeBlur:<#Bool#>];
//    [LGChatInput setAppearanceTextViewFont:<#UIFont#>];
//    [LGChatInput setAppearanceTextViewTextColor:<#UIColor#>];
//    [LGChatInput setAppearanceTintColor:<#UIColor#>];
//    [LGChatInput setAppearanceTextViewBackgroundColor:<#UIColor#>];
//}

//- (void)styleMessageCell
//{
//    [LGChatMessageCell setAppearanceFont:<#UIFont#>];
//    [LGChatMessageCell setAppearanceOpponentColor:[<#UIColor#>];
//    [LGChatMessageCell setAppearanceUserColor:<#UIColor#>];
//}

#pragma mark - Launch Chat Controller

- (void)launchChatController
{
    LGChatController *chatController = [LGChatController new];
    chatController.opponentImage = [UIImage imageNamed:@"User"];
    chatController.title = @"Simple Chat";
    LGChatMessage *helloWorld = [[LGChatMessage alloc] initWithContent:@"Hello World" sentByString:LGChatMessage.SentByUserString];
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
     This is implemented just for demonstration so the sent by is randomized.  This way, the full functionality can be demonstrated.
     */
    message.sentByString = arc4random_uniform(2) == 0 ? LGChatMessage.SentByOpponentString : LGChatMessage.SentByUserString;
    return YES;
}

@end
