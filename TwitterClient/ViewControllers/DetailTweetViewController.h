//
//  DetailTweetViewController.h
//  TwitterClient
//
//  Created by Laura Bingeman on 2017-01-31.
//  Copyright © 2017 Laura Bingeman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
#import "MainViewController.h"

@protocol DetailTweetDelegate <NSObject>
- (void) updateTweetWithTweet:(Tweet*)tweet;
@end

@interface DetailTweetViewController : MainViewController
@property id<DetailTweetDelegate> delegate;
@property (nonatomic,weak) Tweet *tweet;
- (void) updateTweetWithTweet:(Tweet*)tweet;
@end
