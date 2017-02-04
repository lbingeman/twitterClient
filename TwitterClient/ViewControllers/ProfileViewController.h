//
//  ProfileViewController.h
//  TwitterClient
//
//  Created by Laura Bingeman on 2017-01-31.
//  Copyright © 2017 Laura Bingeman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "MainViewController.h"

@interface ProfileViewController : MainViewController
- (instancetype)initWithUser:(User*)user nib:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
@end
