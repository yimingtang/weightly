//
//  WTLSectionHeaderView.m
//  Weightly
//
//  Created by Yiming Tang on 11/8/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//

#import "WTLSectionHeaderView.h"
#import "WeightlyKit.h"

#import <Masonry.h>

@interface WTLSectionHeaderView ()
@property (nonatomic) UIView *lineView;
@end

@implementation WTLSectionHeaderView

#pragma mark - Accessors

@synthesize titleLabel = _titleLabel;
@synthesize lineView = _lineView;

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont fontWithName:@"Avenir" size:20.0];
    }
    return _titleLabel;
}


- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.4f];
    }
    return _lineView;
}


#pragma mark - UITableViewHeaderFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithReuseIdentifier:reuseIdentifier])) {
        UIView *backgroundView = [[UIView alloc] init];
        backgroundView.backgroundColor = [[UIColor wtl_themeColor] colorWithAlphaComponent:0.9f];
        self.backgroundView = backgroundView;
        
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.lineView];
        
        [self setupViewConstraints];
    }
    return self;
}


#pragma mark - Private

- (void)setupViewConstraints {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(20.0);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView);
        make.width.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
}

@end
