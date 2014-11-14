//
//  WTLSegmentedControl.m
//  Weightly
//
//  Created by Yiming Tang on 11/14/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//

#import "WTLSegmentedControl.h"

@implementation WTLSegmentedControl

#pragma mark - UIView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}


#pragma mark - UISegmentedControl

- (instancetype)initWithItems:(NSArray *)items {
    self = [super initWithItems:items];
    if (self) {
        [self initialize];
    }
    return self;
}


#pragma mark - Initialization

- (void)initialize {
    // Remove borders and highlighted background
    [self setTintColor:[UIColor clearColor]];
    [self setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithWhite:1.0f alpha:0.5f],
                                   NSFontAttributeName: [UIFont fontWithName:@"Avenir-Light" size:20.0f]}
                        forState:UIControlStateNormal];
    [self setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}
                        forState:UIControlStateSelected];
}

@end
