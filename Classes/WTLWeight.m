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


#pragma mark - Class Methods

/* 
 * The data set is rather small -- less than 1000 objects.
 * Do one fetch and filter objects in memory.
 */
+ (void)updateAutoGeneratedWeightsWithWeight:(WTLWeight *)weight {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = [self entity];
    fetchRequest.sortDescriptors = [self defaultSortDescriptors];
    fetchRequest.returnsObjectsAsFaults = NO;
    NSError *error = nil;
    NSArray *fetchedObjects = [[self mainQueueContext] executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil || error) {
        NSLog(@"Error: didn't fetch any weight objects");
        NSLog(@"Error: %@", error);
        return;
    }
    
    // Should be efficient
    NSUInteger baseIndex = [fetchedObjects indexOfObject:weight];
    
    // 1. Search an object whose index is larger than `index` and `userGenerated = YES`
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(baseIndex + 1, fetchedObjects.count - baseIndex - 1)];
    __block NSUInteger index = NSNotFound;
    [fetchedObjects enumerateObjectsAtIndexes:indexSet options:kNilOptions usingBlock:^(WTLWeight *obj, NSUInteger idx, BOOL *stop) {
        if (obj.userGenerated) {
            index = idx;
            *stop = YES;
        }
    }];
    
    float offset = 0;
    if (index == NSNotFound) {
        offset = 0;
        index = fetchedObjects.count - 1;
    } else {
        WTLWeight *otherWeight = [fetchedObjects objectAtIndex:index];
        offset = (otherWeight.amount - weight.amount) / (index - baseIndex);
    }
    
    indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(baseIndex + 1, index - baseIndex)];
    [fetchedObjects enumerateObjectsAtIndexes:indexSet options:kNilOptions usingBlock:^(WTLWeight *obj, NSUInteger idx, BOOL *stop) {
        obj.amount = weight.amount + offset * (idx - baseIndex);
    }];
    
    // 2. Search an object whose index is less than `index` and `userGenerated = YES`
    indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, baseIndex)];
    index = NSNotFound;
    [fetchedObjects enumerateObjectsAtIndexes:indexSet options:NSEnumerationReverse usingBlock:^(WTLWeight *obj, NSUInteger idx, BOOL *stop) {
        if (obj.userGenerated) {
            index = idx;
            *stop = YES;
        }
    }];
    
    if (index == NSNotFound) {
        offset = 0;
        index = 0;
    } else {
        WTLWeight *otherWeight = [fetchedObjects objectAtIndex:index];
        offset = (weight.amount - otherWeight.amount) / (baseIndex - index);
    }
    
    indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index, baseIndex - index)];
    [fetchedObjects enumerateObjectsAtIndexes:indexSet options:kNilOptions usingBlock:^(WTLWeight *obj, NSUInteger idx, BOOL *stop) {
        obj.amount = weight.amount - offset * (baseIndex - idx);
    }];
}


+ (void)generateRecentWeightsIfNecessary {
    
}


#pragma mark - Key path dependencies

+ (NSSet *)keyPathsForValuesAffectingSectionIdentifier
{
    // If the value of timeStamp changes, the section identifier may change as well.
    return [NSSet setWithObject:@"timeStamp"];
}

@end
