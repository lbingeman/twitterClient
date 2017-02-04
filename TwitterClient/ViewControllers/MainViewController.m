//
//  MainViewController.m
//  TwitterClient
//
//  Created by Laura Bingeman on 2017-02-01.
//  Copyright © 2017 Laura Bingeman. All rights reserved.
//

#import "MainViewController.h"
#import "TweetCell.h"
#import "TwitterClient.h"
#import "DetailTweetViewController.h"
#import "TransitionManager.h"

@interface MainViewController ()

@end

@implementation MainViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureNavigationBar {
    UIBarButtonItem *logoutButton =
    [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"close-icon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(logout)];
    
    UIBarButtonItem *composeTweetButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"edit-icon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(goToNewTweet)];
    
    self.navigationItem.leftBarButtonItem = logoutButton;
    
    self.navigationItem.titleView = [self getTitleView];
    
    self.navigationItem.title = @"Twitter";
    
    self.navigationItem.rightBarButtonItem = composeTweetButton;
}

- (void)configureNavigationBarWithBackButton {

    self.navigationItem.titleView = [self getTitleView];
    
    UIBarButtonItem* leftBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-icon"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed)];
    self.navigationItem.leftBarButtonItem = leftBar;
}

- (UIView*)getTitleView {
    UIImageView *titleImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Twitter_Logo_Blue.png"]];
    titleImage.contentMode = UIViewContentModeScaleAspectFit;
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    titleImage.frame= titleView.bounds;
    [titleView addSubview:titleImage];
    
    return titleView;
}



- (void)backButtonPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)logout {
    [[TwitterClient sharedInstance] logout];
    [TransitionManager transitionToLoginFrom:self];
}

- (void)goToNewTweet {
    [TransitionManager transitionToNewTweet:self];
}

@end
