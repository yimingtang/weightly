//
//  WTLAppDelegate.m
//  Weightly
//
//  Created by Yiming Tang on 10/27/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//

#import "WTLAppDelegate.h"
#import "WTLRootViewController.h"

@implementation WTLAppDelegate

#pragma mark - Accessors

- (UIWindow *)window {
    if (!_window) {
        _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _window;
}


#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window.rootViewController = [[WTLRootViewController alloc] init];
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
    
}

@end
