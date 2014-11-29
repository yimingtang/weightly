//
//  WTLDataStore.m
//  Weightly
//
//  Created by Yiming Tang on 11/19/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//

#import "WTLDataStore.h"
#import "WTLWeight.h"

@implementation WTLDataStore

#pragma mark - Public

+ (void)configureDataStack {
    NSDictionary *applicationInfo = [[NSBundle mainBundle] infoDictionary];
    NSString *applicationName = [applicationInfo objectForKey:(NSString *)kCFBundleNameKey];
    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *url = [documentsURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", applicationName]];
    [SSManagedObject setPersistentStoreURL:url];
#ifdef DEBUG
    [SSManagedObject setAutomaticallyResetsPersistentStore:YES];
#endif
}


+ (void)setupDataStack {
    [self configureDataStack];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults boolForKey:@"WTLHasLaunchOnce"] == NO) {
        [userDefaults setBool:YES forKey:@"WTLHasLaunchOnce"];
        [WTLWeight generateInitialWeights];
    }
    [WTLWeight generateRecentWeightsIfNecessary];
    
    [self saveMainQueueContext];
}


+ (void)saveMainQueueContext {
    if (![SSManagedObject hasMainQueueContext]) {
        return;
    }
    
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = [SSManagedObject mainQueueContext];
    if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        // abort();
    }
}

@end
