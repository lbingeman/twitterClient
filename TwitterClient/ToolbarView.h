//
//  ToolbarView.h
//  TwitterClient
//
//  Created by Laura Bingeman on 2017-02-02.
//  Copyright © 2017 Laura Bingeman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@protocol ToolbarDelegate <NSObject>

- (void)favouriteButtonPressed;
- (void)replyButtonPressed;
- (void)retweetButtonPressed;

@end

@interface ToolbarView : UIView
@property id<ToolbarDelegate> delegate;
- (void)configureBarWithTweet:(Tweet*)tweet;
@end
