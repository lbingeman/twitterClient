//
//  keyboardToolbar.m
//  TwitterClient
//
//  Created by Laura Bingeman on 2017-02-01.
//  Copyright © 2017 Laura Bingeman. All rights reserved.
//

#import "keyboardToolbar.h"

static float maxCharCount = 140;

@interface keyboardToolbar ()
@property (weak, nonatomic) IBOutlet UIButton *tweetButton;
@property (weak, nonatomic) IBOutlet UILabel *characterCount;

@end

@implementation keyboardToolbar
- (void)configAsReplyKeyboard {
    [self.tweetButton setTitle:@"Reply" forState:UIControlStateNormal];
}

- (void)updateCharacterCount:(float)charCount{
    self.characterCount.text = [NSString stringWithFormat:@"%.0f", maxCharCount-charCount];
}
- (IBAction)buttonPressed:(UIButton *)sender {
    [self.delegate finish];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
