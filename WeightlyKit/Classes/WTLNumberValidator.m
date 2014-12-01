//
//  WTLNumberValidator.m
//  Weightly
//
//  Created by Yiming Tang on 12/1/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//

#import "WTLNumberValidator.h"

@implementation WTLNumberValidator

#pragma mark - Accessors

@synthesize minimumValue = _minimumValue;
@synthesize maximumValue = _maximumValue;


#pragma mark - NSObject

- (instancetype)initWithMinimumValue:(float)minimumValue maximumValue:(float)maximumValue {
    if ((self = [super init])) {
        NSAssert(minimumValue < maximumValue, @"Minimum value should be less than maximum value");
        _minimumValue = minimumValue;
        _maximumValue = maximumValue;
    }
    return self;
}


#pragma mark - Public

- (BOOL)validateValue:(float)value {
    return value > self.minimumValue && value < self.maximumValue;
}

@end
