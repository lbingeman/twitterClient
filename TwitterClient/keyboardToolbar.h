//
//  keyboardToolbar.h
//  TwitterClient
//
//  Created by Laura Bingeman on 2017-02-01.
//  Copyright © 2017 Laura Bingeman. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol KeyboardToolbarDelegate <NSObject>
- (void)finish;
@end

@interface keyboardToolbar : UIView
@property id <KeyboardToolbarDelegate> delegate;
- (void)updateCharacterCount:(float)charCount;
- (void)configAsReplyKeyboard;
@end
