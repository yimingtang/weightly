//
//  WTLBMICalculator.h
//  Weightly
//
//  Created by Yiming Tang on 11/30/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//

@import Foundation;

#import "WTLDefines.h"

typedef NS_ENUM(NSUInteger, BMICategory) {
    BMICategoryVerySeverelyUnderweight,
    BMICategorySeverelyUnderweight,
    BMICategoryUnderweight,
    BMICategoryNormal,
    BMICategoryOverweight,
    BMICategoryObeseClassOne,
    BMICategoryObeseClassTwo,
    BMICategoryObeseClassThree,
};

@interface WTLBMICalculator : NSObject

@property (nonatomic) float height;
@property (nonatomic) float weight;

+ (float)bmiForWeight:(float)weight height:(float)height;
+ (BMICategory)bmiCategoryForWeight:(float)weight height:(float)height;
+ (BMICategory)bmiCategoryForBMI:(float)bmi;
+ (NSString *)descriptionForBMICategory:(BMICategory)category;
+ (NSString *)fullBMIDescriptionForWeight:(float)weight height:(float)height;

+ (instancetype)sharedCalculator;

- (instancetype)initWithWeight:(float)weight height:(float)height;
- (float)bmi;
- (BMICategory)bmiCategory;
- (NSString *)fullBMIDescription;

@end
