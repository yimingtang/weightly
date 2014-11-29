//
//  WTLTodayViewController.m
//  Weightly Today
//
//  Created by Yiming Tang on 11/29/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//

#import "WTLTodayViewController.h"

@import NotificationCenter;


@interface WTLTodayViewController () <NCWidgetProviding>

@end

@implementation WTLTodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

@end
