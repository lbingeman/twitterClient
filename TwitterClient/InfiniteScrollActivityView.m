//
//  InfiniteScrollActivityView.m
//  TwitterClient
//
//  Created by Laura Bingeman on 2017-02-03.
//  Copyright © 2017 Laura Bingeman. All rights reserved.
//

#import "InfiniteScrollActivityView.h"

CGFloat const defaultHeight = 60;

@interface InfiniteScrollActivityView ()
@property (nonatomic) UIActivityIndicatorView *activityIndicatorView;
@end

@implementation InfiniteScrollActivityView

+(CGFloat)defaultHeight{
    return 60;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.activityIndicatorView.center = CGPointMake(self.bounds.size.width/2,self.bounds.size.height/2);
}

- (void)setupActivityIndicator{
    self.activityIndicatorView = [UIActivityIndicatorView new];
    
    self.activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    self.activityIndicatorView.hidesWhenStopped = YES;
    
    [self addSubview:self.activityIndicatorView];
}

- (void)startAnimating{
    [self.activityIndicatorView startAnimating];
    self.hidden = NO;
}

- (void)stopAnimating{
    [self.activityIndicatorView stopAnimating];
    self.hidden = YES;
}
@end
