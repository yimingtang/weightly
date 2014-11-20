//
//  WTLUserDefaultsDataSource.m
//  Weightly
//
//  Created by Yiming Tang on 11/14/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//

#import "WTLUserDefaultsDataSource.h"

NSString *const kWTLHeightDefaultsKey = @"WTLHeight";
NSString *const kWTLGenderDefaultsKey = @"WTLGender";
NSString *const kWTLGoalDefaultsKey = @"WTLGoal";
NSString *const kWTLUnitsDefaultsKey = @"WTLUnits";
NSString *const kWTLThemeDefaultsKey = @"WTLTheme";
NSString *const kWTLReminderDefaultsKey = @"WTLReminder";
NSString *const kWTLAlarmClockDefaultsKey = @"WTLTime";
NSString *const kWTLHasLaunchOnceDefaultsKey = @"WTLHasLaunchOnce";

NSString *const kWTLDefaultsInfoTitleKey = @"label";
NSString *const kWTLDefaultsInfoValueTypeKey = @"type";
NSString *const kWTLDefaultsInfoOptionsKey = @"options";

@implementation WTLUserDefaultsDataSource

#pragma mark - Class Methods

+ (NSDictionary *)sharedValueMap {
    static NSDictionary *map = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        map = @{
                kWTLHeightDefaultsKey: @{kWTLDefaultsInfoTitleKey: @"Height",
                                         kWTLDefaultsInfoValueTypeKey: @(WTLDefaultsValueTypeNumber)},
                kWTLGenderDefaultsKey: @{kWTLDefaultsInfoTitleKey: @"Gender",
                                         kWTLDefaultsInfoValueTypeKey: @(WTLDefaultsValueTypeOption),
                                         kWTLDefaultsInfoOptionsKey: @[@(WTLGenderTypeMale), @(WTLGenderTypeFemale)],
                                         @(WTLGenderTypeMale): @"Male",
                                         @(WTLGenderTypeFemale): @"Female"},
                kWTLGoalDefaultsKey: @{kWTLDefaultsInfoTitleKey: @"Goal",
                                       kWTLDefaultsInfoValueTypeKey: @(WTLDefaultsValueTypeNumber)},
                kWTLUnitsDefaultsKey: @{kWTLDefaultsInfoTitleKey: @"Units",
                                        kWTLDefaultsInfoValueTypeKey: @(WTLDefaultsValueTypeOption),
                                        kWTLDefaultsInfoOptionsKey: @[@(WTLUnitsTypeImperial), @(WTLUnitsTypeMetric)],
                                        @(WTLUnitsTypeMetric): @"Metric",
                                        @(WTLUnitsTypeImperial): @"Imperial"},
                kWTLThemeDefaultsKey: @{kWTLDefaultsInfoTitleKey: @"Theme",
                                        kWTLDefaultsInfoValueTypeKey: @(WTLDefaultsValueTypeText)},
                kWTLReminderDefaultsKey: @{kWTLDefaultsInfoTitleKey: @"Reminder",
                                           kWTLDefaultsInfoValueTypeKey: @(WTLDefaultsValueTypeOption),
                                           kWTLDefaultsInfoOptionsKey: @[@(NO), @(YES)],
                                           @(NO): @"Off",
                                           @(YES): @"On"},
                kWTLAlarmClockDefaultsKey: @{kWTLDefaultsInfoTitleKey: @"Time",
                                             kWTLDefaultsInfoValueTypeKey: @(WTLDefaultsValueTypeTime)},
                };
    });
    return map;
}


#pragma mark - NSObject

- (instancetype)init {
    if ((self = [super init])) {
        _valueMap = [[self class] sharedValueMap];
        _userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}


#pragma mark - Accessors

- (NSDictionary *)infoDictionaryForDefaultsKey:(NSString *)key {
    return [self.valueMap objectForKey:key];
}


- (id)objectForInfoKey:(NSString *)key fromDefaultsInfo:(NSDictionary *)info {
    return [info objectForKey:key];
}


- (id)objectForInfoKey:(NSString *)key fromDefaultsInfoWithDefaultsKey:(NSString *)defaultsKey {
    NSDictionary *info = [self infoDictionaryForDefaultsKey:defaultsKey];
    return [self objectForInfoKey:key fromDefaultsInfo:info];
}


- (WTLDefaultsValueType)valueTypeForDefaultsInfo:(NSDictionary *)info {
    return [[info objectForKey:kWTLDefaultsInfoValueTypeKey] integerValue];
}


- (WTLDefaultsValueType)valueTypeForDefaultsKey:(NSString *)key {
    NSDictionary *info = [self infoDictionaryForDefaultsKey:key];
    return [self valueTypeForDefaultsInfo:info];
}


- (id)valueObjectForDefaultsKey:(NSString *)key {
    return [self.userDefaults objectForKey:key];
}


- (void)setValueObject:(id)object forDefaultsKey:(NSString *)key {
    [self.userDefaults setObject:object forKey:key];
}


#pragma mark - Manipulation

- (void)saveUserDefaults {
    [self.userDefaults synchronize];
}

@end
