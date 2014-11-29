//
//  WTLWeightViewController.h
//  Weightly
//
//  Created by Yiming Tang on 10/27/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//


@class WTLWeight;
@class BEMSimpleLineGraphView;

@interface WTLWeightViewController : UIViewController

@property (nonatomic, readonly) UIButton *settingsButton;
@property (nonatomic, readonly) UILabel *weightLabel;
@property (nonatomic, readonly) UILabel *bmiLabel;
@property (nonatomic, readonly) UIButton *historyButton;
@property (nonatomic, readonly) BEMSimpleLineGraphView *lineGraphView;
@property (nonatomic, readonly) UISegmentedControl *segmentedControl;
@property (nonatomic) WTLWeight *weight;


- (void)segmentedControlDidChange:(id)sender;
- (void)hideOrShowControls:(id)sender;
- (void)showHistory:(id)sender;
- (void)showWeightInput:(id)sender;
- (void)showSettings:(id)sender;

@end
