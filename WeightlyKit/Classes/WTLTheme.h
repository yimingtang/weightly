//
//  WTLTheme.h
//  Weightly
//
//  Created by Yiming Tang on 12/2/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//

@import UIKit;

@interface WTLTheme : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) UIColor *color;

+ (instancetype)themeNamed:(NSString *)name;
+ (instancetype)themeWithDictionary:(NSDictionary *)dictionary;
+ (instancetype)currentTheme;

+ (NSArray *)availableThemeNames;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
