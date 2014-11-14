//
//  WTLWeight.m
//  Weightly
//
//  Created by Yiming Tang on 11/13/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//

#import "WTLWeight.h"

@interface WTLWeight ()

@property (nonatomic) NSDate *primitiveTimeStamp;
@property (nonatomic) NSString *primitiveSectionIdentifier;

@end

@implementation WTLWeight

@dynamic amount;
@dynamic timeStamp;
@dynamic userGenerated;
@dynamic sectionIdentifier;
@dynamic primitiveTimeStamp;
@dynamic primitiveSectionIdentifier;

#pragma mark - SSManagedObject

+ (NSString *)entityName {
    return @"Weight";
}


+ (NSArray *)defaultSortDescriptors {
    return @[[NSSortDescriptor sortDescriptorWithKey:@"timeStamp" ascending:NO]];
}


#pragma mark - Accessors

- (NSString *)sectionIdentifier {
    // Create and cache the section identifier on demand.
    [self willAccessValueForKey:@"sectionIdentifier"];
    NSString *tmp = [self primitiveSectionIdentifier];
    [self didAccessValueForKey:@"sectionIdentifier"];
    
    if (!tmp) {
        // Sections are organized by month and year.
        // Create the section identifier as a string representing the number (year * 1000) + month;
        // this way they will be correctly ordered chronologically regardless of the actual name of the month.
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit) fromDate:self.timeStamp];
        tmp = [NSString stringWithFormat:@"%ld", (components.year * 1000 + components.month)];
        [self setPrimitiveSectionIdentifier:tmp];
    }
    return tmp;
}


- (void)setTimeStamp:(NSDate *)timeStamp {
    // If the time stamp changes, the section identifier become invalid.
    [self willChangeValueForKey:@"timeStamp"];
    [self setPrimitiveTimeStamp:timeStamp];
    [self didChangeValueForKey:@"timeStamp"];
    
    [self setPrimitiveSectionIdentifier:nil];
}


#pragma mark - Key path dependencies

+ (NSSet *)keyPathsForValuesAffectingSectionIdentifier
{
    // If the value of timeStamp changes, the section identifier may change as well.
    return [NSSet setWithObject:@"timeStamp"];
}

@end
