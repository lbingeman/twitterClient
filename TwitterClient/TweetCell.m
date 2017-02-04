//
//  TweetCell.m
//  TwitterClient
//
//  Created by Laura Bingeman on 2017-01-30.
//  Copyright © 2017 Laura Bingeman. All rights reserved.
//

#import "TweetCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>


@interface TweetCell()<ToolbarDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *twitterImage;
@property (weak, nonatomic) IBOutlet UILabel *twitterName;
@property (weak, nonatomic) IBOutlet UILabel *twitterHandle;
@property (weak, nonatomic) IBOutlet UILabel *tweetTimestamp;
@property (weak, nonatomic) IBOutlet UILabel *tweetContent;
@property (weak, nonatomic) IBOutlet UILabel *retweetName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerViewHeight;

@property (strong,nonatomic) NSString* userID;
@property float originalRetweetHeight;
@property (strong, nonatomic) Tweet *tweet;

@property (weak, nonatomic) IBOutlet ToolbarView *toolbarView;
@property (nonatomic) ToolbarView* toolbar;

@end

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.originalRetweetHeight = self.headerViewHeight.constant;
    
    self.headerViewHeight.constant = 0;
    [self setNeedsUpdateConstraints];
    [self addImageGestureRecognizer];
    
    self.toolbar = [[[NSBundle mainBundle] loadNibNamed:@"ToolbarView" owner:self.toolbarView options:nil] objectAtIndex:0];
    self.toolbar.frame = CGRectMake(0, 0, self.toolbarView.frame.size.width, self.toolbarView.frame.size.height);
    self.toolbar.delegate = self;
    [self.toolbarView addSubview: self.toolbar];
}

- (void)loadWithTweet:(Tweet*)tweet {
    self.tweet = tweet;
    [self configureRegularCell];
    [self.toolbar configureBarWithTweet:self.tweet];
}

- (void)configureRegularCell {
    User *user = self.tweet.user;
    
    self.twitterName.text = user.name;
    self.twitterHandle.text = user.screenName;
    [self.twitterImage setImageWithURL:user.profileImageURL];
    
    self.tweetTimestamp.text = [self formattedTimeElapsedStringFromDate:self.tweet.creationDate];
    self.tweetContent.text = self.tweet.tweetContent;
    self.userID = user.screenName;
    
    self.tweet.retweetedTweet ? [self configureRetweet] : [self configureNoRetweet];
    
}

- (void)configureNoRetweet {
    self.headerViewHeight.constant = 0;
    [self setNeedsUpdateConstraints];
}

- (void)configureRetweet {
    self.retweetName.text = self.tweet.retweetUser.name;
    
    self.headerViewHeight.constant = self.originalRetweetHeight;
    [self setNeedsUpdateConstraints];
}


- (NSString*)formatHandle:(NSString*)handle{
    return [@"@" stringByAppendingString:handle];
}

- (NSString*)formattedTimeElapsedStringFromDate:(NSDate*) date {
    NSDateComponentsFormatter* dateFormatter = [NSDateComponentsFormatter new];
    dateFormatter.unitsStyle = NSDateComponentsFormatterUnitsStyleAbbreviated;
    dateFormatter.allowedUnits = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekOfYear | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    dateFormatter.maximumUnitCount = 1;
    return [dateFormatter stringFromDate:date toDate:[NSDate date]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)addImageGestureRecognizer{
    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    [self.twitterImage addGestureRecognizer:imageTap];
}

- (void)imageTapped:(UIGestureRecognizer*)gestureRecognizer{
    [self.delegate imageTapped:self];
}

- (void)favouriteButtonPressed {
    int change = [self.tweet favourited] ? -1 : 1;
    [self.tweet favouriteChanged];
    [self.delegate favouriteCountUpdate:change cell:self];
}

- (void)replyButtonPressed {
    [self.delegate replyToTweet:self];
}

- (void)retweetButtonPressed {
     int change = [self.tweet retweet] ? -1 : 1;
    [self.tweet retweetChanged];
    [self.delegate retweetCountUpdate:change cell:self];
}

@end
