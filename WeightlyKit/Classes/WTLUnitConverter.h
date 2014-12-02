//
//  WTLUnitConverter.h
//  Weightly
//
//  Created by Yiming Tang on 11/30/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//

@import Foundation;

#import "WTLDefines.h"

@interface WTLUnitConverter : NSObject

@property (nonatomic) WTLUnitsType targetUnitsType;
@property (nonatomic) BOOL autoUpdateTargetUnitsType;

+ (float)convertMassFromKgToLbs:(float)mass;
+ (float)convertMassFromLbsToKg:(float)mass;
+ (float)convertLengthFromCmToIn:(float)length;
+ (float)convertLengthFromInToCm:(float)length;
+ (NSNumberFormatter *)numberFormatter;

+ (NSString *)lengthUnitSymbolForUnitsType:(WTLUnitsType)type;
+ (NSString *)massUnitSymbolForUnitsType:(WTLUnitsType)type;

+ (instancetype)sharedConverter;

- (instancetype)initWithTargetUnitsTypeType:(WTLUnitsType)type;
- (NSString *)targetLengthUnitSymbol;
- (NSString *)targetMassUnitSymbol;
- (float)targetMassForMetricMass:(float)mass;
- (float)targetLengthForMetricLength:(float)length;
- (float)metricMassForTagretMass:(float)mass;
- (float)metricLengthForTargetLength:(float)length;
- (NSString *)targetDisplayStringForMetricMass:(float)mass;
- (NSString *)targetDisplayStringForMetricLength:(float)length;

@end
