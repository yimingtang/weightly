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
#import "WTLUserDefaultsDataSource.h"

@interface WTLSettingsViewController () <UIViewControllerTransitioningDelegate>
@property (nonatomic) NSArray *defaultsKeySections;
@end

@implementation WTLSettingsViewController

static NSString *const cellIdentifier = @"cell";
static NSString *const segmentedCellIdentifier = @"segmentedCell";

#pragma mark - Accessors

- (NSArray *)defaultsKeySections {
    if (!_defaultsKeySections) {
        _defaultsKeySections = @[@[kWTLGenderDefaultsKey, kWTLHeightDefaultsKey, kWTLGoalDefaultsKey, kWTLUnitsDefaultsKey],
                                 @[kWTLThemeDefaultsKey, kWTLReminderDefaultsKey, kWTLAlarmClockDefaultsKey]];
    }
    return _defaultsKeySections;
}


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor colorWithRed:231.0f/255.0f green:76.0f/255.0f blue:60.0f/255.0f alpha:1.0f];
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
    [WTLUserDefaultsDataSource saveUserDefaults];
}


- (void)segmentedControlValueChanged:(WTLSegmentedControl *)segmentedControl {
    // I refuse to use tag because I have to define some constants
    // When the number of controls grows, so does that of tags.
    UITableViewCell *cell = segmentedControl.cell;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSString *key = [self defaultsKeyForRowAtIndexPath:indexPath];
    NSArray *options = [WTLUserDefaultsDataSource objectForInfoKey:kWTLDefaultsInfoOptionsKey fromDefaultsInfoWithDefaultsKey:key];
    [WTLUserDefaultsDataSource setValueObject:[options objectAtIndex:segmentedControl.selectedSegmentIndex] forDefaultsKey:key];
}


#pragma mark - Private Methods

- (void)showViewController:(UIViewController *)viewController animated:(BOOL)aniamted {
    viewController.modalPresentationStyle = UIModalPresentationCustom;
    viewController.transitioningDelegate = self;
    [self presentViewController:viewController animated:aniamted completion:nil];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForUserDefaultsKey:(NSString *)key atIndexPath:(NSIndexPath *)indexPath {
    id valueObject = [WTLUserDefaultsDataSource valueObjectForDefaultsKey:key];
    WTLSettingsTableViewCell *cell;
    
    NSDictionary *infoDictionary = [WTLUserDefaultsDataSource infoDictionaryForDefaultsKey:key];
    WTLDefaultsValueType valueType = [WTLUserDefaultsDataSource valueTypeForDefaultsInfo:infoDictionary];
    
    if (valueType == WTLDefaultsValueTypeOption) {
        WTLSegmentedSettingsTableViewCell *segmentedCell = [tableView dequeueReusableCellWithIdentifier:segmentedCellIdentifier forIndexPath:indexPath];
        
        // Configure segmented control
        NSArray *options = [WTLUserDefaultsDataSource objectForInfoKey:kWTLDefaultsInfoOptionsKey fromDefaultsInfo:infoDictionary];
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
            if ([key isEqualToString:kWTLHeightDefaultsKey]) {
                cell.valueLabel.text = [NSString stringWithFormat:@"%.1f cm", [valueObject floatValue]];
            } else if ([key isEqualToString:kWTLGoalDefaultsKey]) {
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
    NSDictionary *infoDictionary = [WTLUserDefaultsDataSource infoDictionaryForDefaultsKey:defaultsKey];
    WTLDefaultsValueType valueType = [WTLUserDefaultsDataSource valueTypeForDefaultsInfo:infoDictionary];
    
    if (valueType == WTLDefaultsValueTypeTime) {
        // TODO: Set time
    } else if (valueType == WTLDefaultsValueTypeText) {
        if ([defaultsKey isEqualToString:kWTLThemeDefaultsKey]) {
            WTLThemesViewController *viewController = [[WTLThemesViewController alloc] init];
            [self.navigationController pushViewController:viewController animated:YES];
        }
    } else if (valueType == WTLDefaultsValueTypeNumber) {
        WTLInputViewController *inputViewController = [[WTLInputViewController alloc] init];
        inputViewController.initialInput = [NSString stringWithFormat:@"%.1f", [[WTLUserDefaultsDataSource valueObjectForDefaultsKey:defaultsKey] floatValue]];
        if ([defaultsKey isEqualToString:kWTLHeightDefaultsKey]) {
            inputViewController.unitString = @"CM";
        } else if ([defaultsKey isEqualToString:kWTLGoalDefaultsKey]) {
            inputViewController.unitString = @"KG";
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
