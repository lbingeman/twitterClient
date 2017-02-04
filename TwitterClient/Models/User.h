//
//  User.h
//  TwitterClient
//
//  Created by Laura Bingeman on 2017-01-30.
//  Copyright © 2017 Laura Bingeman. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString* const userDidLogOutNotification = @"UserDidLogout";

@interface User : NSObject

@property (nonatomic,strong, readonly) NSString* screenName;
@property (nonatomic,strong, readonly) NSString* name;
@property (nonatomic,strong, readonly) NSURL* profileImageURL;
@property (nonatomic,strong, readonly) NSURL* backgroundImageURL;
@property (nonatomic,strong, readonly) NSString* tagLine;
@property (nonatomic,strong, readonly) NSDictionary* userDictionary;
@property (nonatomic,strong, readonly) NSNumber* followers;
@property (nonatomic,strong, readonly) NSNumber* following;
@property (nonatomic,strong, readonly) NSNumber* userTweetCount;
@property (class, nonatomic) User *currentUser;


- (instancetype)initWithDictionary:(NSDictionary*)dictionary;

@end
