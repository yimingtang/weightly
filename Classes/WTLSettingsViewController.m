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
#import "WTLSettingsTableViewCell.h"
#import "WTLSegmentedSettingsTableViewCell.h"

NSString *const kWTLHeightDefaultsKey = @"WTLHeight";
NSString *const kWTLGenderDefaultsKey = @"WTLGender";
NSString *const kWTLGoalDefaultsKey = @"WTLGoal";
NSString *const kWTLUnitsDefaultsKey = @"WTLUnits";
NSString *const kWTLThemeDefaultsKey = @"WTLTheme";
NSString *const kWTLReminderDefaultsKey = @"WTLReminder";
NSString *const kWTLAlarmClockDefaultsKey = @"WTLTime";

@interface WTLSettingsViewController () <UIViewControllerTransitioningDelegate>

@end

@implementation WTLSettingsViewController

static NSString *const cellIdentifier = @"cell";
static NSString *const segmentedCellIdentifier = @"segmentedCell";


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


#pragma mark - Private Methods

- (void)showViewController:(UIViewController *)viewController animated:(BOOL)aniamted {
    viewController.modalPresentationStyle = UIModalPresentationCustom;
    viewController.transitioningDelegate = self;
    [self presentViewController:viewController animated:aniamted completion:nil];
}


- (NSString *)labelStringForDefaultsKey:(NSString *)defaultsKey {
    static NSDictionary *map = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        map = @{
                kWTLHeightDefaultsKey: @"Height",
                kWTLGenderDefaultsKey: @"Gender",
                kWTLGoalDefaultsKey: @"Goal",
                kWTLUnitsDefaultsKey: @"Units",
                kWTLThemeDefaultsKey: @"Theme",
                kWTLReminderDefaultsKey: @"Reminder",
                kWTLAlarmClockDefaultsKey: @"Time",
                };
    });
    
    return [map objectForKey:defaultsKey];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    } else if (section == 1) {
        return 3;
    } else if (section == 2) {
        return 2;
    } else {
        return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    WTLSettingsTableViewCell *cell = nil;
    
    // Profile
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            WTLSegmentedSettingsTableViewCell *segmentedCell = (WTLSegmentedSettingsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:segmentedCellIdentifier forIndexPath:indexPath];
            segmentedCell.titleLabel.text = [self labelStringForDefaultsKey:kWTLGenderDefaultsKey];
            [segmentedCell.segmentedControl insertSegmentWithTitle:@"Male" atIndex:0 animated:NO];
            [segmentedCell.segmentedControl insertSegmentWithTitle:@"Female" atIndex:1 animated:NO];
            segmentedCell.segmentedControl.selectedSegmentIndex = [userDefaults integerForKey:kWTLGenderDefaultsKey] == WTLGenderMale ? 0 : 1;
            cell = segmentedCell;
        } else if (indexPath.row == 1) {
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            cell.titleLabel.text = [self labelStringForDefaultsKey:kWTLHeightDefaultsKey];
            CGFloat height = [userDefaults floatForKey:kWTLHeightDefaultsKey];
            cell.valueLabel.text = [NSString stringWithFormat:@"%.1fcm", height];
        } else if (indexPath.row == 2) {
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            cell.titleLabel.text = [self labelStringForDefaultsKey:kWTLGoalDefaultsKey];;
            CGFloat goal = [userDefaults floatForKey:kWTLGoalDefaultsKey];
            cell.valueLabel.text = [NSString stringWithFormat:@"%.1fkg", goal];
        } else if (indexPath.row == 3) {
            WTLSegmentedSettingsTableViewCell *segmentedCell = (WTLSegmentedSettingsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:segmentedCellIdentifier forIndexPath:indexPath];
            segmentedCell.titleLabel.text = [self labelStringForDefaultsKey:kWTLUnitsDefaultsKey];;
            [segmentedCell.segmentedControl insertSegmentWithTitle:@"Metric" atIndex:0 animated:NO];
            [segmentedCell.segmentedControl insertSegmentWithTitle:@"Imperial" atIndex:1 animated:NO];
            segmentedCell.segmentedControl.selectedSegmentIndex = [userDefaults integerForKey:kWTLUnitsDefaultsKey] == WTLUnitsMetric ? 0 : 1;
            cell = segmentedCell;
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            cell.titleLabel.text = [self labelStringForDefaultsKey:kWTLThemeDefaultsKey];;
            cell.valueLabel.text = [userDefaults stringForKey:kWTLThemeDefaultsKey];
        } else if (indexPath.row == 1) {
            WTLSegmentedSettingsTableViewCell *segmentedCell = (WTLSegmentedSettingsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:segmentedCellIdentifier forIndexPath:indexPath];
            segmentedCell.titleLabel.text = [self labelStringForDefaultsKey:kWTLReminderDefaultsKey];;
            [segmentedCell.segmentedControl insertSegmentWithTitle:@"Off" atIndex:0 animated:NO];
            [segmentedCell.segmentedControl insertSegmentWithTitle:@"On" atIndex:1 animated:NO];
            segmentedCell.segmentedControl.selectedSegmentIndex = [userDefaults boolForKey:kWTLReminderDefaultsKey] ? 1 : 0;
            cell = segmentedCell;
        } else if (indexPath.row == 2) {
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            cell.titleLabel.text = [self labelStringForDefaultsKey:kWTLAlarmClockDefaultsKey];;
            cell.valueLabel.text = @"8:00PM";
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            cell.titleLabel.text = @"Contact Us";
            cell.valueLabel.text = nil;
        } else if (indexPath.row == 1) {
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            cell.titleLabel.text = @"Rate Us";
            cell.valueLabel.text = nil;
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            WTLInputViewController *inputViewController = [[WTLInputViewController alloc] init];
            inputViewController.initialInput = @"173.0";
            inputViewController.unitString = @"CM";
            [self showViewController:inputViewController animated:YES];
        } else if (indexPath.row == 2) {
            WTLInputViewController *inputViewController = [[WTLInputViewController alloc] init];
            inputViewController.initialInput = @"60.0";
            inputViewController.unitString = @"KG";
            [self showViewController:inputViewController animated:YES];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            WTLThemesViewController *viewController = [[WTLThemesViewController alloc] init];
            [self.navigationController pushViewController:viewController animated:YES];
        }
    } else if (indexPath.section == 2) {
        // TODO:
    }
    
    // Deselect it
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [[WTLPresentInputTransition alloc] init];
}


- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [[WTLDismissInputTransition alloc] init];
}

@end
