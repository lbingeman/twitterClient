//
//  ToolbarView.m
//  TwitterClient
//
//  Created by Laura Bingeman on 2017-02-02.
//  Copyright © 2017 Laura Bingeman. All rights reserved.
//

#import "ToolbarView.h"

@interface ToolbarView ()
@property (weak, nonatomic) IBOutlet UIButton *favouriteButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;

@property (nonatomic) Boolean favourited;
@property (nonatomic) Boolean retweeted;

@end

@implementation ToolbarView
- (IBAction)replyButtonPressed:(UIButton *)sender {
    [self.delegate replyButtonPressed];
}
- (IBAction)retweetButtonPressed:(UIButton *)sender {
    self.retweeted = !self.retweeted;
    [self configureRetweet];
    [self.delegate retweetButtonPressed];
}
- (IBAction)favouriteButtonPressed:(UIButton *)sender{
    self.favourited = !self.favourited;
    [self configureFavourite];
    [self.delegate favouriteButtonPressed];
}

- (void)configureBarWithTweet:(Tweet *)tweet {
    self.favourited = tweet.favourited;
    [self configureFavourite];
    
    self.retweeted = tweet.retweet;
    [self configureRetweet];
}

- (void)configureFavourite{
    NSString *buttonImage = self.favourited ? @"favor-icon-red.png" : @"favor-icon.png";
    [self.favouriteButton setImage:[UIImage imageNamed:buttonImage] forState:UIControlStateNormal];
}

- (void)configureRetweet{
    NSString *buttonImage = self.retweeted ? @"retweet-icon-green" : @"retweet-icon";

    [self.retweetButton setImage:[UIImage imageNamed:buttonImage] forState:UIControlStateNormal];
}

@end
