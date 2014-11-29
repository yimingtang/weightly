//
//  WTLUserDefaultsDataSource.h
//  Weightly
//
//  Created by Yiming Tang on 11/14/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//

@import Foundation;

extern NSString *const kWTLHeightDefaultsKey;
extern NSString *const kWTLGenderDefaultsKey;
extern NSString *const kWTLGoalDefaultsKey;
extern NSString *const kWTLUnitsDefaultsKey;
extern NSString *const kWTLThemeDefaultsKey;
extern NSString *const kWTLReminderDefaultsKey;
extern NSString *const kWTLAlarmClockDefaultsKey;
extern NSString *const kWTLHasLaunchOnceDefaultsKey;

extern NSString *const kWTLDefaultsInfoTitleKey;
extern NSString *const kWTLDefaultsInfoValueTypeKey;
extern NSString *const kWTLDefaultsInfoOptionsKey;

typedef NS_ENUM(NSUInteger, WTLGenderType) {
    WTLGenderTypeMale,
    WTLGenderTypeFemale,
};

typedef NS_ENUM(NSUInteger, WTLUnitsType) {
    WTLUnitsTypeImperial,
    WTLUnitsTypeMetric,
};

typedef NS_ENUM(NSUInteger, WTLDefaultsValueType) {
    WTLDefaultsValueTypeNumber,
    WTLDefaultsValueTypeTime,
    WTLDefaultsValueTypeOption,
    WTLDefaultsValueTypeText,
};


@interface WTLUserDefaultsDataSource : NSObject

@property (nonatomic, readonly) NSDictionary *valueMap;
@property (nonatomic, readonly) NSUserDefaults *userDefaults;

#pragma mark - Access User Defaults

- (NSDictionary *)infoDictionaryForDefaultsKey:(NSString *)key;
- (id)objectForInfoKey:(NSString *)key fromDefaultsInfo:(NSDictionary *)info;
- (id)objectForInfoKey:(NSString *)key fromDefaultsInfoWithDefaultsKey:(NSString *)defaultsKey;
- (WTLDefaultsValueType)valueTypeForDefaultsInfo:(NSDictionary *)info;
- (WTLDefaultsValueType)valueTypeForDefaultsKey:(NSString *)key;

- (id)valueObjectForDefaultsKey:(NSString *)key;
- (void)setValueObject:(id)object forDefaultsKey:(NSString *)key;


#pragma mark - Manipulation

- (void)saveUserDefaults;

@end
