//
//  WTLLineChartModelController.h
//  Weightly
//
//  Created by Yiming Tang on 11/4/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//

#import <BEMSimpleLineGraphView.h>

typedef NS_ENUM(NSUInteger, WTLLineGraphTimePeriod) {
    WTLLineGraphTimePeriodOneWeek,
    WTLLineGraphTimePeriodMonth,
    WTLLineGraphTimePeriodThreeMonths,
    WTLLineGraphTimePeriodOneYear,
};

@interface WTLLineGraphModelController : NSObject <BEMSimpleLineGraphDataSource>

@property (assign, nonatomic) WTLLineGraphTimePeriod timePeriod;

@end
