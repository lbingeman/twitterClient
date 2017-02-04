//
//  InfiniteScrollActivityView.h
//  TwitterClient
//
//  Created by Laura Bingeman on 2017-02-03.
//  Copyright © 2017 Laura Bingeman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfiniteScrollActivityView : UIView
+(CGFloat) defaultHeight;
- (void)startAnimating;
- (void)stopAnimating;
@end
