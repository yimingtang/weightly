//
//  WTLUnitConverter.m
//  Weightly
//
//  Created by Yiming Tang on 11/30/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//

#import "WTLUnitConverter.h"
#import "WTLPreferences.h"

@implementation WTLUnitConverter

#pragma mark - Accessors

@synthesize targetUnitsType = _targetUnitsType;


#pragma mark - Singleton

+ (instancetype)sharedConverter {
    static WTLUnitConverter *_sharedConverter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedConverter = [[self alloc] init];
    });
    return _sharedConverter;
}

+ (float)convertMassFromKgToLbs:(float)mass {
    return mass * 2.2046f;
}


+ (float)convertMassFromLbsToKg:(float)mass {
    return mass / 2.2046f;
}


+ (float)convertLengthFromCmToIn:(float)length {
    return length * 0.39370f;
}


+ (float)convertLengthFromInToCm:(float)length {
    return length / 0.39370f;
}


+ (NSString *)lengthUnitSymbolForUnitsType:(WTLUnitsType)type {
    NSString *symbol;
    switch (type) {
        case WTLUnitsTypeMetric:
            symbol = @"cm";
            break;
        case WTLUnitsTypeImperial:
            symbol = @"in";
            break;
    }
    return symbol;
}


+ (NSString *)massUnitSymbolForUnitsType:(WTLUnitsType)type {
    NSString *symbol;
    switch (type) {
        case WTLUnitsTypeMetric:
            symbol = @"kg";
            break;
        case WTLUnitsTypeImperial:
            symbol = @"lbs";
            break;
    }
    return symbol;
}


#pragma mark - NSObject

- (instancetype)init {
    WTLUnitsType type = [[[WTLPreferences sharedPreferences] objectForKey:kWTLUnitsKey] integerValue];
    return [self initWithTargetUnitsTypeType:type];
}


- (instancetype)initWithTargetUnitsTypeType:(WTLUnitsType)type {
    if ((self = [super init])) {
        _targetUnitsType = type;
    }
    return self;
}


#pragma mark - Public

- (NSString *)targetLengthUnitSymbol {
    return [[self class] lengthUnitSymbolForUnitsType:self.targetUnitsType];
}


- (NSString *)targetMassUnitSymbol {
    return [[self class] massUnitSymbolForUnitsType:self.targetUnitsType];
}


- (float)targetMassForMetricMass:(float)mass {
    float result;
    switch (self.targetUnitsType) {
        case WTLUnitsTypeImperial:
            result = [[self class] convertMassFromKgToLbs:mass];
            break;
        case WTLUnitsTypeMetric:
            result = mass;
            break;
    }
    return result;
}


- (float)targetLengthForMetricLength:(float)length {
    float result;
    switch (self.targetUnitsType) {
        case WTLUnitsTypeImperial:
            result = [[self class] convertLengthFromCmToIn:length];
            break;
        case WTLUnitsTypeMetric:
            result = length;
            break;
    }
    return result;
}


- (NSString *)targetDisplayStringForMetricMass:(float)mass {
    float result = [self targetMassForMetricMass:mass];
    NSString *symbol = [self targetMassUnitSymbol];
    NSNumberFormatter *numberFormatter = [[self class] numberFormatter];
    NSString *title = [numberFormatter stringFromNumber:@(result)];
    return [NSString stringWithFormat:@"%@ %@", title, symbol];
}


- (NSString *)targetDisplayStringForMetricLength:(float)length {
    float result = [self targetLengthForMetricLength:length];
    NSString *symbol = [self targetLengthUnitSymbol];
    NSNumberFormatter *numberFormatter = [[self class] numberFormatter];
    NSString *title = [numberFormatter stringFromNumber:@(result)];
    return [NSString stringWithFormat:@"%@ %@", title, symbol];
}


#pragma mark - Private

+ (NSNumberFormatter *)numberFormatter {
    static NSNumberFormatter *numberFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        numberFormatter = [[NSNumberFormatter alloc] init];
        numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        numberFormatter.minimumFractionDigits = 1;
        numberFormatter.maximumFractionDigits = 2;
    });
    return numberFormatter;
}

@end
