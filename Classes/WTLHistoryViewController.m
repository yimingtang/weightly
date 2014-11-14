//
//  WTLHistoryViewController.m
//  Weightly
//
//  Created by Yiming Tang on 11/5/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//

#import "WTLHistoryViewController.h"
#import "WTLWeightTableViewCell.h"
#import "WTLSectionHeaderView.h"
#import "WTLWeight.h"

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
    cell.dateLabel.text = [dateFormatter stringFromDate:weight.timeStamp];
    cell.titleLabel.text = [NSString stringWithFormat:@"%.1fkg", weight.amount];
}


#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WTLWeightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    
    static NSDateFormatter *formatter = nil;
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setCalendar:[NSCalendar currentCalendar]];
        NSString *formatTemplate = [NSDateFormatter dateFormatFromTemplate:@"MMMM YYYY" options:0 locale:[NSLocale currentLocale]];
        [formatter setDateFormat:formatTemplate];
    }
    NSInteger numericSection = [[sectionInfo name] integerValue];
    NSInteger year = numericSection / 1000;
    NSInteger month = numericSection - (year * 1000);
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year = year;
    dateComponents.month = month;
    NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
    
    NSString *titleString = [formatter stringFromDate:date];
    
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

@end
