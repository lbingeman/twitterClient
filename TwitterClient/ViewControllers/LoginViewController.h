//
//  LoginViewController.h
//  TwitterClient
//
//  Created by Laura Bingeman on 2017-01-30.
//  Copyright © 2017 Laura Bingeman. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginTransitionDelegate <NSObject>
- (void)transitionFrom:(UIViewController*)fromViewController;
@end

@interface LoginViewController : UIViewController
@property (nonatomic) id<LoginTransitionDelegate>transitionDelegate;
@end
