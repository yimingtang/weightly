//
//  WTLLineGraphModelController.m
//  Weightly
//
//  Created by Yiming Tang on 11/4/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//

#import "WTLLineGraphModelController.h"
#import "WTLWeight.h"

@interface WTLLineGraphModelController () <NSFetchedResultsControllerDelegate>

@property (nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic) NSMutableArray *mutableDataArray;

@end

@implementation WTLLineGraphModelController

@synthesize fetchedResultsController = _fetchedResultsController;

#pragma mark - Accessors

- (NSFetchedResultsController *)fetchedResultsController {
    if (!_fetchedResultsController && [SSManagedObject hasMainQueueContext]) {
        [self willCreateFetchedResultsController];
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:self.fetchRequest
                                                                        managedObjectContext:[SSManagedObject mainQueueContext]
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
        _fetchedResultsController.delegate = self;
        [_fetchedResultsController performFetch:nil];
        [self didCreateFetchedResultsController];
    }
    return _fetchedResultsController;
}


- (void)setFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController {
    _fetchedResultsController.delegate = nil;
    _fetchedResultsController = fetchedResultsController;
}


#pragma mark - NSObject

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (instancetype)init {
    if ((self = [super init])) {
        _useChangeAnimations = YES;
        _timePeriod = WTLLineGraphTimePeriodOneWeek;
        _mutableDataArray = [NSMutableArray arrayWithCapacity:365/7];
        _ignoreChange = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(managedObjectContextWillReset:) name:kSSManagedObjectWillResetNotificationName object:nil];
    }
    return self;
}


#pragma mark - Classbacks

- (void)willCreateFetchedResultsController {
    
}


- (void)didCreateFetchedResultsController {
    
}


#pragma mark - Configuration

- (NSFetchRequest *)fetchRequest {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = [WTLWeight entity];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"timeStamp" ascending:YES]];
    fetchRequest.fetchLimit = 365; // Only fetch one year of records
    fetchRequest.returnsObjectsAsFaults = NO;
    return fetchRequest;
}


#pragma mark - Public

- (void)reloadData {
    NSUInteger sampleSize = [self sampleSizeForTimePeriod:self.timePeriod];
    NSUInteger totalNumber = [self numberOfDaysForTimePeriod:self.timePeriod];
    NSArray *fetchedObjects = self.fetchedResultsController.fetchedObjects;
    // Should validate
    if (fetchedObjects.count < totalNumber) {
        totalNumber = fetchedObjects.count;
    }
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(fetchedObjects.count - totalNumber, totalNumber)];
    
    [self.mutableDataArray removeAllObjects];
    __block CGFloat tmp = 0;
    [fetchedObjects enumerateObjectsAtIndexes:indexSet options:kNilOptions usingBlock:^(WTLWeight *weight, NSUInteger idx, BOOL *stop) {
        tmp += weight.amount;
        if ((idx + 1) % sampleSize == 0) {
            [self.mutableDataArray addObject:@(tmp / sampleSize)];
            tmp = 0;
        } else if (idx == totalNumber - 1){
            [self.mutableDataArray addObject:@(tmp / ((idx + 1) % sampleSize))];
        }
    }];
}


- (WTLWeight *)latestWeight {
    return self.fetchedResultsController.fetchedObjects.lastObject;
}


#pragma mark - Private

- (NSUInteger)sampleSizeForTimePeriod:(WTLLineGraphTimePeriod)timePeriod {
    NSUInteger sampleSize = 1;
    switch (timePeriod) {
        case WTLLineGraphTimePeriodOneWeek:
        case WTLLineGraphTimePeriodOneMonth:
            sampleSize = 1;
            break;
        case WTLLineGraphTimePeriodThreeMonths:
            sampleSize = 3;
            break;
        case WTLLineGraphTimePeriodOneYear:
            sampleSize = 7;
            break;
    }
    return sampleSize;
}


- (NSUInteger)numberOfDaysForTimePeriod:(WTLLineGraphTimePeriod)timePeriod {
    NSUInteger number = 0;
    switch (timePeriod) {
        case WTLLineGraphTimePeriodOneWeek:
            number = 7;
            break;
        case WTLLineGraphTimePeriodOneMonth:
            number = 30;
            break;
        case WTLLineGraphTimePeriodThreeMonths:
            number = 90;
            break;
        case WTLLineGraphTimePeriodOneYear:
            number = 365;
            break;
    }
    return number;
}


- (void)setTimePeriod:(WTLLineGraphTimePeriod)timePeriod {
    _timePeriod = timePeriod;
    [self reloadData];
}


- (void)managedObjectContextWillReset:(NSNotification *)notification {
    self.fetchedResultsController = nil;
}


#pragma mark - BEMSimpleLineGraphDataSource

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    return self.mutableDataArray.count;
}


- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    return [[self.mutableDataArray objectAtIndex:index] floatValue];
}


#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    if (self.ignoreChange) {
        return;
    }
    // TODO:
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    if (self.ignoreChange) {
        return;
    }
    // TODO:
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    if (self.ignoreChange) {
        return;
    }
    // TODO:
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    if (self.ignoreChange) {
        return;
    }
    
    // Reload data
    [self reloadData];
    if ([self.delegate respondsToSelector:@selector(modelControllerDidReloadData:)]) {
        [self.delegate modelControllerDidReloadData:self];
    }
}

@end
