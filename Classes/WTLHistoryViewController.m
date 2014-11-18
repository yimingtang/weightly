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
#import "WTLWeight.h"

@interface WTLHistoryViewController () <UIViewControllerTransitioningDelegate, WTLInputViewControllerDelegate>

@property (nonatomic) NSIndexPath *selectedIndexPath;

@end

@implementation WTLHistoryViewController

static NSString *const cellReuseIdentifier = @"cell";
static NSString *const sectionHeaderReuseIdentifier = @"sectionHeader";

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"line"]];
    self.navigationItem.title = @"All Records";
    
    self.useChangeAnimations = NO;
    
    self.tableView.backgroundColor = [UIColor colorWithRed:231.0f/255.0f green:76.0f/255.0f blue:60.0f/255.0f alpha:1.0f];
    self.tableView.rowHeight = 50.0f;
    self.tableView.sectionHeaderHeight = 45.0f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[WTLWeightTableViewCell class] forCellReuseIdentifier:cellReuseIdentifier];
    [self.tableView registerClass:[WTLSectionHeaderView class] forHeaderFooterViewReuseIdentifier:sectionHeaderReuseIdentifier];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}


#pragma mark - SSManagedViewController

- (Class)entityClass {
    return [WTLWeight class];
}


- (NSString *)sectionNameKeyPath {
    return @"sectionIdentifier";
}


- (NSString *)cacheName {
    return nil;
}


#pragma mark - SSManagedTableViewController

- (void)configureCell:(WTLWeightTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setCalendar:[NSCalendar currentCalendar]];
        [dateFormatter setDateFormat:@"dd"];
    });
    
    WTLWeight *weight = [self objectForViewIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dateLabel.text = [dateFormatter stringFromDate:weight.timeStamp];
    cell.titleLabel.text = [NSString stringWithFormat:@"%.1fkg", weight.amount];
    cell.minor = !weight.userGenerated;
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
    
    WTLSectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"sectionHeader"];
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
    inputViewController.initialInput = [NSString stringWithFormat:@"%.1f", weight.amount];
    inputViewController.unitString = @"KG";
    inputViewController.modalPresentationStyle = UIModalPresentationCustom;
    inputViewController.transitioningDelegate = self;
    inputViewController.delegate = self;
    [self presentViewController:inputViewController animated:YES completion:nil];
}


#pragma mark - WTLInputViewControllerDelegate

- (void)inputViewController:(WTLInputViewController *)inputViewController didFinishEditingWithResult:(NSString *)result {
    WTLWeight *weight = [self objectForViewIndexPath:self.selectedIndexPath];
    CGFloat newAmount = [result floatValue];
    if (weight.amount == newAmount) {
        return;
    }
    
    weight.amount = newAmount;
    weight.userGenerated = YES;
    
    NSArray *allObjects = self.fetchedResultsController.fetchedObjects;
    
    NSPredicate *lowerPredicate = [NSPredicate predicateWithFormat:@"timeStamp < %@", weight.timeStamp];
    NSArray *lowerObjects = [allObjects filteredArrayUsingPredicate:lowerPredicate];
    __block NSUInteger lowerBound = lowerObjects.count;
    [lowerObjects enumerateObjectsUsingBlock:^(WTLWeight *obj, NSUInteger idx, BOOL *stop) {
        if (obj.userGenerated) {
            lowerBound = idx;
            *stop = YES;
        }
    }];
    
    CGFloat offset = 0;
    if (lowerBound == lowerObjects.count) {
        offset = 0;
        lowerBound = lowerObjects.count - 1;
    } else {
        WTLWeight *lowerBoundWeight = [lowerObjects objectAtIndex:lowerBound];
        offset = (lowerBoundWeight.amount - weight.amount) / (lowerBound + 1);
    }
    
    self.ignoreChange = YES;
    [lowerObjects enumerateObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, lowerBound + 1)] options:kNilOptions usingBlock:^(WTLWeight *obj, NSUInteger idx, BOOL *stop) {
        obj.amount = weight.amount + offset * (idx + 1);
    }];
    
    NSPredicate *higherPredicate = [NSPredicate predicateWithFormat:@"timeStamp > %@", weight.timeStamp];
    NSArray *higherObjects = [allObjects filteredArrayUsingPredicate:higherPredicate];
    
    __block NSUInteger higherBound = -1;
    [higherObjects enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(WTLWeight *obj, NSUInteger idx, BOOL *stop) {
        if (obj.userGenerated) {
            higherBound = idx;
            *stop = YES;
        }
    }];
    
    if (higherBound == -1) {
        offset = 0;
        higherBound = 0;
    } else {
        WTLWeight *higherBoundWeight = [higherObjects objectAtIndex:higherBound];
        offset = (higherBoundWeight.amount - weight.amount) / (higherObjects.count - higherBound);
    }
    
    [higherObjects enumerateObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(higherBound, higherObjects.count - higherBound)] options:kNilOptions usingBlock:^(WTLWeight *obj, NSUInteger idx, BOOL *stop) {
        obj.amount = weight.amount + offset * (higherObjects.count - idx);
    }];
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
