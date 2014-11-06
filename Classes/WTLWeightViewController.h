//
//  WTLWeightViewController.h
//  Weightly
//
//  Created by Yiming Tang on 10/27/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//

#import <BEMSimpleLineGraphView.h>

@interface WTLWeightViewController : UIViewController <BEMSimpleLineGraphDelegate>

@property (nonatomic, strong, readonly) UIButton *settingsButton;
@property (nonatomic, strong, readonly) UILabel *weightLabel;
@property (nonatomic, strong, readonly) UILabel *bmiLabel;
@property (nonatomic, strong, readonly) UIButton *historyButton;
@property (nonatomic, strong, readonly) BEMSimpleLineGraphView *lineGraphView;
@property (nonatomic, strong, readonly) UISegmentedControl *segmentedControl;

- (void)updateLineChart:(id)sender;
- (void)hideOrShowControls:(id)sender;
- (void)showHistory:(id)sender;
- (void)showWeightInput:(id)sender;
- (void)showPreferences:(id)sender;

@end
