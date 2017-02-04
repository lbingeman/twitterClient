//
//  TweetComposeViewController.m
//  TwitterClient
//
//  Created by Laura Bingeman on 2017-02-01.
//  Copyright © 2017 Laura Bingeman. All rights reserved.
//

#import "TweetComposeViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "User.h"
#import "keyboardToolbar.h"
#import "TwitterClient.h"

@interface TweetComposeViewController () <KeyboardToolbarDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *tweetTextFieldPlaceholder;
@property (weak, nonatomic) IBOutlet UITextView *tweetTextField;
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImage;
@property (nonatomic) keyboardToolbar *keyboardAccessoryView;
@property (nonatomic) NSString *tweetContent;
@property (nonatomic) NSString* replyTweetID;
@property (nonatomic) NSString* replyTweetUserName;
@end

@implementation TweetComposeViewController
- (void)viewDidLoad {
    [self.tweetTextField becomeFirstResponder];
    
    self.keyboardAccessoryView = [[[NSBundle mainBundle] loadNibNamed:@"KeyboardToolbarView" owner:self options:nil] objectAtIndex:0];

    self.keyboardAccessoryView.delegate = self;
    
    self.tweetTextField.inputAccessoryView = self.keyboardAccessoryView;
    self.tweetTextField.delegate = self;
    [self.userProfileImage setImageWithURL:[User currentUser].profileImageURL];
    if(self.replyTweetUserName){
       self.tweetTextField.text = [@"@" stringByAppendingString:self.replyTweetUserName];
        [self.keyboardAccessoryView configAsReplyKeyboard];
    }
    
    [self updateView];
    
    [super viewDidLoad];
}

- (void)replyToTweet:(Tweet*)tweet{
    self.replyTweetUserName = tweet.user.screenName;
    self.replyTweetID = tweet.tweetID;
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.tweetTextField resignFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView {
    [self updateView];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return textView.text.length + (text.length - range.length) <= 140;
}

- (void)updateView{
    self.tweetContent = self.tweetTextField.text;
    [self.keyboardAccessoryView updateCharacterCount:[self.tweetTextField.text length]];
    if(self.tweetContent.length != 0){
        [self.tweetTextFieldPlaceholder setHidden:YES];
    } else{
        [self.tweetTextFieldPlaceholder setHidden:NO];
    }
}


- (IBAction)cancelButtonPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)finish{
    self.replyTweetID ? [[TwitterClient sharedInstance] replyToTweet:self.replyTweetID content:self.tweetContent completion:nil] : [[TwitterClient sharedInstance] postTweetWithContent:self.tweetContent completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
