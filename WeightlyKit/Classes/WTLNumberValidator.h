//
//  WTLNumberValidator.h
//  Weightly
//
//  Created by Yiming Tang on 12/1/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//

@import UIKit;

@interface WTLNumberValidator : NSObject

@property (nonatomic) float minimumValue;
@property (nonatomic) float maximumValue;

- (instancetype)initWithMinimumValue:(float)minimumValue maximumValue:(float)maximumValue;
- (BOOL)validateValue:(float)value;

@end
