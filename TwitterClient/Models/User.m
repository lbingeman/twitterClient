//
//  User.m
//  TwitterClient
//
//  Created by Laura Bingeman on 2017-01-30.
//  Copyright © 2017 Laura Bingeman. All rights reserved.
//

#import "User.h"

@interface User()<NSCoding>
@property (nonatomic,strong) NSString* screenName;
@property (nonatomic,strong) NSString* name;
@property (nonatomic,strong) NSURL* profileImageURL;
@property (nonatomic,strong) NSURL* backgroundImageURL;
@property (nonatomic,strong) NSString* tagLine;
@property (nonatomic,strong) NSDictionary* userDictionary;
@property (nonatomic,strong) NSNumber* followers;
@property (nonatomic,strong) NSNumber* following;
@property (nonatomic,strong) NSNumber* userTweetCount;

@end

static User *p_currentUser;

@implementation User

- (instancetype)initWithDictionary:(NSDictionary*)dictionary{
    self = [super init];
    
    if(self){
        self.name = dictionary[@"name"];
        self.screenName = [@"" stringByAppendingString:dictionary[@"screen_name"]];
        self.profileImageURL = [NSURL URLWithString:dictionary[@"profile_image_url_https"]];
        self.backgroundImageURL = [NSURL URLWithString:dictionary[@"profile_banner_url"]];
        self.tagLine = dictionary[@"description"];
        self.userDictionary = dictionary;
        self.followers = dictionary[@"followers_count"];
        self.following = dictionary[@"friends_count"];
        self.userTweetCount = dictionary[@"statuses_count"];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder*)decoder{
    self = [super init];
    
    if(self){
        self.name = [decoder decodeObjectForKey:@"name"];
        self.screenName = [decoder decodeObjectForKey:@"screenName"];
        self.profileImageURL = [decoder decodeObjectForKey:@"profileImageURL"];
        self.backgroundImageURL = [decoder decodeObjectForKey:@"backgroundImageURL"];
        self.tagLine = [decoder decodeObjectForKey:@"tagLine"];
        self.followers =[decoder decodeObjectForKey:@"followers"];
        self.following = [decoder decodeObjectForKey:@"following"];
        self.userTweetCount = [decoder decodeObjectForKey:@"userTweetCount"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder*)encoder{
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.screenName forKey:@"screenName"];
    [encoder encodeObject:self.profileImageURL forKey:@"profileImageURL"];
    [encoder encodeObject:self.tagLine forKey:@"tagLine"];
    [encoder encodeObject:self.backgroundImageURL forKey:@"backgroundImageURL"];
    [encoder encodeObject:self.followers forKey:@"followers"];
    [encoder encodeObject:self.following forKey:@"following"];
    [encoder encodeObject:self.userTweetCount forKey:@"userTweetCount"];
    
}

+ (void)setCurrentUser:(User *)currentUser {
    p_currentUser = currentUser;
    
    NSUserDefaults *defaults = NSUserDefaults.standardUserDefaults;
    
    if(currentUser != nil){
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:currentUser];
        [defaults setObject:data forKey:@"currentUser"];
    } else{
        [defaults setObject:nil forKey:@"currentUser"];
    }
    
    [defaults synchronize];
}

+ (User *)currentUser {
    if(p_currentUser == nil){
        NSUserDefaults *defaults = NSUserDefaults.standardUserDefaults;
        NSData* data = [defaults objectForKey:@"currentUser"];
        p_currentUser = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
    return p_currentUser;
}



@end
