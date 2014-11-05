//
//  WTLLineChartModelController.m
//  Weightly
//
//  Created by Yiming Tang on 11/4/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//

#import "WTLLineGraphModelController.h"

@interface WTLLineGraphModelController ()
@property (strong, nonatomic, readonly) NSArray *weightData;
@end

@implementation WTLLineGraphModelController

#pragma mark - Accessors

@synthesize weightData = _weightData;

- (NSArray *)weightData {
    if (!_weightData) {
        _weightData = @[[self randomWeightArrayWithCapacity:7], [self randomWeightArrayWithCapacity:30], [self randomWeightArrayWithCapacity:30], [self randomWeightArrayWithCapacity:52]];
    }
    return _weightData;
}


#pragma mark - Private

- (NSArray *)randomWeightArrayWithCapacity:(NSUInteger)numItems {
    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:numItems];
    for (NSUInteger i = 0; i < numItems; i++) {
        [mutableArray addObject:@([self randomWeight])];
    }
    return mutableArray;
}


- (CGFloat)randomWeight {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        srand48(time(0));
    });
    return 60 + 5 * drand48();
}


- (NSUInteger)indexForTimePeriod:(WTLLineGraphTimePeriod)timePeriod {
    return timePeriod;
}


#pragma mark - BEMSimpleLineGraphDataSource

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    return [self.weightData[self.timePeriod] count];
}


- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    return [self.weightData[self.timePeriod][index] floatValue];
}

@end
