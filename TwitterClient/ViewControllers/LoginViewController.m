//
//  LoginViewController.m
//  TwitterClient
//
//  Created by Laura Bingeman on 2017-01-30.
//  Copyright © 2017 Laura Bingeman. All rights reserved.
//

#import "LoginViewController.h"
#import "TwitterClient.h"
#import "TransitionManager.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [self configureNavigationBar];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)configureNavigationBar {
    self.navigationItem.title = @"Twitter";
    //self.navigationItem.hidesBackButton = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onLogin:(UIButton *)sender {
    [[TwitterClient sharedInstance] loginWithCompletion:^(User *user, NSError *error) {
        if(!error && user != nil){
            [User setCurrentUser:user];
            [TransitionManager transitionToTweetFeedListFrom:self];
        } else{
            // do some error checking
        }
    }];
}




@end
