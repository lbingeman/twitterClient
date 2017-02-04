//
//  AppDelegate.m
//  TwitterClient
//
//  Created by Laura Bingeman on 2017-01-30.
//  Copyright © 2017 Laura Bingeman. All rights reserved.
//

#import "AppDelegate.h"
#import "TweetListViewController.h"
#import "LoginViewController.h"
#import "ProfileViewController.h"
#import "TwitterClient.h"
#import "User.h"
#import "Tweet.h"
#import "TransitionManager.h"
#import "ViewControllerManager.h"

static NSString* loginViewControllerNibName = @"LoginViewController";
static NSString* tweetListViewControllerNibName = @"TweetListViewController";
static NSString* profileViewControllerNibName = @"ProfileViewController";

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    CGRect frame = [UIScreen mainScreen].bounds;
    self.window = [[UIWindow alloc] initWithFrame:frame];
    self.window.rootViewController = [self getRootViewController];
    [self.window makeKeyAndVisible];
    
    //go to log in screen whenever logout occurs
    [[NSNotificationCenter defaultCenter] addObserverForName:userDidLogOutNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        self.window.rootViewController = [self getRootViewController];
        [self.window makeKeyAndVisible];
    }];
    
    return YES;
}

- (UIViewController*)getRootViewController {
    if([self currentUserDoesExist]){
        //return [self getMainViewController];
        return [ViewControllerManager getMainViewController];
    } else{
        return [self getLoginViewControllerViewController];
    }
}

- (UIViewController*)embedNavigationControllerInViewController:(UIViewController*)viewController {
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [navController.navigationBar setTranslucent:NO];
    return navController;
}

- (UINavigationController*)getLoginViewControllerViewController{
    LoginViewController *viewController = [[LoginViewController alloc] initWithNibName:loginViewControllerNibName bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    return navController;
}

- (BOOL)currentUserDoesExist {
    User *currentUser = [User currentUser];
    if (currentUser != nil){
        return YES;
    } else{
        return NO;
    }
    return NO;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    [[TwitterClient sharedInstance] openURL:url];
    
    return YES;
}
@end
