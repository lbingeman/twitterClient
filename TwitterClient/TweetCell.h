//
//  TweetCell.h
//  TwitterClient
//
//  Created by Laura Bingeman on 2017-01-30.
//  Copyright © 2017 Laura Bingeman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
#import "ToolbarView.h"

@protocol TweetCellDelegate <NSObject>

- (void)favouriteCountUpdate:(int)incrementAmount cell:(UITableViewCell*)cell;
- (void)retweetCountUpdate:(int)incrementAmount cell:(UITableViewCell*)cell;
- (void)replyToTweet:(UITableViewCell*)cell;
- (void)imageTapped:(UITableViewCell*)cell;

@end

@interface TweetCell : UITableViewCell
@property id <TweetCellDelegate> delegate;
- (void)loadWithTweet:(Tweet*)tweet;
@end
