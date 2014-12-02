//
//  WTLLineGraphModelController.h
//  Weightly
//
//  Created by Yiming Tang on 11/4/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//

#import <BEMSimpleLineGraphView.h>

typedef NS_ENUM(NSUInteger, WTLLineGraphTimePeriod) {
    WTLLineGraphTimePeriodOneWeek,
    WTLLineGraphTimePeriodOneMonth,
    WTLLineGraphTimePeriodThreeMonths,
    WTLLineGraphTimePeriodOneYear,
};


@class WTLWeight;
@protocol WTLLineGraphModelControllerDelegate;

@interface WTLLineGraphModelController : NSObject <BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate>

@property (nonatomic) BOOL ignoreChange;
@property (nonatomic) BOOL useChangeAnimations;
@property (nonatomic) WTLLineGraphTimePeriod timePeriod;
@property (nonatomic, weak) id<WTLLineGraphModelControllerDelegate> delegate;

- (void)reloadData;
- (WTLWeight *)latestWeight;

@end


@protocol WTLLineGraphModelControllerDelegate <NSObject>
@optional
- (void)modelControllerDidReloadData:(WTLLineGraphModelController *)controller;
- (void)modelController:(WTLLineGraphModelController *)controller didChangeLatestWeightObject:(WTLWeight *)weight;
@end
