//
//  WTLAppDelegate.m
//  Weightly
//
//  Created by Yiming Tang on 10/27/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//

#import "WTLAppDelegate.h"
#import "WTLWeightViewController.h"
#import "WeightlyKit.h"

@implementation WTLAppDelegate

@synthesize window = _window;

#pragma mark - Accessors

- (UIWindow *)window {
    if (!_window) {
        _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _window.backgroundColor = [UIColor blackColor];
        _window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[WTLWeightViewController alloc] init]];
    }
    return _window;
}


#pragma mark - Private Methods

- (void)configureAnalytics {
#ifndef DEBUG
    // TODO:
#endif
}


- (void)configureAppearance {
    self.window.tintColor = [UIColor colorWithWhite:1.0f alpha:0.8f];
    
    UINavigationBar *navigationBar = [UINavigationBar appearance];
    [navigationBar setTintColor:[UIColor whiteColor]];
    [navigationBar setBarTintColor:[UIColor wtl_themeColor]];
    [navigationBar setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Avenir-Heavy" size:22.0f],
                                            NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [navigationBar setTitleVerticalPositionAdjustment:3.0f forBarMetrics:UIBarMetricsDefault];
    
    // UISegmented Control
    UISegmentedControl *segmentedControl = [UISegmentedControl appearance];
    [segmentedControl setTintColor:[UIColor colorWithWhite:1.0f alpha:0.5f]];
    NSDictionary *segmentedControlTextAttributes = @{NSForegroundColorAttributeName : [UIColor wtl_themeColor]};
    [segmentedControl setTitleTextAttributes:segmentedControlTextAttributes forState:UIControlStateSelected];
}


- (void)configureDefaults {
    // Initialize alarm clock. 8:00 AM.
    // Use APIs for iOS 7 and ealier
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *today = [NSDate date];
    NSDateComponents *components = [calendar components:(NSCalendarUnit)(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:today];
    [components setHour:8];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *reminderTime = [calendar dateFromComponents:components];
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults registerDefaults:@{kWTLThemeKey: @"Cinnabar",
                                             kWTLEnableReminderKey: @NO,
                                             kWTLReminderTimeKey: reminderTime
                                             }];
    
    WTLPreferences *preferences = [WTLPreferences sharedPreferences];
    [preferences registerDefaults:@{kWTLHeightKey: @170.0f,
                                    kWTLGenderKey: @(WTLGenderTypeMale),
                                    kWTLUnitsKey: @(WTLUnitsTypeMetric),
                                    kWTLGoalWeightKey: @60.0f,
                                    kWTLCurrentWeightKey: @70.0f,
                                    }];
    [preferences synchronize];
}


- (void)configurePersistentDataStore {
    [[WTLPersistentDataStore sharedPersistentDataStore] setupCoreDataStack];
}


- (void)saveContext {
    [[WTLPersistentDataStore sharedPersistentDataStore] saveContext];
}


#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self configureAnalytics];
    [self configureDefaults];
    [self configurePersistentDataStore];
    [self configureAppearance];
    
    [self.window makeKeyAndVisible];
    
    // Update version string
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *bundleInfo = [[NSBundle mainBundle] infoDictionary];
        NSString *shortVersion = [bundleInfo objectForKey:@"CFBundleShortVersionString"];
        NSString *version = [bundleInfo objectForKey:(__bridge NSString *)kCFBundleVersionKey];
        NSString *versionString = [NSString stringWithFormat:@"%@ (%@)", shortVersion, version];
        NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
        [standardDefaults setObject:versionString forKey:@"WTLVersion"];
        [standardDefaults synchronize];
    });
    return YES;
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    [self saveContext];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    [self saveContext];
}


@end
