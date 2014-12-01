//
//  WTLBMICalculator.m
//  Weightly
//
//  Created by Yiming Tang on 11/30/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//

#import "WTLBMICalculator.h"

@implementation WTLBMICalculator

#pragma mark - Accessors

@synthesize height = _height;
@synthesize weight = _weight;


#pragma mark - Singleton

+ (instancetype)sharedCalculator {
    static WTLBMICalculator *_sharedCalculator = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedCalculator = [[self alloc] initWithWeight:0.0 height:0.0];
    });
    
    return _sharedCalculator;
}


#pragma mark - Class Methods

+ (float)bmiForWeight:(float)weight height:(float)height {
    return weight / (height * height);
}


+ (BMICategory)bmiCategoryForBMI:(float)bmi {
    BMICategory category;
    if (bmi < 15.0) {
        category = BMICategoryVerySeverelyUnderweight;
    } else if (bmi < 16.0) {
        category = BMICategorySeverelyUnderweight;
    } else if (bmi < 18.5) {
        category = BMICategoryUnderweight;
    } else if (bmi < 25.0) {
        category = BMICategoryNormal;
    } else if (bmi < 30.0) {
        category = BMICategoryOverweight;
    } else if (bmi < 35.0) {
        category = BMICategoryObeseClassOne;
    } else if (bmi < 40.0) {
        category = BMICategoryObeseClassTwo;
    } else {
        category = BMICategoryObeseClassThree;
    }
    return category;
}


+ (BMICategory)bmiCategoryForWeight:(float)weight height:(float)height {
    return [self bmiCategoryForBMI:[self bmiForWeight:weight height:height]];
}


+ (NSString *)descriptionForBMICategory:(BMICategory)category {
    NSString *string = nil;
    switch (category) {
        case BMICategoryVerySeverelyUnderweight:
            string = @"Very severely underweight";
            break;
        case BMICategorySeverelyUnderweight:
            string = @"Severely underweight";
            break;
        case BMICategoryUnderweight:
            string = @"Underweight";
            break;
        case BMICategoryNormal:
            string = @"Normal";
            break;
        case BMICategoryOverweight:
            string = @"Overweight";
            break;
        case BMICategoryObeseClassOne:
            string = @"Moderately obese";
            break;
        case BMICategoryObeseClassTwo:
            string = @"Severely obese";
            break;
        case BMICategoryObeseClassThree:
            string = @"Very severely obese";
            break;
    }
    
    return string;
}


+ (NSString *)fullBMIDescriptionForWeight:(float)weight height:(float)height {
    float bmi = [self bmiCategoryForWeight:weight height:height];
    NSString *bmiCategory = [self descriptionForBMICategory:[self bmiCategoryForBMI:bmi]];
    NSString *bmiString = [[self numberFormatter] stringFromNumber:@(bmi)];
    return [NSString stringWithFormat:@"%@ - %@", bmiString, bmiCategory];
}


+ (NSNumberFormatter *)numberFormatter {
    static NSNumberFormatter *numberFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        numberFormatter = [[NSNumberFormatter alloc] init];
        numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        numberFormatter.minimumFractionDigits = 0;
        numberFormatter.maximumFractionDigits = 2;
        numberFormatter.roundingMode = NSNumberFormatterRoundDown;
    });
    return numberFormatter;
}


#pragma mark - NSObject

- (instancetype)initWithWeight:(float)weight height:(float)height {
    if ((self = [super init])) {
        _weight = weight;
        _height = height;
    }
    return self;
}


#pragma mark - Public

- (float)bmi {
    return [[self class] bmiForWeight:self.weight height:self.height];
}


- (BMICategory)bmiCategory {
    return [[self class] bmiCategoryForBMI:[self bmi]];
}


- (NSString *)fullBMIDescription {
    return [[self class] fullBMIDescriptionForWeight:self.weight height:self.height];
}

@end
