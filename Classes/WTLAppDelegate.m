//
//  WTLAppDelegate.m
//  Weightly
//
//  Created by Yiming Tang on 10/27/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//

#import "WTLAppDelegate.h"
#import "WTLWeightViewController.h"
#import "WTLSettingsViewController.h"

@implementation WTLAppDelegate

#pragma mark - Accessors

- (UIWindow *)window {
    if (!_window) {
        _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _window.backgroundColor = [UIColor whiteColor];
    }
    return _window;
}


#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    WTLWeightViewController *weightViewController = [[WTLWeightViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:weightViewController];
    self.window.rootViewController = navigationController;
    [self registerUserDefaults];
    [self applyStyle];
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {

}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
   
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark - Private Methods

- (void)applyStyle {
    self.window.tintColor = [UIColor colorWithWhite:1.0f alpha:0.8f];
    
    // Navigation Bar
    UINavigationBar *navigationBar = [UINavigationBar appearance];
    [navigationBar setTintColor:[UIColor whiteColor]];
    [navigationBar setBarTintColor:[UIColor colorWithRed:231.0f/255.0f green:76.0f/255.0f blue:60.0f/255.0f alpha:1.0f]];
    [navigationBar setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Avenir" size:22.0f],
                                            NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [navigationBar setTitleVerticalPositionAdjustment:3.0f forBarMetrics:UIBarMetricsDefault];
    
    // UISegmented Control
    UISegmentedControl *segmentedControl = [UISegmentedControl appearance];
    [segmentedControl setTintColor:[UIColor colorWithWhite:1.0f alpha:0.5f]];
    NSDictionary *segmentedControlTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:231.0f/255.0f green:76.0f/255.0f blue:60.0f/255.0f alpha:1.0f]};
    [segmentedControl setTitleTextAttributes:segmentedControlTextAttributes forState:UIControlStateSelected];
}


- (void)registerUserDefaults {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *date = [NSDate date];
    // TODO: iOS 7 solution
    NSDate *alarmDate = [calendar dateBySettingHour:8 minute:0 second:0 ofDate:date options:kNilOptions];
    
    NSDictionary *defaults = @{kWTLHeightDefaultsKey: @170.0f,
                               kWTLGenderDefaultsKey : @(WTLGenderMale),
                               kWTLGoalDefaultsKey : @60.0f,
                               kWTLUnitsDefaultsKey : @(WTLUnitsMetric),
                               kWTLThemeDefaultsKey : @"Cinnabar",
                               kWTLReminderDefaultsKey : @NO,
                               kWTLAlarmClockDefaultsKey: alarmDate,
                               };
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults registerDefaults:defaults];
    
    // Update version
    NSDictionary *bundleInfo = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [bundleInfo objectForKey:@"CFBundleShortVersionString"];
    NSString *build = [bundleInfo objectForKey:(NSString *)kCFBundleVersionKey];
    NSString *versionBuild = [NSString stringWithFormat:@"%@ (%@)", version, build];
    if (![versionBuild isEqualToString:[userDefaults stringForKey:@"WTLVersion"]]) {
        [userDefaults setObject:version forKey:@"WTLVersion"];
    }
}

@end
