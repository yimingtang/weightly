//
//  WTLSegmentedSettingsTableViewCell.h
//  Weightly
//
//  Created by Yiming Tang on 11/8/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//

#import "WTLSettingsTableViewCell.h"

@class WTLSegmentedControl;

@interface WTLSegmentedSettingsTableViewCell : WTLSettingsTableViewCell

@property (nonatomic, readonly) WTLSegmentedControl *segmentedControl;

@end
