//
//  WTLSettingsTableViewCell.m
//  Weightly
//
//  Created by Yiming Tang on 11/8/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//

#import "WTLSettingsTableViewCell.h"
#import "UIColor+Weightly.h"

#import <Masonry.h>

CGFloat kWTLSettingsTableViewCellFontSize = 20.0f;

@implementation WTLSettingsTableViewCell

#pragma mark - Accessors

@synthesize titleLabel = _titleLabel;
@synthesize valueLabel = _valueLabel;

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont fontWithName:@"Avenir-Light" size:kWTLSettingsTableViewCellFontSize];
    }
    return _titleLabel;
}


- (UILabel *)valueLabel {
    if (!_valueLabel) {
        _valueLabel = [[UILabel alloc] init];
        _valueLabel.textColor = [UIColor whiteColor];
        _valueLabel.font = [UIFont fontWithName:@"Avenir" size:kWTLSettingsTableViewCellFontSize];
    }
    return _valueLabel;
}


#pragma mark - UITableViewcell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        self.backgroundColor = [UIColor wtl_redColor];
        
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.valueLabel];
        [self setupViewConstraints];
    }
    return self;
}


- (void)setupViewConstraints {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(25.0);
        make.centerY.equalTo(self.contentView);
    }];
    [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).with.offset(-25.0);
        make.centerY.equalTo(self.contentView);
    }];
}

@end
