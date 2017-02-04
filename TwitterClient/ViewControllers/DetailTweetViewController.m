//
//  DetailTweetViewController.m
//  TwitterClient
//
//  Created by Laura Bingeman on 2017-01-31.
//  Copyright © 2017 Laura Bingeman. All rights reserved.
//

#import "DetailTweetViewController.h"
#import "ToolbarView.h"
#import "TwitterClient.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "TransitionManager.h"

@interface DetailTweetViewController() <ToolbarDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UIView *toolbarView;

@property (nonatomic) ToolbarView *toolbar;

@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userHandle;
@property (weak, nonatomic) IBOutlet UILabel *tweetContent;
@property (weak, nonatomic) IBOutlet UILabel *creationDate;
@property (weak, nonatomic) IBOutlet UILabel *retweetUser;
@property (weak, nonatomic) IBOutlet UILabel *retweets;
@property (weak, nonatomic) IBOutlet UILabel *likes;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *retweetHeight;

@end

@implementation DetailTweetViewController

- (void)viewDidLoad {
    
    // Do any additional setup after loading the view from its nib
    self.toolbar = [[[NSBundle mainBundle] loadNibNamed:@"ToolbarView" owner:self.toolbarView options:nil] objectAtIndex:0];
    self.toolbar.frame = CGRectMake(0, 0, self.toolbarView.frame.size.width, self.toolbarView.frame.size.height);
    self.toolbar.delegate = self;
    
    
    [self.toolbarView addSubview: self.toolbar];
    
    [self configureViewWithTweet];
    [self.view setNeedsUpdateConstraints];
    
    [self configureNavigationBarWithBackButton];
    
    [super viewDidLoad];
}

- (void) updateTweetWithTweet:(Tweet*)tweet {
    self.tweet = tweet;
    
    [self configureViewWithTweet];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureViewWithTweet {
    self.userName.text = self.tweet.user.name;
    self.userHandle.text = self.tweet.user.screenName;
    
    self.tweetContent.text = self.tweet.tweetContent;
    
    [self.userImageView setImageWithURL:self.tweet.user.profileImageURL];
    
    self.creationDate.text = [self stringFromDate:self.tweet.creationDate];
    
    [self configureRetweetBar];
    
    [self updateCounts];
    
    [self.toolbar configureBarWithTweet:self.tweet];
}

- (void)updateCounts{
    self.retweets.text = [self.tweet.retweetCount stringValue];
    self.likes.text = [self.tweet.favouriteCount stringValue];
}

- (void)configureRetweetBar{
    if(self.tweet.retweetedTweet){
        self.retweetUser.text = self.tweet.retweetUser.name;
    } else{
        self.retweetHeight.constant = 0;
    }
}

- (void)favouriteButtonPressed {
    int change = [self.tweet favourited] ? -1 : 1;
    [self.tweet favouriteChanged];
    [self updateCounts];
    
    if(change == 1){
        //Tweet was favourited
        [[TwitterClient sharedInstance] favouriteTweetWithID:self.tweet.tweetID completion:^(NSError *error) {
            [self.delegate updateTweetWithTweet:self.tweet];
        }];
    } else if(change == -1){
        //Tweet was unfavourited
        [[TwitterClient sharedInstance] unfavouriteTweetWithID:self.tweet.tweetID completion:^(NSError *error) {
            [self.delegate updateTweetWithTweet:self.tweet];
        }];
    }
}

- (void)retweetButtonPressed {
    int change = [self.tweet retweet] ? -1 : 1;
    [self.tweet retweetChanged];
    [self updateCounts];
    
    if(change == -1){
        //Tweet was retweeted
        [[TwitterClient sharedInstance] retweetTweetWithID:self.tweet.tweetID completion:^(NSError *error) {
            [self.delegate updateTweetWithTweet:self.tweet];
        }];
    } else if(change == 1){
        //Tweet was unretweeted
        [[TwitterClient sharedInstance] unretweetTweetWithID:self.tweet.tweetID completion:^(NSError *error) {
            [self.delegate updateTweetWithTweet:self.tweet];
        }];
    }
}

- (void)replyButtonPressed {
    [TransitionManager replyToTweet:self.tweet viewController:self];
}

- (NSString*)stringFromDate:(NSDate*)date {
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"M/d/yy, h:mm a"];
    return [formatter stringFromDate:date];
}


@end
