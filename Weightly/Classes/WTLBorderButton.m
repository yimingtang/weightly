//
//  WTLBorderButton.m
//  Weightly
//
//  Created by Yiming Tang on 12/2/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//

#import "WTLBorderButton.h"

@implementation WTLBorderButton

- (instancetype)init {
    if ((self = [super init])) {
        self.titleLabel.font = [UIFont fontWithName:@"Avenir-Light" size:16.0];
        self.contentEdgeInsets = UIEdgeInsetsMake(5.0, 10.0, 5.0, 10.0);
        [self setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.5f] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        
        self.layer.cornerRadius = 5.0;
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = [[UIColor colorWithWhite:1.0 alpha:0.5f] CGColor];
    }
    return self;
}

@end
