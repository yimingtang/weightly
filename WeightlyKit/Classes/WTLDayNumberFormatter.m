//
//  WTLOrdinalNumberFormatter.m
//  Weightly
//
//  Created by Yiming Tang on 12/1/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//

#import "WTLDayNumberFormatter.h"

static NSString * const kWTLDayNumberFormatterDefaultOrdinalIndicator = @"";

@implementation WTLDayNumberFormatter

@synthesize ordinalIndicator = _ordinalIndicator;

#pragma mark - NSObject

- (instancetype)init {
    if ((self = [super init])) {
        self.numberStyle = NSNumberFormatterNoStyle;
        self.allowsFloats = NO;
        self.generatesDecimalNumbers = NO;
        self.roundingMode = NSNumberFormatterRoundFloor;
        self.minimum = @0;
        self.lenient = YES;
    }
    return self;
}


#pragma mark - Private

- (NSString *)localizedOrdinalIndicatorStringFromNumber:(NSNumber *)number {
    NSString *languageCode = [[self locale] objectForKey:NSLocaleLanguageCode];
    if ([languageCode isEqualToString:@"en"]) {
        return [self enOrdinalIndicatorStringFromNumber:number];
    } else if ([languageCode isEqualToString:@"zh"]) {
        return [self zhHansOrdinalIndicatorStringFromNumber:number];
    } else {
        return kWTLDayNumberFormatterDefaultOrdinalIndicator;
    }
}


- (NSString *)enOrdinalIndicatorStringFromNumber:(NSNumber *)number {
    // If number % 100 is 11, 12, or 13
    if (NSLocationInRange([number integerValue] % 100, NSMakeRange(11, 3))) {
        return @"th";
    }
    
    switch ([number integerValue] % 10) {
        case 1:
            return @"st";
        case 2:
            return @"nd";
        case 3:
            return @"rd";
        default:
            return @"th";
    }
}


- (NSString *)zhHansOrdinalIndicatorStringFromNumber:(__unused NSNumber *)number {
    return @"\u65E6"; // Unicode Han Character 'day'
}


#pragma mark - NSFormatter

- (NSString *)stringForObjectValue:(id)anObject {
    if (![anObject isKindOfClass:[NSNumber class]]) {
        return nil;
    }
    
    NSString *indicator = self.ordinalIndicator;
    if (!indicator) {
        indicator = [self localizedOrdinalIndicatorStringFromNumber:(NSNumber *)anObject];
    }
    
    NSString *string = nil;
    @synchronized(self) {
        [self setPositivePrefix:nil];
        [self setPositiveSuffix:indicator];
        string = [super stringForObjectValue:anObject];
    }
    
    return string;
}


- (BOOL)getObjectValue:(out __autoreleasing id *)obj
             forString:(NSString *)string
      errorDescription:(out NSString *__autoreleasing *)error {
    NSInteger integer = NSNotFound;
    NSScanner *scanner = [NSScanner scannerWithString:string];
    [scanner scanInteger:&integer];
    
    if (integer != NSNotFound) {
        *obj = @(integer);
        
        return YES;
    }
    
    *error = NSLocalizedStringFromTable(@"String did not contain a valid ordinal number", @"WeightlyKit", nil);
    
    return NO;
}


#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    WTLDayNumberFormatter *formatter = [[[self class] allocWithZone:zone] init];
    formatter.ordinalIndicator = [self.ordinalIndicator copyWithZone:zone];
    return formatter;
}


#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    self.ordinalIndicator = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(ordinalIndicator))];
    return self;
}


- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.ordinalIndicator forKey:NSStringFromSelector(@selector(ordinalIndicator))];
}

@end
