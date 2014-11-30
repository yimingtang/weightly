//
//  NSUserDefaults+Weightly.m
//  Weightly
//
//  Created by Yiming Tang on 11/29/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//

#import "NSUserDefaults+Weightly.h"

@implementation NSUserDefaults (Weightly)

+ (instancetype)wtl_sharedUserDefaults {
    static NSUserDefaults *_sharedUserDefaults = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedUserDefaults = [[self alloc] initWithSuiteName:@"group.org.xianqu.weightly"];
    });
    return _sharedUserDefaults;
}

@end
