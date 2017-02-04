//
//  TweetListViewController.h
//  TwitterClient
//
//  Created by Laura Bingeman on 2017-01-30.
//  Copyright © 2017 Laura Bingeman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"

enum TweetListTypes {
    Timeline,
    UserTweets,
    Mentions
};
@interface TweetListViewController : MainViewController
- (void)configureTweetListViewControllerAsTimeline;

- (void)configureTweetListViewControllerAsMentions;

- (void)configureTweetListViewControllerAsUserProfileWithUser:(NSString*)userID;
@end
