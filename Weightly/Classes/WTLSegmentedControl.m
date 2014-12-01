//
//  WTLSegmentedControl.m
//  Weightly
//
//  Created by Yiming Tang on 11/14/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//

#import "WTLSegmentedControl.h"

@implementation WTLSegmentedControl

#pragma mark - Accessors

@synthesize cell = _cell;

#pragma mark - UIView

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self initialize];
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self initialize];
    }
    return self;
}


#pragma mark - UISegmentedControl

- (instancetype)initWithItems:(NSArray *)items {
    if ((self = [super initWithItems:items])) {
        [self initialize];
    }
    return self;
}


#pragma mark - Initialization

- (void)initialize {
    // Remove borders and highlighted background
    [self setTintColor:[UIColor clearColor]];
    [self setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithWhite:1.0 alpha:0.5f],
                                   NSFontAttributeName: [UIFont fontWithName:@"Avenir-Light" size:20.0]}
                        forState:UIControlStateNormal];
    [self setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}
                        forState:UIControlStateSelected];
}

@end
