//
//  Tweet.m
//  TwitterClient
//
//  Created by Laura Bingeman on 2017-01-30.
//  Copyright © 2017 Laura Bingeman. All rights reserved.
//

#import "Tweet.h"

@interface Tweet()

@property (nonatomic) NSString *tweetContent;
@property (nonatomic) NSString *tweetID;
@property (nonatomic) User *user;
@property (nonatomic) NSDate *creationDate;

@property bool favourited;
@property (nonatomic) NSNumber *favouriteCount;

@property bool retweet;
@property bool retweetedTweet;
@property (nonatomic) NSNumber *retweetCount;
@property (nonatomic) User *retweetUser;

@end

@implementation Tweet
- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    self = [super init];
    
    if(self) {
        self.tweetContent = dictionary[@"text"];
        self.tweetID = dictionary[@"id_str"];
        self.user = [[User alloc] initWithDictionary:dictionary[@"user"]];
        
        NSString * createDate = dictionary[@"created_at"];
        NSDateFormatter * dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
        self.creationDate = [dateFormatter dateFromString:createDate];
        ;
        self.favourited = [dictionary[@"favorited"] boolValue] ;
        
        self.favouriteCount = dictionary[@"favorite_count"];
        
        self.retweetedTweet = dictionary[@"retweeted_status"] ? YES : NO;

        self.retweet = [dictionary[@"retweeted"] boolValue];
        self.retweetCount = dictionary[@"retweet_count"];
        
        User * user = [[User alloc] initWithDictionary:dictionary[@"user"]];
        if(self.retweetedTweet){
            self.retweetUser = user;
            self.user = [[User alloc] initWithDictionary:dictionary[@"retweeted_status"][@"user"]];
            if(self.retweetUser.name == [User currentUser].name){
                self.retweet = YES;
            }
        } else{
            self.user = user;
        }
    }
    
    return self;
}

- (void)changeName:(NSString *)name {
    self.tweetContent = name;
}

- (void)favouriteChanged {
    self.favourited = !self.favourited;
    self.favouriteCount = [NSNumber numberWithFloat:self.favouriteCount.floatValue + (self.favourited ? 1:-1)];
}

- (void)retweetChanged {
    self.retweet = !self.retweet;
    self.retweetCount = [NSNumber numberWithFloat:self.retweetCount.floatValue + (self.retweet ? 1:-1)];
}

+ (NSArray *) tweetsWithArray:(NSArray*) array {
    NSMutableArray *tweets = [NSMutableArray array];
    
    for(NSDictionary* dictionary in array){
        [tweets addObject:[[Tweet alloc] initWithDictionary:dictionary]];
    }
    
    return tweets;
}
@end
