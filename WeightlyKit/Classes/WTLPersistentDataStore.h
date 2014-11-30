//
//  WTLDataStore.h
//  Weightly
//
//  Created by Yiming Tang on 11/19/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//

@import CoreData;

@interface WTLPersistentDataStore : NSObject

@property (nonatomic, readonly) NSManagedObjectContext *mainQueueContext;
@property (nonatomic, readonly) NSManagedObjectContext *privateQueueContext;
@property (nonatomic, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (instancetype)sharedPersistentDataStore;

- (void)setupCoreDataStack;
- (void)saveContext;

@end
