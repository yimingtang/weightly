//
//  WTLPreferences.h
//  Weightly
//
//  Created by Yiming Tang on 11/14/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//

@import Foundation;

@interface WTLPreferences : NSObject

+ (instancetype)sharedPreferences;

#pragma mark - Access Defaults Info

- (NSDictionary *)infoForDefaultsKey:(NSString *)key;


#pragma mark - Access Defaults

- (void)registerDefaults:(NSDictionary *)defaults;
- (id)objectForKey:(NSString *)key;
- (void)setObject:(id<NSCoding>)object forKey:(NSString *)key;
- (void)removeObjectForKey:(NSString *)key;


#pragma mark - Manipulation

- (void)synchronize;

@end
