//
//  WTLSettingsViewController.m
//  Weightly
//
//  Created by Yiming Tang on 11/5/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//

#import "WTLSettingsViewController.h"
#import "WTLInputViewController.h"
#import "WTLThemesViewController.h"
#import "WTLPresentInputTransition.h"
#import "WTLDismissInputTransition.h"
#import "WTLSegmentedSettingsTableViewCell.h"
#import "WTLSegmentedControl.h"
#import "WeightlyKit.h"

static NSString *const cellIdentifier = @"cell";
static NSString *const segmentedCellIdentifier = @"segmentedCell";

@interface WTLSettingsViewController () <UIViewControllerTransitioningDelegate, WTLInputViewControllerDelegate>
@property (nonatomic) NSArray *defaultsKeySections;
@property (nonatomic) WTLPreferences *preferences;
@property (nonatomic) NSIndexPath *selectedIndexPath;
@end

@implementation WTLSettingsViewController

#pragma mark - Accessors

@synthesize defaultsKeySections = _defaultsKeySections;
@synthesize preferences = _preferences;
@synthesize selectedIndexPath = _selectedIndexPath;

- (NSArray *)defaultsKeySections {
    if (!_defaultsKeySections) {
        _defaultsKeySections = @[@[kWTLGenderKey, kWTLHeightKey, kWTLGoalWeightKey, kWTLUnitsKey],
                                 @[kWTLThemeKey, kWTLEnableReminderKey, kWTLReminderTimeKey]];
    }
    return _defaultsKeySections;
}


- (WTLPreferences *)preferences {
    if (!_preferences) {
        _preferences = [WTLPreferences sharedPreferences];
    }
    return _preferences;
}

#pragma mark - NSObject

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 45.0f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[WTLSettingsTableViewCell class] forCellReuseIdentifier:cellIdentifier];
    [self.tableView registerClass:[WTLSegmentedSettingsTableViewCell class] forCellReuseIdentifier:segmentedCellIdentifier];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(done:)];
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    navigationBar.translucent = NO;
    [navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[UIImage imageNamed:@"line"]];
    
    [self updateAppearance];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAppearance) name:kWTLThemeDidChangeNotificationName object:nil];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}


#pragma mark - Actions

- (void)done:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.preferences synchronize];
}


- (void)segmentedControlValueChanged:(WTLSegmentedControl *)segmentedControl {
    // I refuse to use tag because I have to define some constants
    // When the number of controls grows, so does that of tags.
    UITableViewCell *cell = segmentedControl.cell;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSString *key = [self defaultsKeyForRowAtIndexPath:indexPath];
    NSDictionary *info = [self.preferences infoForDefaultsKey:key];
    NSArray *options = [info objectForKey:kWTLDefaultsInfoOptionsKey];
    
    id newOption = [options objectAtIndex:segmentedControl.selectedSegmentIndex];
    [self.preferences setObject:newOption forKey:key];
    
    if ([key isEqualToString:kWTLUnitsKey]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kWTLUnitsDidChangeNotificationName object:newOption];
        [self.tableView reloadData];
    }
}


#pragma mark - Private Methods

- (void)updateAppearance {
    [self.navigationController.navigationBar setBarTintColor:[UIColor wtl_themeColor]];
    self.tableView.backgroundColor = [UIColor wtl_themeColor];
}


- (void)showViewController:(UIViewController *)viewController animated:(BOOL)aniamted {
    viewController.modalPresentationStyle = UIModalPresentationCustom;
    viewController.transitioningDelegate = self;
    [self presentViewController:viewController animated:aniamted completion:nil];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForUserDefaultsKey:(NSString *)key atIndexPath:(NSIndexPath *)indexPath {
    WTLSettingsTableViewCell *cell = nil;
    id valueObject = [self.preferences objectForKey:key];
    
    NSDictionary *infoDictionary = [self.preferences infoForDefaultsKey:key];
    WTLDefaultsValueType valueType = [[infoDictionary objectForKey:kWTLDefaultsInfoValueTypeKey] integerValue];
    
    if (valueType == WTLDefaultsValueTypeOption) {
        WTLSegmentedSettingsTableViewCell *segmentedCell = [tableView dequeueReusableCellWithIdentifier:segmentedCellIdentifier forIndexPath:indexPath];
        
        // Configure segmented control
        NSArray *options = [infoDictionary objectForKey:kWTLDefaultsInfoOptionsKey];
        __block NSUInteger selectedSegmentIndex;
        [options enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [segmentedCell.segmentedControl insertSegmentWithTitle:[infoDictionary objectForKey:obj] atIndex:idx animated:NO];
            if ([valueObject isEqual:obj]) {
                selectedSegmentIndex = idx;
            }
        }];
        segmentedCell.segmentedControl.selectedSegmentIndex = selectedSegmentIndex;
        [segmentedCell.segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        cell = segmentedCell;
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        
        if (valueType == WTLDefaultsValueTypeText) {
            cell.valueLabel.text = valueObject;
        } else if (valueType == WTLDefaultsValueTypeTime) {
            static NSDateFormatter *dateFormatter;
            if (!dateFormatter) {
                dateFormatter = [[NSDateFormatter alloc] init];
                dateFormatter.dateStyle = NSDateFormatterNoStyle;
                dateFormatter.timeStyle = NSDateFormatterShortStyle;
            }
            
            cell.valueLabel.text = [dateFormatter stringFromDate:valueObject];
        } else if (valueType == WTLDefaultsValueTypeNumber) {
            WTLUnitConverter *converter = [WTLUnitConverter sharedConverter];
            if ([key isEqualToString:kWTLHeightKey]) {
                cell.valueLabel.text = [converter targetDisplayStringForMetricLength:[valueObject floatValue]];
            } else if ([key isEqualToString:kWTLGoalWeightKey]) {
                cell.valueLabel.text = [converter targetDisplayStringForMetricMass:[valueObject floatValue]];
            }
        }
    }
    cell.titleLabel.text = [infoDictionary objectForKey:kWTLDefaultsInfoTitleKey];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}


- (NSString *)defaultsKeyForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[self.defaultsKeySections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.defaultsKeySections.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.defaultsKeySections objectAtIndex:section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *defaultsKey = [self defaultsKeyForRowAtIndexPath:indexPath];
    return [self tableView:tableView cellForUserDefaultsKey:defaultsKey atIndexPath:indexPath];
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    self.selectedIndexPath = indexPath;
    
    NSString *defaultsKey = [self defaultsKeyForRowAtIndexPath:indexPath];
    NSDictionary *infoDictionary = [self.preferences infoForDefaultsKey:defaultsKey];
    WTLDefaultsValueType valueType = [[infoDictionary objectForKey:kWTLDefaultsInfoValueTypeKey] integerValue];
    
    if (valueType == WTLDefaultsValueTypeTime) {
        // TODO: Set time
    } else if (valueType == WTLDefaultsValueTypeText) {
        if ([defaultsKey isEqualToString:kWTLThemeKey]) {
            WTLThemesViewController *viewController = [[WTLThemesViewController alloc] init];
            [self.navigationController pushViewController:viewController animated:YES];
        }
    } else if (valueType == WTLDefaultsValueTypeNumber) {
        NSString *suffixString;
        NSString *inputString;
        WTLNumberValidator *validator;
        WTLUnitConverter *unitConverter = [WTLUnitConverter sharedConverter];
        
        if ([defaultsKey isEqualToString:kWTLHeightKey]) {
            suffixString = [[unitConverter targetLengthUnitSymbol] uppercaseString];
            validator = [[WTLNumberValidator alloc] initWithMinimumValue:0.0 maximumValue:300.0];
            float length = [unitConverter targetLengthForMetricLength:[[self.preferences objectForKey:kWTLHeightKey] floatValue]];
            inputString = [@(length) stringValue];
        } else if ([defaultsKey isEqualToString:kWTLGoalWeightKey]) {
            suffixString = [[unitConverter targetMassUnitSymbol] uppercaseString];
            validator = [[WTLNumberValidator alloc] initWithMinimumValue:0.0 maximumValue:1500.0];
            float goalWeight = [unitConverter targetMassForMetricMass:[[self.preferences objectForKey:kWTLGoalWeightKey] floatValue]];
            inputString = [@(goalWeight) stringValue];
        }
        
        WTLInputViewController *inputViewController = [[WTLInputViewController alloc] init];
        inputViewController.validator = validator;
        inputViewController.suffixString = suffixString;
        inputViewController.inputString = inputString;
        inputViewController.delegate = self;
        
        [self showViewController:inputViewController animated:YES];
    }
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = self.tableView.backgroundColor;
}


#pragma mark - WTLInputViewControllerDelegate

- (void)inputViewController:(WTLInputViewController *)inputViewController didFinishEditingWithText:(NSString *)text {
    NSString *string = text ? text : @"";
    float newValue = strtof([string cStringUsingEncoding:NSASCIIStringEncoding], NULL);
    NSString *key = [self defaultsKeyForRowAtIndexPath:self.selectedIndexPath];
    WTLUnitConverter *converter = [WTLUnitConverter sharedConverter];
    
    if ([key isEqualToString:kWTLHeightKey]) {
        NSNumber *newHeight = @([converter metricLengthForTargetLength:newValue]);
        [self.preferences setObject:newHeight forKey:kWTLHeightKey];
        [[NSNotificationCenter defaultCenter] postNotificationName:kWTLHeightDidChangeNotificationName object:newHeight];
    } else if ([key isEqualToString:kWTLGoalWeightKey]) {
        [self.preferences setObject:@([converter metricMassForTagretMass:newValue]) forKey:kWTLGoalWeightKey];
    }
    [self.preferences synchronize];
    
    [self.tableView reloadRowsAtIndexPaths:@[self.selectedIndexPath] withRowAnimation:UITableViewRowAnimationNone];
}


#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [[WTLPresentInputTransition alloc] init];
}


- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [[WTLDismissInputTransition alloc] init];
}

@end
