//
//  UIColor+Weightly.m
//  Weightly
//
//  Created by Yiming Tang on 11/29/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//

#import "UIColor+Weightly.h"
#import "WTLTheme.h"

@implementation UIColor (Weightly)

+ (instancetype)wtl_themeColor {
    return [[WTLTheme currentTheme] color];
}

@end
