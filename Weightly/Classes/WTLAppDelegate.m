//
//  WTLAppDelegate.m
//  Weightly
//
//  Created by Yiming Tang on 10/27/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//

#import "WTLAppDelegate.h"
#import "WTLWeightViewController.h"
#import "WTLUserDefaultsDataSource.h"
#import "WTLDataStore.h"
#import "UIColor+Weightly.h"

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
    [navigationBar setBarTintColor:[UIColor wtl_redColor]];
    [navigationBar setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Avenir-Heavy" size:22.0f],
                                            NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [navigationBar setTitleVerticalPositionAdjustment:3.0f forBarMetrics:UIBarMetricsDefault];
    
    // UISegmented Control
    UISegmentedControl *segmentedControl = [UISegmentedControl appearance];
    [segmentedControl setTintColor:[UIColor colorWithWhite:1.0f alpha:0.5f]];
    NSDictionary *segmentedControlTextAttributes = @{NSForegroundColorAttributeName : [UIColor wtl_redColor]};
    [segmentedControl setTitleTextAttributes:segmentedControlTextAttributes forState:UIControlStateSelected];
}


- (void)configureDefaults {
    // Initialize alarm clock. 8:00 AM.
    // Use APIs for iOS 7 and ealier
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *today = [NSDate date];
    NSDateComponents *components = [calendar components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:today];
    [components setHour:8];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *alarmDate = [calendar dateFromComponents:components];
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults registerDefaults:@{kWTLHeightDefaultsKey: @170.0f,
                                             kWTLGenderDefaultsKey: @(WTLGenderTypeMale),
                                             kWTLGoalDefaultsKey: @60.0f,
                                             kWTLUnitsDefaultsKey: @(WTLUnitsTypeMetric),
                                             kWTLThemeDefaultsKey: @"Cinnabar",
                                             kWTLReminderDefaultsKey: @NO,
                                             kWTLAlarmClockDefaultsKey: alarmDate
                                             }];
}


- (void)configureDataStack {
    [WTLDataStore setupDataStack];
}


- (void)saveContext {
    [WTLDataStore saveMainQueueContext];
}


#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self configureAnalytics];
    [self configureDataStack];
    [self configureDefaults];
    [self configureAppearance];
    
    [self.window makeKeyAndVisible];
    
    // Update version string
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *bundleInfo = [[NSBundle mainBundle] infoDictionary];
        NSString *shortVersion = [bundleInfo objectForKey:@"CFBundleShortVersionString"];
        NSString *version = [bundleInfo objectForKey:(NSString *)kCFBundleVersionKey];
        NSString *versionString = [NSString stringWithFormat:@"%@ (%@)", shortVersion, version];
        NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
        if (![versionString isEqualToString:[standardDefaults stringForKey:@"WTLVersion"]]) {
            [standardDefaults setObject:version forKey:@"WTLVersion"];
            [standardDefaults synchronize];
        }
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
