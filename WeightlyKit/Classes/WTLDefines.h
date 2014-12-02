//
//  WTLDefines.h
//  Weightly
//
//  Created by Yiming Tang on 11/29/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//

#ifndef WTLDEFINES
#define WTLDEFINES 1

@import Foundation;

/*
 * Defaults keys
 */
extern NSString *const kWTLHeightKey;
extern NSString *const kWTLGenderKey;
extern NSString *const kWTLGoalWeightKey;
extern NSString *const kWTLUnitsKey;
extern NSString *const kWTLThemeKey;
extern NSString *const kWTLEnableReminderKey;
extern NSString *const kWTLReminderTimeKey;
extern NSString *const kWTLHasLaunchOnceKey;
extern NSString *const kWTLCurrentWeightKey;
extern NSString *const kWTLControlsHiddenKey;


/*
 * Defaults info keys
 */
extern NSString *const kWTLDefaultsInfoTitleKey;
extern NSString *const kWTLDefaultsInfoValueTypeKey;
extern NSString *const kWTLDefaultsInfoOptionsKey;

extern NSString *const kWTLUnitsDidChangeNotificationName;
extern NSString *const kWTLHeightDidChangeNotificationName;


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

#endif
