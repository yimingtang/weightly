//
//  WTLPreferences.m
//  Weightly
//
//  Created by Yiming Tang on 11/14/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//

#import "WTLPreferences.h"
#import "WTLDefines.h"
#import "NSUserDefaults+Weightly.h"

@interface WTLPreferences ()
@property (nonatomic) NSDictionary *defaults;
@end

@implementation WTLPreferences

#pragma mark - Accessors

@synthesize defaults = _defaults;

- (void)registerDefaults:(NSDictionary *)defaults {
    self.defaults = defaults;
}


- (id)objectForKey:(NSString *)key {
    id value = [[self defaultsStore] objectForKey:key];
    if (!value) {
        value = self.defaults[key];
    }
    return value;
}


- (void)setObject:(id<NSCoding>)object forKey:(NSString *)key {
    [[self defaultsStore] setObject:object forKey:key];
    [[self iCloudStore] setObject:object forKey:key];
}


- (void)removeObjectForKey:(NSString *)key {
    [[self defaultsStore] removeObjectForKey:key];
    [[self iCloudStore] removeObjectForKey:key];
}


- (void)synchronize {
    [[self iCloudStore] synchronize];
    [[self defaultsStore] synchronize];
}

#pragma mark - Singleton

+ (instancetype)sharedPreferences {
    static WTLPreferences *_sharedPreferences = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedPreferences = [[self alloc] init];
    });
    return _sharedPreferences;
}


+ (NSDictionary *)sharedDefaultsInfo {
    static NSDictionary *map = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        map = @{
                kWTLHeightKey: @{kWTLDefaultsInfoTitleKey: @"Height",
                                 kWTLDefaultsInfoValueTypeKey: @(WTLDefaultsValueTypeNumber)},
                kWTLGenderKey: @{kWTLDefaultsInfoTitleKey: @"Gender",
                                 kWTLDefaultsInfoValueTypeKey: @(WTLDefaultsValueTypeOption),
                                 kWTLDefaultsInfoOptionsKey: @[@(WTLGenderTypeMale), @(WTLGenderTypeFemale)],
                                 @(WTLGenderTypeMale): @"Male",
                                 @(WTLGenderTypeFemale): @"Female"},
                kWTLGoalWeightKey: @{kWTLDefaultsInfoTitleKey: @"Goal",
                                     kWTLDefaultsInfoValueTypeKey: @(WTLDefaultsValueTypeNumber)},
                kWTLUnitsKey: @{kWTLDefaultsInfoTitleKey: @"Units",
                                kWTLDefaultsInfoValueTypeKey: @(WTLDefaultsValueTypeOption),
                                kWTLDefaultsInfoOptionsKey: @[@(WTLUnitsTypeImperial), @(WTLUnitsTypeMetric)],
                                @(WTLUnitsTypeMetric): @"Metric",
                                @(WTLUnitsTypeImperial): @"Imperial"},
                kWTLThemeKey: @{kWTLDefaultsInfoTitleKey: @"Theme",
                                kWTLDefaultsInfoValueTypeKey: @(WTLDefaultsValueTypeText)},
                kWTLEnableReminderKey: @{kWTLDefaultsInfoTitleKey: @"Reminder",
                                         kWTLDefaultsInfoValueTypeKey: @(WTLDefaultsValueTypeOption),
                                         kWTLDefaultsInfoOptionsKey: @[@(NO), @(YES)],
                                         @(NO): @"Off",
                                         @(YES): @"On"},
                kWTLReminderTimeKey: @{kWTLDefaultsInfoTitleKey: @"Time",
                                       kWTLDefaultsInfoValueTypeKey: @(WTLDefaultsValueTypeTime)}
                };
    });
    return map;
}


#pragma mark - NSObject

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (instancetype)init {
    if ((self = [super init])) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(iCloudStoreDidChange:) name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification object:nil];
    }
    return self;
}


#pragma mark - Access Defaults Info

- (NSDictionary *)infoForDefaultsKey:(NSString *)key {
    return [[[self class] sharedDefaultsInfo] objectForKey:key];
}


#pragma mark - Private

- (NSUserDefaults *)defaultsStore {
    return [NSUserDefaults wtl_sharedUserDefaults];
}


- (NSUbiquitousKeyValueStore *)iCloudStore {
    return [NSUbiquitousKeyValueStore defaultStore];
}


- (void)iCloudStoreDidChange:(NSNotification *)notification {
    NSDictionary *iCloud = [[self iCloudStore] dictionaryRepresentation];
    for (NSString *key in iCloud) {
        [[self defaultsStore] setObject:iCloud[key] forKey:key];
    }
}

@end
