//
//  WTLHistoryViewController.m
//  Weightly
//
//  Created by Yiming Tang on 11/5/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//

#import "WTLHistoryViewController.h"
#import "WTLInputViewController.h"
#import "WTLWeightTableViewCell.h"
#import "WTLSectionHeaderView.h"
#import "WTLPresentInputTransition.h"
#import "WTLDismissInputTransition.h"
#import "WTLUnitConverter.h"
#import "WTLWeight.h"
#import "WTLNumberValidator.h"
#import "WTLDayNumberFormatter.h"
#import "UIColor+Weightly.h"

@interface WTLHistoryViewController () <UIViewControllerTransitioningDelegate, WTLInputViewControllerDelegate>
@property (nonatomic) NSIndexPath *selectedIndexPath;
@end

@implementation WTLHistoryViewController

static NSString *const cellReuseIdentifier = @"cell";
static NSString *const sectionHeaderReuseIdentifier = @"sectionHeader";

#pragma mark - Accessors

@synthesize selectedIndexPath = _selectedIndexPath;


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"line"]];
    self.navigationItem.title = @"History";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(done:)];
    
    self.useChangeAnimations = NO;
    
    self.tableView.backgroundColor = [UIColor wtl_redColor];
    self.tableView.rowHeight = 50.0;
    self.tableView.sectionHeaderHeight = 45.0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[WTLWeightTableViewCell class] forCellReuseIdentifier:cellReuseIdentifier];
    [self.tableView registerClass:[WTLSectionHeaderView class] forHeaderFooterViewReuseIdentifier:sectionHeaderReuseIdentifier];
}


#pragma mark - SSManagedViewController

- (Class)entityClass {
    return [WTLWeight class];
}


- (NSString *)sectionNameKeyPath {
    return @"sectionIdentifier";
}


#pragma mark - SSManagedTableViewController

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    static WTLDayNumberFormatter *dayNumberFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dayNumberFormatter = [[WTLDayNumberFormatter alloc] init];
    });
    
    WTLWeightTableViewCell *weightCell = (WTLWeightTableViewCell *)cell;
    WTLWeight *weight = [self objectForViewIndexPath:indexPath];
    weightCell.selectionStyle = UITableViewCellSelectionStyleNone;
    weightCell.titleLabel.text = [[WTLUnitConverter sharedConverter] targetDisplayStringForMetricMass:weight.amount];
    weightCell.minor = !weight.userGenerated;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger day = [calendar component:NSCalendarUnitDay fromDate:weight.timeStamp];
    weightCell.dateLabel.text = [dayNumberFormatter stringFromNumber:@(day)];
}


#pragma mark - Actions

- (void)done:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WTLWeightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setCalendar:[NSCalendar currentCalendar]];
        NSString *formatTemplate = [NSDateFormatter dateFormatFromTemplate:@"MMMM YYYY" options:kNilOptions locale:[NSLocale currentLocale]];
        [dateFormatter setDateFormat:formatTemplate];
    });
    
    NSInteger numericSection = [[sectionInfo name] integerValue];
    NSInteger year = numericSection / 1000;
    NSInteger month = numericSection - (year * 1000);
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year = year;
    dateComponents.month = month;
    NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
    
    NSString *titleString = [dateFormatter stringFromDate:date];
    
    WTLSectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:sectionHeaderReuseIdentifier];
    headerView.titleLabel.text = [titleString uppercaseString];
    
    return headerView;
}


/* 
 * Override.
 * Do not show defualt section header.
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // Override
    return nil;
}


/*
 * Override.
 * Remove section indexes.
 */
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return nil;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    self.selectedIndexPath = indexPath;
    WTLWeight *weight = [self objectForViewIndexPath:indexPath];
    
    WTLInputViewController *inputViewController = [[WTLInputViewController alloc] init];
    inputViewController.modalPresentationStyle = UIModalPresentationCustom;
    inputViewController.transitioningDelegate = self;
    inputViewController.inputString = [@(weight.amount) stringValue];
    inputViewController.suffixString = [[[WTLUnitConverter sharedConverter] targetMassUnitSymbol] uppercaseString];
    inputViewController.delegate = self;
    inputViewController.validator = [[WTLNumberValidator alloc] initWithMinimumValue:0.0 maximumValue:1500.0];
    [self presentViewController:inputViewController animated:YES completion:nil];
}


#pragma mark - WTLInputViewControllerDelegate

- (void)inputViewController:(WTLInputViewController *)inputViewController didFinishEditingWithText:(NSString *)text {
    WTLWeight *weight = [self objectForViewIndexPath:self.selectedIndexPath];
    NSString *string = text ? text : @"";
    
    CGFloat newAmount = strtof([string cStringUsingEncoding:NSASCIIStringEncoding], NULL);
    if (weight.amount - newAmount == 0.0) {
        return;
    }
    
    weight.amount = newAmount;
    weight.userGenerated = YES;
    
    self.ignoreChange = YES;
    [WTLWeight updateAutoGeneratedWeightsWithWeight:weight];
    self.ignoreChange = NO;
}


#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [[WTLPresentInputTransition alloc] init];
}


- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [[WTLDismissInputTransition alloc] init];
}

@end
