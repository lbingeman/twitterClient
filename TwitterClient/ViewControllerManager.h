//
//  ViewControllerManager.h
//  TwitterClient
//
//  Created by Laura Bingeman on 2017-02-01.
//  Copyright © 2017 Laura Bingeman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DetailTweetViewController.h"
#import "TweetComposeViewController.h"
#import "Tweet.h"

@interface ViewControllerManager : NSObject
struct ViewTypeStructs {
    __unsafe_unretained NSString* const Login;
    __unsafe_unretained NSString* const TweetFeedList;
    __unsafe_unretained NSString* const DetailView;
    __unsafe_unretained NSString* const ProfileView;
    __unsafe_unretained NSString* const TweetComposeView;
};
+ (UIViewController*)getMainViewController;
+ (UIViewController*)getLoginViewController;
+ (UIViewController*)getDetailViewControllerForTweet:(Tweet*)tweet delegate:(id<DetailTweetDelegate>)delegate;
+ (TweetComposeViewController*)getTweetComposeView;
+ (UIViewController*)getReplyViewControllerWithTweet:(Tweet*)tweet;
+ (UIViewController*)getListViewControllerWithUserID:(NSString*)userID;
+ (UIViewController*)getProfileViewControllerWithUser:(User*)user;
@end
