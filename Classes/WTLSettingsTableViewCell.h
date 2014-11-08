//
//  WTLSettingsTableViewCell.h
//  Weightly
//
//  Created by Yiming Tang on 11/8/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGFloat kWTLSettingsTableViewCellFontSize;

@interface WTLSettingsTableViewCell : UITableViewCell

@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UILabel *valueLabel;

@end
