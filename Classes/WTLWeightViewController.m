//
//  WTLWeightViewController.m
//  Weightly
//
//  Created by Yiming Tang on 10/27/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//

#import "WTLWeightViewController.h"
#import "WTLLineGraphModelController.h"
#import <BEMSimpleLineGraphView.h>
#import <Masonry.h>

@interface WTLWeightViewController () 

@property (strong, nonatomic, readonly) WTLLineGraphModelController *lineGraphModelController;

@end

@implementation WTLWeightViewController

#pragma mark - Accessors

@synthesize lineGraphModelController = _lineGraphModelController;
@synthesize weightLabel = _weightLabel;
@synthesize unitLabel = _unitLabel;
@synthesize bmiLabel = _bmiLabel;
@synthesize historyButton = _historyButton;
@synthesize lineGraphView = _lineGraphView;
@synthesize segmentedControl = _segmentedControl;

- (WTLLineGraphModelController *)lineGraphModelController {
    if (!_lineGraphModelController) {
        _lineGraphModelController = [[WTLLineGraphModelController alloc] init];
    }
    return _lineGraphModelController;
}


- (UILabel *)weightLabel {
    if (!_weightLabel) {
        _weightLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _weightLabel.textColor = [UIColor whiteColor];
        _weightLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:88.0f];
    }
    return _weightLabel;
}


- (UILabel *)bmiLabel {
    if (!_bmiLabel) {
        _bmiLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _bmiLabel.textColor = [UIColor colorWithWhite:1.0f alpha:0.5f];
        _bmiLabel.font = [UIFont fontWithName:@"Avenir-Light" size:16.0f];
    }
    return _bmiLabel;
}


- (UILabel *)unitLabel {
    if (!_unitLabel) {
        _unitLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _unitLabel.textColor = [UIColor whiteColor];
        _unitLabel.font = [UIFont fontWithName:@"Avenir-Regular" size:20.0f];
        _unitLabel.text = @"KG";
    }
    return _unitLabel;
}


- (UIButton *)historyButton {
    if (!_historyButton) {
        _historyButton = [[UIButton alloc] initWithFrame:CGRectZero];
        _historyButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Light" size:18.0f];
        [_historyButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateNormal];
        [_historyButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.8f] forState:UIControlStateHighlighted];
        [_historyButton setTitle:@"All Records" forState:UIControlStateNormal];
        _historyButton.contentEdgeInsets = UIEdgeInsetsMake(5.0f, 10.0f, 5.0f, 10.0f);
        _historyButton.layer.cornerRadius = 4.0f;
        _historyButton.layer.borderColor = [[UIColor colorWithWhite:1.0f alpha:0.5f] CGColor];
        _historyButton.layer.borderWidth = 1.0f;
    }
    return _historyButton;
}


- (BEMSimpleLineGraphView *)lineGraphView {
    if (!_lineGraphView) {
        _lineGraphView = [[BEMSimpleLineGraphView alloc] initWithFrame:CGRectMake(0, 60, 320, 250)];
        _lineGraphView.delegate = self;
        _lineGraphView.dataSource = self.lineGraphModelController;
        _lineGraphView.colorTop = [UIColor colorWithRed:231.0f/255.0f green:76.0f/255.0f blue:60.0f/255.0f alpha:1.0f];
        _lineGraphView.colorBottom = [UIColor colorWithRed:231.0f/255.0f green:76.0f/255.0f blue:60.0f/255.0f alpha:1.0f];
        _lineGraphView.colorLine = [UIColor whiteColor];
        _lineGraphView.widthLine = 3.0;
        _lineGraphView.enableTouchReport = YES;
        _lineGraphView.enableBezierCurve = YES;
        _lineGraphView.animationGraphStyle = BEMLineAnimationDraw;
    }
    return _lineGraphView;
}


- (UISegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"7 DAYS", @"1 MONTH", @"3 MONTHS", @"1 YEAR"]];
        [_segmentedControl addTarget:self action:@selector(updateLineChart:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl;
}


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:231.0f/255.0f green:76.0f/255.0f blue:60.0f/255.0f alpha:1.0f];
    
    [self.view addSubview:self.weightLabel];
    [self.weightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view).centerOffset(CGPointMake(-10.0f, -120.0f));
    }];
    self.weightLabel.text = @"65.3";
    
//    [self.view addSubview:self.unitLabel];
//    [self.unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.weightLabel.mas_right);
//        make.bottom.equalTo(self.weightLabel.mas_bottom);
//    }];
    
    [self.view addSubview:self.bmiLabel];
    [self.bmiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.weightLabel.mas_bottom);
        make.centerX.equalTo(self.view);
    }];
    self.bmiLabel.text = @"BMI 21.8 - NORMAL";
    
    [self.view addSubview:self.historyButton];
    [self.historyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bmiLabel.mas_bottom).with.offset(10.0f);
        make.centerX.equalTo(self.view);
    }];
    
    [self.view addSubview:self.segmentedControl];
    [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(20.0f);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-20.0f);
        make.right.equalTo(self.view.mas_right).with.offset(-20.0f);
    }];
    
    [self.view addSubview:self.lineGraphView];
    [self.lineGraphView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.historyButton.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.segmentedControl.mas_top).with.offset(-20.0f);
    }];
}


#pragma mark - Actions

- (void)updateLineChart:(id)sender {
    self.lineGraphModelController.timePeriod = self.segmentedControl.selectedSegmentIndex;
    [self.lineGraphView reloadGraph];
}


#pragma mark - BEMSimpleLineGraphDelegate


@end
