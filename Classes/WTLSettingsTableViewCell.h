//
//  WTLSettingsTableViewCell.h
//  Weightly
//
//  Created by Yiming Tang on 11/8/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//

@import UIKit;

extern CGFloat kWTLSettingsTableViewCellFontSize;

@interface WTLSettingsTableViewCell : UITableViewCell

@property (nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic, readonly) UILabel *valueLabel;

@end
