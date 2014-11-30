//
//  WTLDataStore.m
//  Weightly
//
//  Created by Yiming Tang on 11/19/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//

#import "WTLPersistentDataStore.h"
#import "WTLWeight.h"

@implementation WTLPersistentDataStore

#pragma mark - Accessors

@dynamic mainQueueContext;
@dynamic privateQueueContext;
@dynamic persistentStoreCoordinator;

- (NSManagedObjectContext *)mainQueueContext {
    return [SSManagedObject hasMainQueueContext] ? [SSManagedObject mainQueueContext] : nil;
}


- (NSManagedObjectContext *)privateQueueContext {
    return [SSManagedObject hasPrivateQueueContext] ? [SSManagedObject privateQueueContext] : nil;
}


- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    return [SSManagedObject persistentStoreCoordinator];
}


#pragma mark - Singleton

+ (instancetype)sharedPersistentDataStore {
    static WTLPersistentDataStore *_sharedPersistentDataStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedPersistentDataStore = [[self alloc] init];
    });
    return _sharedPersistentDataStore;
}


#pragma mark - NSObject

- (instancetype)init {
    if ((self = [super init])) {
        
    }
    return self;
}


#pragma mark - Public

- (void)setupCoreDataStack {
    [self configureCoreDataStack];
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (![standardUserDefaults boolForKey:@"WTLHasLaunchOnce"]) {
        [standardUserDefaults setBool:YES forKey:@"WTLHasLaunchOnce"];
        [WTLWeight generateInitialWeights];
    }
    
    [WTLWeight generateRecentWeightsIfNecessary];
    
    [self saveContext];
}


- (void)saveContext {
    NSManagedObjectContext *context = self.mainQueueContext;
    if (!context) {
        return;
    }
    
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
}


#pragma mark - Private

- (void)configureCoreDataStack {
    NSDictionary *applicationInfo = [[NSBundle mainBundle] infoDictionary];
    NSString *applicationName = [applicationInfo objectForKey:(NSString *)kCFBundleNameKey];
    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *url = [documentsURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", applicationName]];
    [SSManagedObject setPersistentStoreURL:url];
    
#ifdef DEBUG
    [SSManagedObject setAutomaticallyResetsPersistentStore:YES];
#endif
}

@end
