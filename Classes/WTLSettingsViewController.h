//
//  WTLSettingsViewController.h
//  Weightly
//
//  Created by Yiming Tang on 11/5/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//

@import UIKit;

extern NSString *const kWTLHeightDefaultsKey;
extern NSString *const kWTLGenderDefaultsKey;
extern NSString *const kWTLGoalDefaultsKey;
extern NSString *const kWTLUnitsDefaultsKey;
extern NSString *const kWTLThemeDefaultsKey;
extern NSString *const kWTLReminderDefaultsKey;
extern NSString *const kWTLAlarmClockDefaultsKey;

typedef NS_ENUM(NSUInteger, WTLGender) {
    WTLGenderMale,
    WTLGenderFemale,
};

typedef NS_ENUM(NSUInteger, WTLUnits) {
    WTLUnitsImperial,
    WTLUnitsMetric,
};

@interface WTLSettingsViewController : UITableViewController

@end
