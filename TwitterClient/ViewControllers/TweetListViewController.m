//
//  TweetListViewController.m
//  TwitterClient
//
//  Created by Laura Bingeman on 2017-01-30.
//  Copyright © 2017 Laura Bingeman. All rights reserved.
//

#import "TweetListViewController.h"

#import "TweetCell.h"
#import "TwitterClient.h"
#import "DetailTweetViewController.h"
#import "TransitionManager.h"
#import "InfiniteScrollActivityView.h"


@interface TweetListViewController () <UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,TweetCellDelegate,DetailTweetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tweetListTable;

@property (nonatomic) NSArray<Tweet*> *tweets;

@property enum TweetListTypes listType;

@property NSString* userID;

@property bool isMoreDataLoading;
@property (nonatomic) InfiniteScrollActivityView* loadingMoreView;

@end

@implementation TweetListViewController

- (void)configureTweetListViewControllerAsTimeline {
    if(!self.listType){
        self.listType = Timeline;
        [self configureNavigationBar];
    }
    
}

- (void)configureTweetListViewControllerAsMentions {
    if(!self.listType){
        self.listType = Mentions;
        [self configureNavigationBar];
    }
}

- (void)configureTweetListViewControllerAsUserProfileWithUser:(NSString*)userID{
    if(!self.listType){
        self.listType = UserTweets;
        self.userID = userID;
        [self.navigationController setToolbarHidden:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tweetListTable.dataSource = self;
    self.tweetListTable.delegate = self;
    self.tweetListTable.estimatedRowHeight = 200;
    self.tweetListTable.rowHeight = UITableViewAutomaticDimension;
    
    UINib *tweetTableNib = [UINib nibWithNibName:@"TweetCell" bundle:nil];
    [self.tweetListTable registerNib:tweetTableNib forCellReuseIdentifier:@"TweetCell"];
    [self getTweetsWithCompletion:nil];
    
    UIRefreshControl *refreshControl = [UIRefreshControl new];
    [refreshControl addTarget:self action:@selector(refreshTweets:) forControlEvents:UIControlEventValueChanged];
    [self.tweetListTable insertSubview:refreshControl atIndex:0];
    
    CGRect loadMoreFrame = CGRectMake(0,self.tweetListTable.contentSize.height,self.tweetListTable.bounds.size.width, [InfiniteScrollActivityView defaultHeight]);
    self.loadingMoreView = [[InfiniteScrollActivityView alloc] initWithFrame:loadMoreFrame];
    self.loadingMoreView.hidden = YES;
    [self.tweetListTable addSubview:self.loadingMoreView];
    
//    var insets = tableView.contentInset;
//    insets.bottom += InfiniteScrollActivityView.defaultHeight;
//    tableView.contentInset = insets
    UIEdgeInsets insets = self.tweetListTable.contentInset;
    insets.bottom += [InfiniteScrollActivityView defaultHeight];
    self.tweetListTable.contentInset = insets;
}

- (void)updateTweetWithTweet:(Tweet *)tweet {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.tweetID = %@",tweet.tweetID];
    
    NSArray *tweetResults = [self.tweets filteredArrayUsingPredicate:predicate];
    
    if(tweetResults.count){
        NSUInteger indexNumber = [self.tweets indexOfObject:tweetResults[0]];
        NSMutableArray *tweets = [[NSMutableArray alloc] initWithArray:self.tweets];
        [tweets replaceObjectAtIndex:indexNumber withObject:tweet];
        self.tweets = tweets;
        [self.tweetListTable reloadData];
    }
}

- (void)showUserViewForCell:(UITableViewCell *)cell {
    if(self.listType == Timeline || self.listType == Mentions){
        User *user = ((Tweet*)self.tweets[[self.tweetListTable indexPathForCell:cell].row]).user;
        [TransitionManager transitionToProfilePageForUser:user viewController:self];
    }
}

- (void)refreshTweets:(UIRefreshControl*)refreshControl {
    [self getTweetsWithCompletion:^{
        [refreshControl endRefreshing];
    }];
}

- (void)getTweetsWithCompletion:(void(^)())completion{
    
    void(^customCompletion)(NSArray<Tweet*>*,NSError*) = ^(NSArray<Tweet*>* tweets,NSError* error){
        self.tweets = tweets;
        [self.tweetListTable reloadData];
        if(completion) completion();
    };
    
    switch (self.listType) {
        case Timeline:
        {
            [[TwitterClient sharedInstance] getTwitterFeedWithCompletion:customCompletion];
            break;
        }
        case UserTweets:
        {
            [[TwitterClient sharedInstance] getUserFeedWithUserID:self.userID completion:customCompletion];
            break;
        }
        case Mentions:
        {
            [[TwitterClient sharedInstance] getMentionFeedWithCompletion:customCompletion];
        }
        default:
            break;
    }
}

- (void)getMoreTweetsWithCompletion:(void(^)())completion{
    void(^customCompletion)(NSArray<Tweet*>*,NSError*) = ^(NSArray<Tweet*>* tweets,NSError* error){
        NSMutableArray *newTweets = [[NSMutableArray alloc] initWithArray:self.tweets];
        [newTweets addObjectsFromArray:tweets];
        self.tweets = newTweets;
        [self.tweetListTable reloadData];
        if(completion) completion();
    };
    
    NSString* lastID = [self.tweets lastObject].tweetID;
    
    switch (self.listType) {
        case Timeline:
        {
            [[TwitterClient sharedInstance] getMoreTimelineTweetsAfter:lastID completion:customCompletion];
            break;
        }
        case UserTweets:
        {
            [[TwitterClient sharedInstance] getMoreUserFeedTweetsWithUserID:self.userID lastTweet:lastID completion:customCompletion];
            break;
        }
        case Mentions:
        {
            [[TwitterClient sharedInstance] getMoreMentionTweetsAfter:lastID completion:customCompletion];
        }
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//To Do
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tweets count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [TransitionManager transitionToDetailViewFrom:self tweet:[self.tweets objectAtIndex:indexPath.row] delegate:self];
    [self.tweetListTable deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)tapUserImage: (UITapGestureRecognizer*) sender{
    if(self.listType == Timeline){
        User *user = [self.tweets objectAtIndex:sender.view.tag].user;
        [TransitionManager transitionToProfilePageForUser:user viewController:self];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [self.tweetListTable dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
    
    cell.delegate = self;
    
    Tweet *tweet = [self.tweets objectAtIndex:indexPath.row];
    [cell loadWithTweet:tweet];
    return cell;
}

- (void)imageTapped:(UITableViewCell *)cell {
    if(self.listType == Timeline){
        float rowNumber = [self.tweetListTable indexPathForCell:cell].row;
        User *user = [self.tweets objectAtIndex:rowNumber].user;
        [TransitionManager transitionToProfilePageForUser:user viewController:self];
    }
}

- (void)favouriteCountUpdate:(int)incrementAmount cell:(UITableViewCell *)cell {
    Tweet *currentTweet = [self.tweets objectAtIndex:[self.tweetListTable indexPathForCell:cell].row];
    
    if(incrementAmount > 0){
        //Tweet was favourited
        [[TwitterClient sharedInstance] favouriteTweetWithID:currentTweet.tweetID completion:^(NSError *error) {
            
        }];
    } else if(incrementAmount < 0){
        //Tweet was unfavourited
        [[TwitterClient sharedInstance] unfavouriteTweetWithID:currentTweet.tweetID completion:^(NSError *error) {
            
        }];
    }
}

- (void)replyToTweet:(UITableViewCell *)cell {
    // do some stuff to reply to a tweet
    Tweet *tweet = [self.tweets objectAtIndex:[self.tweetListTable indexPathForCell:cell].row];
    [TransitionManager replyToTweet:tweet viewController:self];
}

- (void)retweetCountUpdate:(int)incrementAmount cell:(UITableViewCell *)cell {
    Tweet *currentTweet = [self.tweets objectAtIndex:[self.tweetListTable indexPathForCell:cell].row];
    
    if(incrementAmount > 0){
        //Tweet was retweeted
        [[TwitterClient sharedInstance] retweetTweetWithID:currentTweet.tweetID completion:^(NSError *error) {
            
        }];
    } else if(incrementAmount < 0){
        //Tweet was unretweeted
        [[TwitterClient sharedInstance] unretweetTweetWithID:currentTweet.tweetID completion:^(NSError *error) {
        }];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(!self.isMoreDataLoading){
        
        CGFloat scrollViewContentHeight = self.tweetListTable.contentSize.height;
        CGFloat scrollOffsetThreshhold = scrollViewContentHeight - self.tweetListTable.bounds.size.height;
        
        if(self.tweetListTable.contentOffset.y > scrollOffsetThreshhold && self.tweetListTable.isDragging) {
            self.isMoreDataLoading = YES;
            
            CGRect frame = CGRectMake(0, self.tweetListTable.contentSize.height, self.tweetListTable.bounds.size.width, [InfiniteScrollActivityView defaultHeight]);
            self.loadingMoreView.frame = frame;
            [self.loadingMoreView startAnimating];
            
            [self getMoreTweetsWithCompletion:^{
                [self.loadingMoreView stopAnimating];
                self.isMoreDataLoading = NO;
            }];
        }
    }
}

- (NSString*)tweetDateStringFromDate:(NSDate*)date{
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    return [formatter stringFromDate:date];
}

@end
