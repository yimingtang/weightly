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
        _weightData = @[@65.4, @65.3, @65.1, @65.5, @64.7, @64.5, @64.3];
    }
    return _weightData;
}


#pragma mark - BEMSimpleLineGraphDataSource

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    return self.weightData.count;
}


- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    return [self.weightData[index] floatValue];
}

@end
