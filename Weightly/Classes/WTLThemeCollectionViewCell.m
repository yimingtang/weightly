//
//  WTLThemeCollectionViewCell.m
//  Weightly
//
//  Created by Yiming Tang on 11/9/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//

#import "WTLThemeCollectionViewCell.h"

#import <Masonry.h>

@interface WTLThemeCollectionViewCell ()
@property (nonatomic) UIImageView *checkmarkImageView;
@end

@implementation WTLThemeCollectionViewCell

#pragma mark - Accessors

@synthesize titleLabel = _titleLabel;
@synthesize weightLabel = _weightLabel;
@synthesize bmiLabel = _bmiLabel;
@synthesize checkmarkImageView = _checkmarkImageView;

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont fontWithName:@"Avenir-Light" size:18.0];
    }
    return _titleLabel;
}


- (UILabel *)weightLabel {
    if (!_weightLabel) {
        _weightLabel = [[UILabel alloc] init];
        _weightLabel.textColor = [UIColor whiteColor];
        _weightLabel.font = [UIFont fontWithName:@"Avenir" size:42.0];
    }
    return _weightLabel;
}


- (UILabel *)bmiLabel {
    if (!_bmiLabel) {
        _bmiLabel = [[UILabel alloc] init];
        _bmiLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.5f];
        _bmiLabel.font = [UIFont fontWithName:@"Avenir-Light" size:12.0];
    }
    return _bmiLabel;
}


- (UIImageView *)checkmarkImageView {
    if (!_checkmarkImageView) {
        _checkmarkImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check-mark"]];
        _checkmarkImageView.hidden = YES;
    }
    return _checkmarkImageView;
}


#pragma mark - UIView

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self.contentView addSubview:self.weightLabel];
        [self.contentView addSubview:self.bmiLabel];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.checkmarkImageView];
        
        [self setupViewConstraints];
    }
    return self;
}


- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    self.checkmarkImageView.hidden = !selected;
}


#pragma mark - Private

- (void)setupViewConstraints {
    [self.bmiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView.mas_centerY);
    }];
    
    [self.weightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.bottom.equalTo(self.bmiLabel.mas_top);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView.mas_bottom).multipliedBy(0.75f);
    }];
    
    [self.checkmarkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(12.0);
        make.right.equalTo(self.contentView).with.offset(-12.0);
    }];
}

@end
