//
//  ViewControllerManager.m
//  TwitterClient
//
//  Created by Laura Bingeman on 2017-02-01.
//  Copyright © 2017 Laura Bingeman. All rights reserved.
//

#import "ViewControllerManager.h"

#import "LoginViewController.h"
#import "TweetListViewController.h"
#import "DetailTweetViewController.h"
#import "ProfileViewController.h"
#import "TweetComposeViewController.h"

@implementation ViewControllerManager

const struct ViewTypeStructs ViewTypes = {
    .Login = @"LoginViewController",
    .TweetFeedList = @"TweetListViewController",
    .DetailView = @"DetailTweetViewController",
    .ProfileView = @"ProfileViewController",
    .TweetComposeView = @"TweetComposeViewController"
};


+ (UIViewController*)getMainViewController {
    UIViewController *viewControllerTweetListView = [self getTweetTimelineViewController];
    
    UIViewController *viewControllerProfileView = [self getCurrentUserProfileViewController];
    
    UIViewController *viewControllerMentionView = [self getTweetMentionsViewController];
    
    UITabBarController *tabBarController = [UITabBarController new];
    tabBarController.viewControllers = @[viewControllerTweetListView,viewControllerProfileView,viewControllerMentionView];
    [tabBarController.tabBar setTranslucent:NO];
    
    return tabBarController;
}

+ (UINavigationController*)embedNavigationControllerInViewController:(UIViewController*)viewController {
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [navController.navigationBar setTranslucent:NO];
    return navController;
}

+ (UIViewController*)getLoginViewController {
    LoginViewController *toViewController = [[LoginViewController alloc] initWithNibName:ViewTypes.Login bundle:nil];
    return toViewController;
}

+ (UIViewController*)getProfileViewController {
    UIViewController *viewController = [self embedNavigationControllerInViewController:[[ProfileViewController alloc] initWithUser:[User currentUser] nib:ViewTypes.ProfileView                                                                                                                             bundle:nil]];
    return viewController;
}

+ (UIViewController*)getListViewControllerWithUserID:(NSString*)userID {
    TweetListViewController *viewController = [[TweetListViewController alloc] initWithNibName:ViewTypes.TweetFeedList bundle:nil];
    [viewController configureTweetListViewControllerAsUserProfileWithUser:userID];
    return viewController;
}

+ (UIViewController*)getProfileViewControllerWithUser:(User*)user {
    return [[ProfileViewController alloc] initWithUser:user nib:ViewTypes.ProfileView bundle:nil];
}

+ (UIViewController*)getCurrentUserProfileViewController {
    UIViewController *viewController = [self embedNavigationControllerInViewController:[[ProfileViewController alloc] initWithUser:[User currentUser] nib:ViewTypes.ProfileView                                                                                                                             bundle:nil]];
    
    viewController.tabBarItem.title = @"Profile";
    viewController.tabBarItem.image = [UIImage imageNamed:@"iconmonstr-twitter-1-32.png"];
    //viewController.tabBarItem.tag = 1;
    
    return viewController;
}

+ (UIViewController*)getTweetTimelineViewController {
    
    UINavigationController *tweetViewController = [self initTweetControllerWithTabBarImage:@"sample-504-doghouse.png" title:@"Home"];
    
    if([tweetViewController.viewControllers[0] isKindOfClass:TweetListViewController.class]){
        TweetListViewController *viewController = tweetViewController.viewControllers[0];
        [viewController configureTweetListViewControllerAsTimeline];
    }
    
    return tweetViewController;
}

+ (UIViewController*)getTweetMentionsViewController {
    
    UINavigationController *mentionsViewController = [self initTweetControllerWithTabBarImage:@"iconmonstr-twitter-1-32.png" title:@"Mentions"];
    
    if([mentionsViewController.viewControllers[0] isKindOfClass:TweetListViewController.class]){
        TweetListViewController *viewController = mentionsViewController.viewControllers[0];
        [viewController configureTweetListViewControllerAsMentions];
    }
    
    return mentionsViewController;
}

+ (UINavigationController*)initTweetControllerWithTabBarImage:(NSString*)imageName title:(NSString*)title {
    
    TweetListViewController *tweetViewController = [[TweetListViewController alloc] initWithNibName:ViewTypes.TweetFeedList bundle:nil];
    
    UINavigationController *navController = [self embedNavigationControllerInViewController:tweetViewController];
    
    navController.tabBarItem.title = title;
    navController.tabBarItem.image = [UIImage imageNamed:imageName];
    
    return navController;
}

+ (TweetComposeViewController*)getTweetComposeView {
    return [[TweetComposeViewController alloc] initWithNibName:ViewTypes.TweetComposeView bundle:nil];
}

+ (UIViewController*)getReplyViewControllerWithTweet:(Tweet*)tweet {
    TweetComposeViewController *composeView = [self getTweetComposeView];
    [composeView replyToTweet:tweet];
    
    return composeView;
}

+ (UIViewController*)getDetailViewControllerForTweet:(Tweet*)tweet delegate:(id<DetailTweetDelegate>)delegate {
    DetailTweetViewController *toViewController = [[DetailTweetViewController alloc] initWithNibName:ViewTypes.DetailView bundle:nil];
    toViewController.delegate = delegate;
    [toViewController updateTweetWithTweet:tweet];
    return toViewController;
}

@end
