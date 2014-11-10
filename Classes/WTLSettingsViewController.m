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

@interface WTLSettingsViewController () <UIViewControllerTransitioningDelegate>

@end

@implementation WTLSettingsViewController

static NSString *const cellIdentifier = @"cell";
static NSString *const segmentedCellIdentifier = @"segmentedCell";


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:231.0f/255.0f green:76.0f/255.0f blue:60.0f/255.0f alpha:1.0f];
    
    self.tableView.rowHeight = 45.0f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[WTLSettingsTableViewCell class] forCellReuseIdentifier:cellIdentifier];
    [self.tableView registerClass:[WTLSegmentedSettingsTableViewCell class] forCellReuseIdentifier:segmentedCellIdentifier];
    
    UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectZero];
    doneButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Light" size:16.0f];
    [doneButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.8f] forState:UIControlStateHighlighted];
    [doneButton addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    doneButton.contentEdgeInsets = UIEdgeInsetsMake(8.0f, 10.0f, 8.0f, 10.0f);
    doneButton.layer.cornerRadius = 4.0f;
    doneButton.layer.borderColor = [[UIColor colorWithWhite:1.0f alpha:0.5f] CGColor];
    doneButton.layer.borderWidth = 1.0f;
    [doneButton sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}


#pragma mark - Actions

- (void)done:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Private Methods

- (void)showViewController:(UIViewController *)viewController animated:(BOOL)aniamted {
    viewController.modalPresentationStyle = UIModalPresentationCustom;
    viewController.transitioningDelegate = self;
    [self presentViewController:viewController animated:aniamted completion:nil];
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
    
    WTLSettingsTableViewCell *cell = nil;
    
    // Profile
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            WTLSegmentedSettingsTableViewCell *segmentedCell = (WTLSegmentedSettingsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:segmentedCellIdentifier forIndexPath:indexPath];
            segmentedCell.titleLabel.text = @"Gender";
            [segmentedCell.segmentedControl insertSegmentWithTitle:@"Male" atIndex:0 animated:NO];
            [segmentedCell.segmentedControl insertSegmentWithTitle:@"Female" atIndex:1 animated:NO];
            segmentedCell.segmentedControl.selectedSegmentIndex = 0;
            cell = segmentedCell;
        } else if (indexPath.row == 1) {
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            cell.titleLabel.text = @"Height";
            cell.valueLabel.text = @"173cm";
        } else if (indexPath.row == 2) {
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            cell.titleLabel.text = @"Goal";
            cell.valueLabel.text = @"60.0kg";
        } else if (indexPath.row == 3) {
            WTLSegmentedSettingsTableViewCell *segmentedCell = (WTLSegmentedSettingsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:segmentedCellIdentifier forIndexPath:indexPath];
            segmentedCell.titleLabel.text = @"Unit";
            [segmentedCell.segmentedControl insertSegmentWithTitle:@"Metric" atIndex:0 animated:NO];
            [segmentedCell.segmentedControl insertSegmentWithTitle:@"Imperial" atIndex:1 animated:NO];
            segmentedCell.segmentedControl.selectedSegmentIndex = 0;
            cell = segmentedCell;
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            cell.titleLabel.text = @"Theme";
            cell.valueLabel.text = @"Cinnabar";
        } else if (indexPath.row == 1) {
            WTLSegmentedSettingsTableViewCell *segmentedCell = (WTLSegmentedSettingsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:segmentedCellIdentifier forIndexPath:indexPath];
            segmentedCell.titleLabel.text = @"Reminder";
            [segmentedCell.segmentedControl insertSegmentWithTitle:@"Off" atIndex:0 animated:NO];
            [segmentedCell.segmentedControl insertSegmentWithTitle:@"On" atIndex:1 animated:NO];
            segmentedCell.segmentedControl.selectedSegmentIndex = 0;
            cell = segmentedCell;
        } else if (indexPath.row == 2) {
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            cell.titleLabel.text = @"Time";
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = tableView.backgroundColor;
}


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
