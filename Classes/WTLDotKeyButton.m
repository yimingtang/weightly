//
//  WTLDotKeyButton.m
//  Weightly
//
//  Created by Yiming Tang on 11/7/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//

#import "WTLDotKeyButton.h"

@implementation WTLDotKeyButton

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


#pragma mark - UIControl

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    if (highlighted) {
        self.backgroundColor = [UIColor whiteColor];
    } else {
        self.backgroundColor = [UIColor colorWithRed:215.0f/255.0f green:202.0f/255.0f blue:204.0f/255.0f alpha:1.0f];
    }
}


#pragma mark - Private

- (void)initialize {
    self.titleLabel.font = [UIFont boldSystemFontOfSize:24.0f];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self setTitle:@"." forState:UIControlStateNormal];
}

@end
