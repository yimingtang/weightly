//
//  WTLTheme.m
//  Weightly
//
//  Created by Yiming Tang on 12/2/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//

#import "WTLTheme.h"
#import "WTLDefines.h"
#import "WTLPreferences.h"

#import <SAMCategories/UIColor+SAMAdditions.h>

static NSString *const kWTLThemeTitleKey = @"title";
static NSString *const kWTLThemeColorKey = @"color";

@implementation WTLTheme

#pragma mark - Accessors

@synthesize title = _title;
@synthesize color = _color;


#pragma mark - Class Methods

+ (NSCache *)_cache {
    static NSCache *cache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [[NSCache alloc] init];
    });
    return cache;
}


+ (instancetype)currentTheme {
    NSString *themeName = [[WTLPreferences sharedPreferences] objectForKey:kWTLThemeKey];
    return [self themeNamed:themeName];
}


+ (NSDictionary *)_themeResources {
    static NSDictionary *_themeResources = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"themes" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        _themeResources = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingOptions)kNilOptions error:nil];
    });
    return _themeResources;
}


+ (NSArray *)availableThemeNames {
    return [[self _themeResources] objectForKey:@"order"];
}


+ (NSDictionary *)availableThemesDictionary {
    return [[self _themeResources] objectForKey:@"themes"];
}


+ (instancetype)themeNamed:(NSString *)name {
    if (!name) {
        return nil;
    }
    
    WTLTheme *cachedTheme = [[self _cache] objectForKey:name];
    if (!cachedTheme) {
        cachedTheme = [self themeWithDictionary:[[self availableThemesDictionary] objectForKey:name]];
        if (cachedTheme) {
            [[self _cache] setObject:cachedTheme forKey:name];
        } else {
            NSLog(@"[WTLTheme] Could not find theme named: %@ ", name);
        }
    }
    
    return cachedTheme;
}


+ (instancetype)themeWithDictionary:(NSDictionary *)dictionary {
    return [[self alloc] initWithDictionary:dictionary];
}


#pragma mark - Initialization

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if ((self = [self init])) {
        _title = [dictionary objectForKey:kWTLThemeTitleKey];
        _color = [UIColor sam_colorWithHex:[dictionary objectForKey:kWTLThemeColorKey]];
    }
    return self;
}

@end
