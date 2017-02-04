//
//  Tweet.h
//  TwitterClient
//
//  Created by Laura Bingeman on 2017-01-30.
//  Copyright © 2017 Laura Bingeman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Tweet : NSObject
@property (nonatomic,readonly) NSString * tweetContent;
@property (nonatomic,readonly) NSString *tweetID;
@property (nonatomic,readonly) User * user;
@property (nonatomic,readonly) NSDate * creationDate;

@property (readonly) bool favourited;
@property (nonatomic,readonly) NSNumber *favouriteCount;

@property (readonly) bool retweet;
@property (readonly) bool retweetedTweet;
@property (nonatomic,readonly) NSNumber *retweetCount;
@property (nonatomic,readonly) User *retweetUser;

- (instancetype)initWithDictionary:(NSDictionary*)dictionary;
- (void)changeName:(NSString*)name;
- (void)favouriteChanged;
- (void)retweetChanged;
+ (NSArray *) tweetsWithArray:(NSArray*) array;
@end
