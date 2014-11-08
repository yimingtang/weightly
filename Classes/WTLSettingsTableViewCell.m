//
//  WTLSettingsTableViewCell.m
//  Weightly
//
//  Created by Yiming Tang on 11/8/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//

#import "WTLSettingsTableViewCell.h"
#import <Masonry.h>

CGFloat kWTLSettingsTableViewCellFontSize = 22.0f;

@implementation WTLSettingsTableViewCell

#pragma mark - Accessors

@synthesize titleLabel = _titleLabel;
@synthesize valueLabel = _valueLabel;

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont fontWithName:@"Avenir-Light" size:kWTLSettingsTableViewCellFontSize];
    }
    return _titleLabel;
}


- (UILabel *)valueLabel {
    if (!_valueLabel) {
        _valueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _valueLabel.textColor = [UIColor whiteColor];
        _valueLabel.font = [UIFont fontWithName:@"Avenir-Light" size:kWTLSettingsTableViewCellFontSize];
    }
    return _valueLabel;
}


#pragma mark - UITableViewcell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.valueLabel];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(25.0f);
            make.centerY.equalTo(self.contentView);
        }];
        [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).with.offset(-25.0f);
            make.centerY.equalTo(self.contentView);
        }];
    }
    return self;
}

@end
