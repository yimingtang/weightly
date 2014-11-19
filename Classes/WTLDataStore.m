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

    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"WTLHasLaunchOnce"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"WTLHasLaunchOnce"];
        [self prepareTestData];
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
        abort();
    }
}


#pragma mark - Private Methods

+ (void)prepareTestData {
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calender components:(NSCalendarUnitEra| NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
    NSDate *today = [calender dateFromComponents:dateComponents];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        srand48(time(0));
    });
    
    NSDateComponents *dayComponents = [[NSDateComponents alloc] init];
    WTLWeight *weight = nil;
    for (NSInteger i = 0; i < 365; i++) {
        weight = [[WTLWeight alloc] initWithContext:[WTLWeight mainQueueContext]];
        weight.amount = 60 + 5 * drand48();
        weight.userGenerated = YES;
        dayComponents.day = -i;
        weight.timeStamp = [calender dateByAddingComponents:dayComponents toDate:today options:kNilOptions];
    }
    [self saveMainQueueContext];
}

@end
