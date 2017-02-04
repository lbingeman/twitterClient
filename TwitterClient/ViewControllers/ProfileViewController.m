//
//  ProfileViewController.m
//  TwitterClient
//
//  Created by Laura Bingeman on 2017-01-31.
//  Copyright © 2017 Laura Bingeman. All rights reserved.
//

#import "ProfileViewController.h"

#import "ViewControllerManager.h"

#import <AFNetworking/UIImageView+AFNetworking.h>

#import "User.h"

@interface ProfileViewController ()
@property (nonatomic,strong) User *user;
@property (weak, nonatomic) IBOutlet UILabel *followers;
@property (weak, nonatomic) IBOutlet UILabel *following;
@property (weak, nonatomic) IBOutlet UILabel *tweetTotal;

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIView *userTweetsView;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userHandle;
@end

@implementation ProfileViewController

- (instancetype)initWithUser:(User*)user nib:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self){
        self.user = user;
        if(self.user == [User currentUser]){
            [self configureNavigationBar];
        }
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    // Do any additional setup after loading the view from its nib.
}

- (void)setup {
    self.userName.text = self.user.name;
    self.userHandle.text = [@"@" stringByAppendingString: self.user.screenName];
    
    [self.profileImage setImageWithURL:self.user.profileImageURL];
    [self.backgroundImage setImageWithURL:self.user.backgroundImageURL];
    
    self.followers.text = [NSString stringWithFormat:@"%@",self.user.followers];
    self.following.text =  [NSString stringWithFormat:@"%@",self.user.following];
    self.tweetTotal.text =  [NSString stringWithFormat:@"%@",self.user.userTweetCount];
    
    UIViewController *embeddedViewController = [ViewControllerManager getListViewControllerWithUserID:self.user.screenName];
    
    [self addChildViewController:embeddedViewController];
    
    [embeddedViewController willMoveToParentViewController:self];
    
    [self.userTweetsView addSubview:embeddedViewController.view];
    
    [embeddedViewController didMoveToParentViewController:self];
    
      CGRect newFrame = CGRectMake(0, 0, self.userTweetsView.frame.size.width, self.userTweetsView.frame.size.height);
    embeddedViewController.view.frame = newFrame;
    
    [embeddedViewController.view layoutIfNeeded];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
