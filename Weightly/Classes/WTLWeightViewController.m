//
//  WTLWeightViewController.m
//  Weightly
//
//  Created by Yiming Tang on 10/27/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//

#import "WTLWeightViewController.h"
#import "WTLLineGraphModelController.h"
#import "WTLInputViewController.h"
#import "WTLSettingsViewController.h"
#import "WTLHistoryViewController.h"
#import "WTLPresentInputTransition.h"
#import "WTLDismissInputTransition.h"
#import "WTLBorderButton.h"

#import "WeightlyKit.h"
#import <Masonry/Masonry.h>
#import <BEMSimpleLineGraph/BEMSimpleLineGraphView.h>

@interface WTLWeightViewController () <UIViewControllerTransitioningDelegate, WTLInputViewControllerDelegate, WTLLineGraphModelControllerDelegate>
@property (nonatomic, readonly) UIButton *settingsButton;
@property (nonatomic, readonly) WTLWeightView *weightView;
@property (nonatomic, readonly) WTLBorderButton *historyButton;
@property (nonatomic, readonly) BEMSimpleLineGraphView *lineGraphView;
@property (nonatomic, readonly) UISegmentedControl *segmentedControl;
@property (nonatomic) BOOL controlsHidden;
@property (nonatomic) WTLWeight *weight;
@property (nonatomic, readonly) WTLLineGraphModelController *lineGraphModelController;
@end

@implementation WTLWeightViewController

#pragma mark - Accessors

@synthesize settingsButton = _settingsButton;
@synthesize weightView = _weightView;
@synthesize historyButton = _historyButton;
@synthesize lineGraphView = _lineGraphView;
@synthesize segmentedControl = _segmentedControl;
@synthesize lineGraphModelController = _lineGraphModelController;
@synthesize weight = _weight;
@synthesize controlsHidden = _controlsHidden;

- (UIButton *)settingsButton {
    if (!_settingsButton) {
        _settingsButton = [[UIButton alloc] init];
        [_settingsButton setImage:[UIImage imageNamed:@"settings-button"] forState:UIControlStateNormal];
        [_settingsButton addTarget:self action:@selector(showSettings:) forControlEvents:UIControlEventTouchUpInside];
        [_settingsButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [_settingsButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
        [_settingsButton setAdjustsImageWhenHighlighted:NO];
    }
    return _settingsButton;
}


- (WTLBorderButton *)historyButton {
    if (!_historyButton) {
        _historyButton = [[WTLBorderButton alloc] init];
        [_historyButton addTarget:self action:@selector(showHistory:) forControlEvents:UIControlEventTouchUpInside];
        [_historyButton setTitle:@"History" forState:UIControlStateNormal];
    }
    return _historyButton;
}


- (WTLWeightView *)weightView {
    if (!_weightView) {
        _weightView = [[WTLWeightView alloc] initWithFrame:CGRectZero];
        [_weightView.weightButton addTarget:self action:@selector(editWeight:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _weightView;
}


- (BEMSimpleLineGraphView *)lineGraphView {
    if (!_lineGraphView) {
        _lineGraphView = [[BEMSimpleLineGraphView alloc] initWithFrame:CGRectZero];
        _lineGraphView.colorTop = [UIColor wtl_themeColor];
        _lineGraphView.colorBottom = [UIColor wtl_themeColor];
        _lineGraphView.colorLine = [UIColor whiteColor];
        _lineGraphView.widthLine = 2.0;
        _lineGraphView.enableTouchReport = YES;
        _lineGraphView.enablePopUpReport = YES;
        _lineGraphView.enableBezierCurve = YES;
        _lineGraphView.animationGraphStyle = BEMLineAnimationDraw;
        _lineGraphView.dataSource = self.lineGraphModelController;
    }
    return _lineGraphView;
}


- (WTLLineGraphModelController *)lineGraphModelController {
    if (!_lineGraphModelController) {
        _lineGraphModelController = [[WTLLineGraphModelController alloc] init];
        _lineGraphModelController.delegate = self;
    }
    return _lineGraphModelController;
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
    [self updateWeightView];
}


#pragma mark - NSObject

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor wtl_themeColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleControls:)];
    [self.view addGestureRecognizer:tap];
    
    self.navigationController.navigationBarHidden = YES;
    
    [self.view addSubview:self.settingsButton];
    [self.view addSubview:self.historyButton];
    [self.view addSubview:self.lineGraphView];
    [self.view addSubview:self.segmentedControl];
    [self.view addSubview:self.weightView];
    [self setupViewConstraints];
    
    self.weight = [self.lineGraphModelController latestWeight];
    self.segmentedControl.selectedSegmentIndex = WTLLineGraphTimePeriodOneWeek;
    self.lineGraphModelController.timePeriod = WTLLineGraphTimePeriodOneWeek;
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(updateWeightView) name:kWTLUnitsDidChangeNotificationName object:nil];
    [notificationCenter addObserver:self selector:@selector(updateWeightView) name:kWTLHeightDidChangeNotificationName object:nil];
    [notificationCenter addObserver:self selector:@selector(updateAppearance) name:kWTLThemeDidChangeNotificationName object:nil];
    
    [self setControlsHidden:[[NSUserDefaults standardUserDefaults] boolForKey:kWTLControlsHiddenKey] animated:NO];
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


- (void)toggleControls:(id)sender {
    [self setControlsHidden:!self.controlsHidden animated:YES];
}


- (void)showHistory:(id)sender {
    WTLHistoryViewController *viewController = [[WTLHistoryViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}


- (void)editWeight:(id)sender {
    WTLInputViewController *viewController = [[WTLInputViewController alloc] init];
    viewController.modalPresentationStyle = UIModalPresentationCustom;
    viewController.transitioningDelegate = self;
    viewController.delegate = self;
    viewController.validator = [[WTLNumberValidator alloc] initWithMinimumValue:0.0 maximumValue:1500.0];
    
    viewController.suffixString = [[self.weight currentUnitSymbol] uppercaseString];

    float amount = [self.weight amountForCurrentUnit];
    viewController.inputString = amount == 0.0f ? nil : [@(amount) stringValue];
    
    [self presentViewController:viewController animated:YES completion:nil];
}


- (void)showSettings:(id)sender {
    WTLSettingsViewController *viewController = [[WTLSettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}


#pragma mark - Private

- (void)setupViewConstraints {
    [self.settingsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(32.0);
        make.right.equalTo(self.view.mas_right).with.offset(-20.0);
        make.size.mas_equalTo(CGSizeMake(75.0, 75.0));
    }];
    
    [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.greaterThanOrEqualTo(self.view.mas_left).with.offset(20.0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-20.0);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [self.lineGraphView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_centerY).with.offset(30.0);
        make.bottom.equalTo(self.segmentedControl.mas_top);
        make.width.equalTo(self.view.mas_width);
    }];
    
    [self.historyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.lineGraphView.mas_top).with.offset(-20.0);
        make.centerX.equalTo(self.view);
    }];
    
    [self.weightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view).with.offset(10.0);
        make.width.equalTo(self.view);
        make.bottom.equalTo(self.historyButton.mas_top).with.offset(-10.0);
    }];
}


- (void)setControlsHidden:(BOOL)controlsHidden animated:(BOOL)animated {
    UIApplication *application = [UIApplication sharedApplication];

    if (self.controlsHidden == controlsHidden) {
        if (application.statusBarHidden != controlsHidden) {
            [application setStatusBarHidden:controlsHidden withAnimation:animated ? UIStatusBarAnimationFade : UIStatusBarAnimationNone];
        }
        return;
    }
    self.controlsHidden = controlsHidden;

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:controlsHidden forKey:kWTLControlsHiddenKey];
    [userDefaults synchronize];

    void (^animations)(void) = ^{
        self.settingsButton.alpha = controlsHidden ? 0.0 : 1.0;
        self.historyButton.alpha = controlsHidden ? 0.0 : 1.0;
        self.segmentedControl.alpha = controlsHidden ? 0.0 : 1.0;
    };

    if (animated) {
        [application setStatusBarHidden:controlsHidden withAnimation:UIStatusBarAnimationFade];
        [UIView animateWithDuration:0.6 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:1.0 options:UIViewAnimationOptionAllowUserInteraction animations:animations completion:nil];
    } else {
        [application setStatusBarHidden:controlsHidden withAnimation:UIStatusBarAnimationNone];
        animations();
    }
}


- (void)updateWeightView {
    self.weightView.weight = self.weight.amount;
}


- (void)updateAppearance {
    UIColor *themeColor = [UIColor wtl_themeColor];
    self.view.backgroundColor = themeColor;
    self.lineGraphView.colorTop = themeColor;
    self.lineGraphView.colorBottom = themeColor;
    NSDictionary *segmentedControlTextAttributes = @{NSForegroundColorAttributeName : [UIColor wtl_themeColor]};
    [self.segmentedControl setTitleTextAttributes:segmentedControlTextAttributes forState:UIControlStateSelected];
}


#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [[WTLPresentInputTransition alloc] init];
}


- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [[WTLDismissInputTransition alloc] init];
}


#pragma mark - WTLInputViewControllerDelegate

- (void)inputViewController:(WTLInputViewController *)inputViewController didFinishEditingWithText:(NSString *)text {
    NSString *string = text ? text : @"";
    float newValue = strtof([string cStringUsingEncoding:NSASCIIStringEncoding], NULL);
    
    if ([self.weight amountForCurrentUnit] - newValue == 0.0f) {
        return;
    }
    
    [self.weight setAmountWithCurrentUnit:newValue];
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
        [self updateWeightView];
    }
}

@end
