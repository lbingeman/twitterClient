//
//  TwitterClient.h
//  TwitterClient
//
//  Created by Laura Bingeman on 2017-01-30.
//  Copyright © 2017 Laura Bingeman. All rights reserved.
//

#import <BDBOAuth1Manager/BDBOAuth1SessionManager.h>
#import "User.h"
#import "Tweet.h"

@interface TwitterClient : BDBOAuth1SessionManager
+ (TwitterClient *)sharedInstance;

- (void)loginWithCompletion:(void(^)(User *user,NSError *error))completion;

- (void)getTwitterFeedWithCompletion:(void(^)(NSArray<Tweet*>* tweets, NSError* error))completion;
- (void)getUserFeedWithUserID:(NSString*)userID completion:(void(^)(NSArray<Tweet*>* tweets, NSError* error))completion;
- (void)getMentionFeedWithCompletion:(void(^)(NSArray<Tweet*>* tweets, NSError* error))completion;

- (void)getMoreTimelineTweetsAfter:(NSString*)lastLoadedTweetID completion:(void(^)(NSArray<Tweet*>* tweets, NSError* error))completion;
- (void)getMoreUserFeedTweetsWithUserID:(NSString*)userID lastTweet:(NSString*)lastLoadedTweetID completion:(void(^)(NSArray<Tweet*>* tweets, NSError* error))completion;
- (void)getMoreMentionTweetsAfter:(NSString*)lastLoadedTweetID completion:(void(^)(NSArray<Tweet*>* tweets, NSError* error))completion;

- (void)postTweetWithContent:(NSString*)tweetContent completion:(void(^)(Tweet *tweet, NSError *error))completion;
- (void)replyToTweet:(NSString*)tweetID content:(NSString*)content completion:(void(^)(Tweet*,NSError*))completion;

- (void)unfavouriteTweetWithID:(NSString*)tweetID completion:(void(^)(NSError* error))completion;
- (void)favouriteTweetWithID:(NSString*)tweetID completion:(void(^)(NSError* error))completion;

- (void)retweetTweetWithID:(NSString*)tweetID completion:(void(^)(NSError* error))completion;
- (void)unretweetTweetWithID:(NSString*)tweetID completion:(void(^)(NSError* error))completion;

- (void)openURL:(NSURL*)url;
- (void)logout;
@end
