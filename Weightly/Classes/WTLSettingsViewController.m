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
#import "WTLDefines.h"
#import "WTLPreferences.h"
#import "UIColor+Weightly.h"

@interface WTLSettingsViewController () <UIViewControllerTransitioningDelegate>
@property (nonatomic) NSArray *defaultsKeySections;
@property (nonatomic) WTLPreferences *preferences;
@end

@implementation WTLSettingsViewController

static NSString *const cellIdentifier = @"cell";
static NSString *const segmentedCellIdentifier = @"segmentedCell";

#pragma mark - Accessors

@synthesize defaultsKeySections = _defaultsKeySections;
@synthesize preferences = _preferences;

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


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor wtl_redColor];
    self.tableView.rowHeight = 45.0f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[WTLSettingsTableViewCell class] forCellReuseIdentifier:cellIdentifier];
    [self.tableView registerClass:[WTLSegmentedSettingsTableViewCell class] forCellReuseIdentifier:segmentedCellIdentifier];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(done:)];
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    navigationBar.translucent = NO;
    [navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[[UIImage alloc] init]];
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
    
    [self.preferences setObject:[options objectAtIndex:segmentedControl.selectedSegmentIndex] forKey:key];
}


#pragma mark - Private Methods

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
            if ([key isEqualToString:kWTLHeightKey]) {
                cell.valueLabel.text = [NSString stringWithFormat:@"%.1f cm", [valueObject floatValue]];
            } else if ([key isEqualToString:kWTLGoalWeightKey]) {
                cell.valueLabel.text = [NSString stringWithFormat:@"%.1f kg", [valueObject floatValue]];
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
        WTLInputViewController *inputViewController = [[WTLInputViewController alloc] init];
        inputViewController.inputString = [NSString stringWithFormat:@"%.1f", [[self.preferences objectForKey:defaultsKey] floatValue]];
        if ([defaultsKey isEqualToString:kWTLHeightKey]) {
            inputViewController.suffixString = @"CM";
        } else if ([defaultsKey isEqualToString:kWTLGoalWeightKey]) {
            inputViewController.suffixString = @"KG";
        }
        [self showViewController:inputViewController animated:YES];
    }
}


#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [[WTLPresentInputTransition alloc] init];
}


- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [[WTLDismissInputTransition alloc] init];
}

@end
