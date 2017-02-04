//
//  TweetComposeViewController.h
//  TwitterClient
//
//  Created by Laura Bingeman on 2017-02-01.
//  Copyright © 2017 Laura Bingeman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface TweetComposeViewController : UIViewController
- (void)replyToTweet:(Tweet*)tweet;
@end
