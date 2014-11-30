//
//  WTLWeightViewController.m
//  Weightly
//
//  Created by Yiming Tang on 10/27/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//
#import <BEMSimpleLineGraphView.h>
#import <Masonry.h>
#import "WTLWeightViewController.h"
#import "WTLLineGraphModelController.h"
#import "WTLInputViewController.h"
#import "WTLSettingsViewController.h"
#import "WTLHistoryViewController.h"
#import "WTLPresentInputTransition.h"
#import "WTLDismissInputTransition.h"
#import "WTLWeight.h"

@interface WTLWeightViewController () <UIViewControllerTransitioningDelegate, WTLInputViewControllerDelegate, WTLLineGraphModelControllerDelegate>

@property (nonatomic, readonly) WTLLineGraphModelController *lineGraphModelController;

@end

@implementation WTLWeightViewController


#pragma mark - Class Methods

+ (NSDictionary *)weightLabelAttributes {
    static NSDictionary *_weightLabelAttributes = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _weightLabelAttributes = @{NSFontAttributeName : [UIFont fontWithName:@"Avenir" size:88.0f]};
    });
    
    return _weightLabelAttributes;
}


+ (NSDictionary *)unitLabelAttributes {
    static NSDictionary *_unitLabelAttributes = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _unitLabelAttributes = @{NSFontAttributeName : [UIFont fontWithName:@"Avenir" size:20.0f]};
    });
    
    return _unitLabelAttributes;
}

#pragma mark - Accessors

@synthesize lineGraphModelController = _lineGraphModelController;
@synthesize weightLabel = _weightLabel;
@synthesize bmiLabel = _bmiLabel;
@synthesize historyButton = _historyButton;
@synthesize lineGraphView = _lineGraphView;
@synthesize segmentedControl = _segmentedControl;
@synthesize settingsButton = _settingsButton;

- (WTLLineGraphModelController *)lineGraphModelController {
    if (!_lineGraphModelController) {
        _lineGraphModelController = [[WTLLineGraphModelController alloc] init];
        _lineGraphModelController.delegate = self;
    }
    return _lineGraphModelController;
}


- (UIButton *)settingsButton {
    if (!_settingsButton) {
        _settingsButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_settingsButton setImage:[UIImage imageNamed:@"settings-button"] forState:UIControlStateNormal];
        [_settingsButton addTarget:self action:@selector(showSettings:) forControlEvents:UIControlEventTouchUpInside];
        [_settingsButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [_settingsButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
        [_settingsButton setAdjustsImageWhenHighlighted:NO];
    }
    return _settingsButton;
}


- (UILabel *)weightLabel {
    if (!_weightLabel) {
        _weightLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _weightLabel.textColor = [UIColor whiteColor];
        _weightLabel.font = [UIFont fontWithName:@"Avenir" size:85.0f];
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


- (UIButton *)historyButton {
    if (!_historyButton) {
        _historyButton = [[UIButton alloc] initWithFrame:CGRectZero];
        _historyButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Light" size:16.0f];
        [_historyButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateNormal];
        [_historyButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.8f] forState:UIControlStateHighlighted];
        [_historyButton addTarget:self action:@selector(showHistory:) forControlEvents:UIControlEventTouchUpInside];
        [_historyButton setTitle:@"All Records" forState:UIControlStateNormal];
        _historyButton.contentEdgeInsets = UIEdgeInsetsMake(4.0f, 10.0f, 4.0f, 10.0f);
        _historyButton.layer.cornerRadius = 4.0f;
        _historyButton.layer.borderColor = [[UIColor colorWithWhite:1.0f alpha:0.5f] CGColor];
        _historyButton.layer.borderWidth = 1.0f;
    }
    return _historyButton;
}


- (BEMSimpleLineGraphView *)lineGraphView {
    if (!_lineGraphView) {
        _lineGraphView = [[BEMSimpleLineGraphView alloc] initWithFrame:CGRectMake(0, 60, 320, 250)];
        _lineGraphView.dataSource = self.lineGraphModelController;
        _lineGraphView.colorTop = [UIColor colorWithRed:231.0f/255.0f green:76.0f/255.0f blue:60.0f/255.0f alpha:1.0f];
        _lineGraphView.colorBottom = [UIColor colorWithRed:231.0f/255.0f green:76.0f/255.0f blue:60.0f/255.0f alpha:1.0f];
        _lineGraphView.colorLine = [UIColor whiteColor];
        _lineGraphView.widthLine = 2.0;
        _lineGraphView.enableTouchReport = YES;
        _lineGraphView.enablePopUpReport = YES;
        _lineGraphView.enableBezierCurve = NO;
        _lineGraphView.animationGraphStyle = BEMLineAnimationDraw;
    }
    return _lineGraphView;
}


- (UISegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"7 days", @"1 month", @"3 months", @"1 year"]];
        [_segmentedControl addTarget:self action:@selector(segmentedControlDidChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl;
}


- (void)setWeight:(WTLWeight *)weight {
    void *context = (__bridge void *)self;
    if (_weight) {
        [_weight removeObserver:self forKeyPath:@"amount" context:context];
    }
    
    _weight = weight;
    
    if (!_weight) {
        return;
    }
    
    [_weight addObserver:self forKeyPath:@"amount" options:NSKeyValueObservingOptionNew context:context];
    [self updateWeightLabelStringWithAmount:_weight.amount];
}


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    // Remove "Back" title for detail view controller
    // http://stackoverflow.com/questions/18870128/ios-7-navigation-bar-custom-back-button-without-title
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    self.view.backgroundColor = [UIColor colorWithRed:231.0f/255.0f green:76.0f/255.0f blue:60.0f/255.0f alpha:1.0f];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)]];
    
    [self.view addSubview:self.settingsButton];
    [self.settingsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(32.0f);
        make.right.equalTo(self.view.mas_right).with.offset(-20.0f);
        make.size.mas_equalTo(CGSizeMake(75.0f, 75.0f));
    }];
    
    [self.view addSubview:self.segmentedControl];
    [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.greaterThanOrEqualTo(self.view.mas_left).with.offset(20.0f);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-20.0f);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [self.view addSubview:self.lineGraphView];
    [self.lineGraphView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_centerY).with.offset(30.0f);
        make.bottom.equalTo(self.segmentedControl.mas_top).with.offset(-20.0f);
        make.width.equalTo(self.view.mas_width);
    }];
    
    [self.view addSubview:self.historyButton];
    [self.historyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.lineGraphView.mas_top).with.offset(-20.0f);
        make.centerX.equalTo(self.view);
    }];
    
    [self.view addSubview:self.bmiLabel];
    [self.bmiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.historyButton.mas_top).with.offset(-8.0f);
        make.centerX.equalTo(self.view);
    }];
    self.bmiLabel.text = @"BMI 21.8 - NORMAL";
    
    [self.view addSubview:self.weightLabel];
    [self.weightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view).with.offset(10.0f);
        make.bottom.equalTo(self.bmiLabel.mas_top);
        make.height.lessThanOrEqualTo(@90.0f);
    }];
    
    self.weight = [self.lineGraphModelController latestWeight];
    self.segmentedControl.selectedSegmentIndex = WTLLineGraphTimePeriodOneWeek;
    self.lineGraphModelController.timePeriod = WTLLineGraphTimePeriodOneWeek;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.lineGraphModelController.ignoreChange = NO;
    [self.lineGraphModelController reloadData];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.lineGraphModelController.ignoreChange = YES;
    self.lineGraphModelController.useChangeAnimations = NO;
}


#pragma mark - Actions

- (void)segmentedControlDidChange:(id)sender {
    self.lineGraphModelController.timePeriod = self.segmentedControl.selectedSegmentIndex;
}


- (void)hideOrShowControls:(id)sender {
    if ([UIApplication sharedApplication].statusBarHidden) {
        [self showControls:YES];
    } else {
        [self hideControls:YES];
    }
}


- (void)showHistory:(id)sender {
    WTLHistoryViewController *viewController = [[WTLHistoryViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}


- (void)showWeightInput:(id)sender {
    WTLInputViewController *viewController = [[WTLInputViewController alloc] init];
    viewController.suffixString = @"KG";
    viewController.inputString = [NSString stringWithFormat:@"%.1f", self.weight.amount];
    viewController.modalPresentationStyle = UIModalPresentationCustom;
    viewController.transitioningDelegate = self;
    viewController.delegate = self;
    [self presentViewController:viewController animated:YES completion:nil];
}


- (void)showSettings:(id)sender {
    WTLSettingsViewController *viewController = [[WTLSettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}


- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint point = [gestureRecognizer locationInView:self.weightLabel];
    CGRect labelRect = self.weightLabel.bounds;
    if (CGRectContainsPoint(labelRect, point)) {
        [self showWeightInput:nil];
    } else {
        [self hideOrShowControls:nil];
    }
}


#pragma mark - Private

- (void)updateWeightLabelStringWithAmount:(CGFloat)amount {
    NSString *weightString = [NSString stringWithFormat:@"%.1fKG", amount];
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:weightString attributes:[[self class] weightLabelAttributes]];
    [mutableAttributedString addAttributes:[[self class] unitLabelAttributes] range:NSMakeRange(weightString.length - 2, 2)];
    self.weightLabel.attributedText = mutableAttributedString;
}


- (void)hideControls:(BOOL)animated {
    void (^change)(void) = ^{
        self.settingsButton.alpha = 0.0f;
        self.historyButton.alpha = 0.0f;
        self.segmentedControl.alpha = 0.0f;
    };
    
    if (animated) {
        [UIView animateWithDuration:0.4f animations:change completion:nil];
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    } else {
        change();
    }
}


- (void)showControls:(BOOL)animated {
    void (^change)(void) = ^{
        self.settingsButton.alpha = 1.0f;
        self.historyButton.alpha = 1.0f;
        self.segmentedControl.alpha = 1.0f;
    };
    
    if (animated) {
        [UIView animateWithDuration:0.4f animations:change completion:nil];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    } else {
        change();
    }
}


#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [[WTLPresentInputTransition alloc] init];
}


- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [[WTLDismissInputTransition alloc] init];
}


#pragma mark - WTLInputViewControllerDelegate

- (void)inputViewController:(WTLInputViewController *)inputViewController didFinishEditingWithResult:(NSString *)result {
    CGFloat newAmount = [result floatValue];
    if (self.weight.amount == newAmount) {
        return;
    }
    
    self.weight.amount = newAmount;
    self.weight.userGenerated = YES;
    
    self.lineGraphModelController.ignoreChange = YES;
    [WTLWeight updateAutoGeneratedWeightsWithWeight:self.weight];
    self.lineGraphModelController.ignoreChange = NO;
}


#pragma mark - WTLLineGraphModelControllerDelegate

- (void)modelControllerDidReloadData:(WTLLineGraphModelController *)controller {
    self.lineGraphView.animationGraphEntranceTime = controller.useChangeAnimations ? 1.5 : 0;
    [self.lineGraphView reloadGraph];
}


- (void)modelController:(WTLLineGraphModelController *)controller didChangeLatestWeightObject:(WTLWeight *)weight {
    NSLog(@"modelController:didChangeLatestWeightObject:%@", weight);
    self.weight = weight;
}


#pragma mark - NSKeyValueObserving

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context != (__bridge void *)self) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    
    if ([keyPath isEqualToString:@"amount"]) {
        [self updateWeightLabelStringWithAmount:[[change objectForKey:NSKeyValueChangeNewKey] floatValue]];
    }
}

@end