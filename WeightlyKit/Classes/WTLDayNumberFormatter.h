//
//  WTLOrdinalNumberFormatter.h
//  Weightly
//
//  Created by Yiming Tang on 12/1/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//

@import Foundation;

/**
 Instances of `WTLOrdinalNumberFormatter` create localized ordinal string representations of `NSNumber` objects.
 Each instance has a default number style of `NSNumberFormatterNoStyle`, does not allow floats nor generates decimal numbers, has a rounding mode of `NSNumberFormatterRoundFloor`, a minimum value of @0, and is has leniency turned on.
 For example, the numbers `@1`, `@2`, and `@3` would be formatted as `@"1st"`, `@"2nd"`, and `@"3rd"` in English.
 */
@interface WTLDayNumberFormatter : NSNumberFormatter

/**
 When specified, this overrides the indicator determined by the formatter. `nil` by default.
 */
@property (nonatomic, copy) NSString *ordinalIndicator;

@end
