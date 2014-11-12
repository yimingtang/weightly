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

NSString *const kWTLHeightDefaultsKey = @"WTLHeight";
NSString *const kWTLGenderDefaultsKey = @"WTLGender";
NSString *const kWTLGoalDefaultsKey = @"WTLGoal";
NSString *const kWTLUnitsDefaultsKey = @"WTLUnits";
NSString *const kWTLThemeDefaultsKey = @"WTLTheme";
NSString *const kWTLReminderDefaultsKey = @"WTLReminder";
NSString *const kWTLAlarmClockDefaultsKey = @"WTLTime";

typedef NS_ENUM(NSUInteger, WTLDefaultsValueType) {
    WTLDefaultsValueTypeNumber,
    WTLDefaultsValueTypeTime,
    WTLDefaultsValueTypeOption,
    WTLDefaultsValueTypeText,
};

@interface WTLSettingsViewController () <UIViewControllerTransitioningDelegate>

@property (nonatomic) NSArray *defaultsKeySections;

@end

@implementation WTLSettingsViewController

static NSString *const cellIdentifier = @"cell";
static NSString *const segmentedCellIdentifier = @"segmentedCell";
static NSString *const kWTLDefaultsTitleKey = @"label";
static NSString *const kWTLDefaultsValueTypeKey = @"type";
static NSString *const kWTLDefaultsOptionsKey = @"options";

#pragma mark - Class Methods

+ (NSDictionary *)valueMap {
    static NSDictionary *map = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        map = @{
                kWTLHeightDefaultsKey: @{kWTLDefaultsTitleKey: @"Height",
                                         kWTLDefaultsValueTypeKey: @(WTLDefaultsValueTypeNumber)},
                kWTLGenderDefaultsKey: @{kWTLDefaultsTitleKey: @"Gender",
                                         kWTLDefaultsValueTypeKey: @(WTLDefaultsValueTypeOption),
                                         kWTLDefaultsOptionsKey: @[@(WTLGenderMale), @(WTLGenderFemale)],
                                         @(WTLGenderMale): @"Male",
                                         @(WTLGenderFemale): @"Female"},
                kWTLGoalDefaultsKey: @{kWTLDefaultsTitleKey: @"Goal",
                                       kWTLDefaultsValueTypeKey: @(WTLDefaultsValueTypeNumber)},
                kWTLUnitsDefaultsKey: @{kWTLDefaultsTitleKey: @"Units",
                                        kWTLDefaultsValueTypeKey: @(WTLDefaultsValueTypeOption),
                                        kWTLDefaultsOptionsKey: @[@(WTLUnitsImperial), @(WTLUnitsMetric)],
                                        @(WTLUnitsMetric): @"Metric",
                                        @(WTLUnitsImperial): @"Imperial"},
                kWTLThemeDefaultsKey: @{kWTLDefaultsTitleKey: @"Theme",
                                        kWTLDefaultsValueTypeKey: @(WTLDefaultsValueTypeText)},
                kWTLReminderDefaultsKey: @{kWTLDefaultsTitleKey: @"Reminder",
                                           kWTLDefaultsValueTypeKey: @(WTLDefaultsValueTypeOption),
                                           kWTLDefaultsOptionsKey: @[@(NO), @(YES)],
                                           @(NO): @"Off",
                                           @(YES): @"On"},
                kWTLAlarmClockDefaultsKey: @{kWTLDefaultsTitleKey: @"Time",
                                             kWTLDefaultsValueTypeKey: @(WTLDefaultsValueTypeTime)},
                };
    });
    return map;
}


+ (NSDictionary *)infoDictionaryForDefaultsKey:(NSString *)key {
    return [[self valueMap] objectForKey:key];
}


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
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)segmentedControlValueChanged:(UISegmentedControl *)sender {

}


#pragma mark - Private Methods

- (void)showViewController:(UIViewController *)viewController animated:(BOOL)aniamted {
    viewController.modalPresentationStyle = UIModalPresentationCustom;
    viewController.transitioningDelegate = self;
    [self presentViewController:viewController animated:aniamted completion:nil];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForUserDefaultsKey:(NSString *)key atIndexPath:(NSIndexPath *)indexPath {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    id valueObject = [userDefaults objectForKey:key];
    WTLSettingsTableViewCell *cell;
    
    NSDictionary *infoDictionary = [[self class] infoDictionaryForDefaultsKey:key];
    WTLDefaultsValueType valueType = [[infoDictionary objectForKey:kWTLDefaultsValueTypeKey] integerValue];
    if (valueType == WTLDefaultsValueTypeOption) {
        WTLSegmentedSettingsTableViewCell *segmentedCell = [tableView dequeueReusableCellWithIdentifier:segmentedCellIdentifier forIndexPath:indexPath];
        
        // Configure segmented control
        NSArray *options = [infoDictionary objectForKey:kWTLDefaultsOptionsKey];
        __block NSUInteger selectedSegmentIndex;
        
        [options enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [segmentedCell.segmentedControl insertSegmentWithTitle:[infoDictionary objectForKey:obj] atIndex:idx animated:NO];
            if ([valueObject isEqual:obj]) {
                selectedSegmentIndex = idx;
            }
        }];
        segmentedCell.segmentedControl.selectedSegmentIndex = selectedSegmentIndex;
        
        cell = segmentedCell;
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        
        if (valueType == WTLDefaultsValueTypeText) {
            cell.valueLabel.text = valueObject;
        } else if (valueType == WTLDefaultsValueTypeTime) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateStyle = NSDateFormatterNoStyle;
            dateFormatter.timeStyle = NSDateFormatterShortStyle;
            cell.valueLabel.text = [dateFormatter stringFromDate:valueObject];
        } else if (valueType == WTLDefaultsValueTypeNumber) {
            if ([key isEqualToString:kWTLHeightDefaultsKey]) {
                cell.valueLabel.text = [NSString stringWithFormat:@"%.1f cm", [valueObject floatValue]];
            } else if ([key isEqualToString:kWTLGoalDefaultsKey]) {
                cell.valueLabel.text = [NSString stringWithFormat:@"%.1f kg", [valueObject floatValue]];
            }
        }
    }
    cell.titleLabel.text = [infoDictionary objectForKey:kWTLDefaultsTitleKey];
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
    NSDictionary *infoDictionary = [[self class] infoDictionaryForDefaultsKey:defaultsKey];
    WTLDefaultsValueType valueType = [[infoDictionary objectForKey:kWTLDefaultsValueTypeKey] integerValue];
    if (valueType == WTLDefaultsValueTypeTime) {
        // TODO: Set time
    } else if (valueType == WTLDefaultsValueTypeText) {
        if ([defaultsKey isEqualToString:kWTLThemeDefaultsKey]) {
            WTLThemesViewController *viewController = [[WTLThemesViewController alloc] init];
            [self.navigationController pushViewController:viewController animated:YES];
        }
    } else if (valueType == WTLDefaultsValueTypeNumber) {
        WTLInputViewController *inputViewController = [[WTLInputViewController alloc] init];
        inputViewController.initialInput = [NSString stringWithFormat:@"%.1f", [[[NSUserDefaults standardUserDefaults] objectForKey:defaultsKey] floatValue]];
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
