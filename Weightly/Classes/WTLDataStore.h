//
//  WTLDataStore.h
//  Weightly
//
//  Created by Yiming Tang on 11/19/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//

@import Foundation;

@interface WTLDataStore : NSObject

+ (void)configureDataStack;
+ (void)setupDataStack;
+ (void)saveMainQueueContext;

@end
