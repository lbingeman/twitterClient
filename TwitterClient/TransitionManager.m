//
//  TransitionManager.m
//  TwitterClient
//
//  Created by Laura Bingeman on 2017-01-31.
//  Copyright © 2017 Laura Bingeman. All rights reserved.
//

#import "TransitionManager.h"
#import "ViewControllerManager.h"

#import "User.h"
#import "Tweet.h"

@interface TransitionManager ()

@end

@implementation TransitionManager


+ (void)transitionToLoginFrom:(UIViewController*)fromViewController{
    [fromViewController presentViewController:[ViewControllerManager getLoginViewController] animated:YES completion:nil];
}

+ (void)transitionToTweetFeedListFrom:(UIViewController*)fromViewController{
    [fromViewController presentViewController:[ViewControllerManager getMainViewController] animated:NO completion:nil];
}

+ (void)transitionToNewTweet:(UIViewController*)fromViewController{
    [fromViewController.navigationController presentViewController:[ViewControllerManager getTweetComposeView] animated:YES completion:nil];
}

+ (void)transitionToDetailViewFrom:(UIViewController*)fromViewController tweet:(Tweet*)tweet delegate:(id<DetailTweetDelegate>)delegate {
    [fromViewController.navigationController pushViewController:[ViewControllerManager getDetailViewControllerForTweet:tweet delegate:delegate] animated:YES];
}

+ (void)transitionToProfilePageForUser:(User*)user viewController:(UIViewController*)fromViewController {
    [fromViewController.navigationController pushViewController:[ViewControllerManager getProfileViewControllerWithUser:user] animated:YES];
}

+ (void)replyToTweet:(Tweet*)tweet viewController:(UIViewController*)fromViewController{
    [fromViewController.navigationController presentViewController:[ViewControllerManager getReplyViewControllerWithTweet:tweet] animated:YES completion:nil];
}


@end
