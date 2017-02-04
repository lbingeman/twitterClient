//
//  TwitterClient.m
//  TwitterClient
//
//  Created by Laura Bingeman on 2017-01-30.
//  Copyright © 2017 Laura Bingeman. All rights reserved.
//

#import "TwitterClient.h"


NSString * const kTwitterConsumerKey = @"T7SvJ7Mk0AYYTLpMHBdOmKABT";
NSString * const kTwitterConsumerSecret = @"7fRzm2jgpauUOqlX3uIC0dWPxt2uHBP1QZNuYWBYTAeJKBdBVd";
NSString * const kTwitterBaseURL = @"https://api.twitter.com";

NSString * const authorizationURL = @"https://api.twitter.com/oauth/authorize?oauth_token=AUTH_TOKEN";

@interface TwitterClient()
@property (nonatomic,strong) void(^loginCompletion)(User *user,NSError *error);
@end

@implementation TwitterClient
+ (TwitterClient *)sharedInstance {
    static TwitterClient *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(instance == nil){
            instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:kTwitterBaseURL]  consumerKey:kTwitterConsumerKey consumerSecret:kTwitterConsumerSecret];
        }
    });
    
    return instance;
}

#pragma mark Login Methods
- (void)loginWithCompletion:(void(^)(User *user,NSError *error))completion {
    
    self.loginCompletion = completion;
    
    [self.requestSerializer removeAccessToken];
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"GET" callbackURL:[NSURL URLWithString:@"yahootwitterclient://oauth"] scope:nil success:^(BDBOAuth1Credential *requestToken) {
        NSLog(@"Got request token");
        NSLog(@"%@",[NSURL URLWithString:@"yahootwitterclient://oauth"]);
        NSURL *authURL = [NSURL URLWithString:[authorizationURL stringByReplacingOccurrencesOfString:@"AUTH_TOKEN" withString:requestToken.token]];
        [[UIApplication sharedApplication] openURL:authURL options:@{} completionHandler:nil];
    } failure:^(NSError *error) {
        NSLog(@"Got failure token");
        self.loginCompletion(nil,error);
    }];

}

- (void)openURL:(NSURL*)url {
    [self fetchAccessTokenWithPath:@"oauth/access_token" method:@"POST" requestToken:[BDBOAuth1Credential credentialWithQueryString:url.query] success:^(BDBOAuth1Credential *accessToken) {
        NSLog(@"Got access token");
        
        [[TwitterClient sharedInstance].requestSerializer saveAccessToken:accessToken];
        
        [[TwitterClient sharedInstance] GET:@"1.1/account/verify_credentials.json" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            User * newUser = [[User alloc] initWithDictionary:responseObject];
            NSLog(@"%@",newUser.screenName);
            self.loginCompletion(newUser,nil);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            self.loginCompletion(nil,error);
        }];
        

        
    } failure:^(NSError *error) {
        NSLog(@"Did not get access token");
    }];

}

#pragma mark get methods
- (void)getMoreTimelineTweetsAfter:(NSString*)lastLoadedTweetID completion:(void(^)(NSArray<Tweet*>* tweets, NSError* error))completion {
    [self getTweetsWithCall:@"1.1/statuses/home_timeline.json"  parameters:@{@"max_id":[self getCorrectLastLoadedTweet:lastLoadedTweetID]} completion:completion];
}

- (void)getMoreUserFeedTweetsWithUserID:(NSString*)userID lastTweet:(NSString*)lastLoadedTweetID completion:(void(^)(NSArray<Tweet*>* tweets, NSError* error))completion{
     [self getTweetsWithCall:@"1.1/statuses/user_timeline.json"  parameters:@{@"screen_name":userID,@"max_id":[self getCorrectLastLoadedTweet:lastLoadedTweetID]} completion:completion];
}

- (void)getMoreMentionTweetsAfter:(NSString*)lastLoadedTweetID completion:(void(^)(NSArray<Tweet*>* tweets, NSError* error))completion {
    
    [self getTweetsWithCall:@"1.1/statuses/mentions_timeline.json" parameters:@{@"max_id":[self getCorrectLastLoadedTweet:lastLoadedTweetID]} completion:completion];
}

- (NSString*)getCorrectLastLoadedTweet:(NSString*)tweetID{
    float numberTweetID = [tweetID floatValue];
    numberTweetID++;
    return [NSString stringWithFormat:@"%f",numberTweetID];
}

- (void)getTwitterFeedWithCompletion:(void(^)(NSArray<Tweet*>* tweets, NSError* error))completion{
     [self getTweetsWithCall:@"1.1/statuses/home_timeline.json"  parameters:nil completion:completion];
}

- (void)getMentionFeedWithCompletion:(void(^)(NSArray<Tweet*>* tweets, NSError* error))completion{
    [self getTweetsWithCall:@"1.1/statuses/mentions_timeline.json" parameters:nil completion:completion];
}

- (void)getUserFeedWithUserID:(NSString*)userID completion:(void(^)(NSArray<Tweet*>* tweets, NSError* error))completion{
    [self getTweetsWithCall:@"1.1/statuses/user_timeline.json"  parameters:@{@"screen_name":userID} completion:completion];
}

- (void)getTweetsWithCall:(NSString*)call parameters:(NSDictionary*)parameters completion:(void(^)(NSArray<Tweet*>* tweets, NSError* error))completion {
    [[TwitterClient sharedInstance] GET:call parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray<Tweet*> *tweets = [Tweet tweetsWithArray:responseObject];
        
        completion(tweets,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil,error);
    }];
}

#pragma mark post tweet methods
- (void)postTweetWithContent:(NSString*)tweetContent completion:(void(^)(Tweet *tweet, NSError *error))completion{
    [self postTweetWithParameters:@{@"status":tweetContent} completion:completion];
}

- (void)replyToTweet:(NSString*)tweetID content:(NSString*)content completion:(void(^)(Tweet*,NSError*))completion{
    [self postTweetWithParameters:@{@"status":content,@"in_reply_to_status_id":tweetID}
                       completion:completion];
}

- (void)postTweetWithParameters:(NSDictionary*)parameters completion:(void(^)(Tweet*,NSError*))completion {
    [[TwitterClient sharedInstance] POST:@"1.1/statuses/update.json" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(completion) completion([[Tweet alloc] initWithDictionary:responseObject],nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error.description);
        if(completion) completion(nil,error);
    }];
}

#pragma mark retweeting
- (void)retweetTweetWithID:(NSString*)tweetID completion:(void(^)(NSError* error))completion {
    [[TwitterClient sharedInstance] POST:[@"1.1/statuses/retweet/ID.json" stringByReplacingOccurrencesOfString:@"ID" withString:tweetID] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"Retweet!");
        completion(nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.description);
        completion(error);
    }];
}

- (void)unretweetTweetWithID:(NSString*)tweetID completion:(void(^)(NSError* error))completion {
    [[TwitterClient sharedInstance] POST:[@"1.1/statuses/unretweet/ID.json" stringByReplacingOccurrencesOfString:@"ID" withString:tweetID] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"Unretweet!");
        completion(nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.description);
        completion(error);
    }];
}

#pragma mark favouriting
- (void)favouriteTweetWithID:(NSString*)tweetID completion:(void(^)(NSError* error))completion {
    [[TwitterClient sharedInstance] POST:@"1.1/favorites/create.json" parameters:@{@"id":tweetID} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"Favorited!");
        completion(nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.description);
        completion(error);
    }];
}

- (void)unfavouriteTweetWithID:(NSString*)tweetID completion:(void(^)(NSError* error))completion {
    NSLog(@"%@",tweetID);
    [[TwitterClient sharedInstance] POST:@"1.1/favorites/destroy.json" parameters:@{@"id":tweetID} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"Unfavorited!");
        completion(nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.description);
        completion(error);
    }];
}

#pragma mark logout
- (void)logout {
    [User setCurrentUser:nil];
    [self deauthorize];
}


@end
