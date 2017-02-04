//
//  TransitionManager.h
//  TwitterClient
//
//  Created by Laura Bingeman on 2017-01-31.
//  Copyright © 2017 Laura Bingeman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Tweet.h"
#import "DetailTweetViewController.h"

@interface TransitionManager : NSObject

+ (void)transitionToLoginFrom:(UIViewController*)fromViewController;

+ (void)transitionToTweetFeedListFrom:(UIViewController*)fromViewController;

+ (void)transitionToDetailViewFrom:(UIViewController*)fromViewController tweet:(Tweet*)tweet delegate:(id<DetailTweetDelegate>)delegate;

+ (void)transitionToNewTweet:(UIViewController*)fromViewController;
+ (void)replyToTweet:(Tweet*)tweet viewController:(UIViewController*)fromViewController;

+ (void)transitionToProfilePageForUser:(User*)user viewController:(UIViewController*)fromViewController;

extern const struct ViewTypeStructs ViewTypes;

@end
