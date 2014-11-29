//
//  WTLSectionHeaderView.m
//  Weightly
//
//  Created by Yiming Tang on 11/8/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//

#import "WTLSectionHeaderView.h"
#import <Masonry.h>

@interface WTLSectionHeaderView ()
@property (nonatomic) UIView *lineView;
@end

@implementation WTLSectionHeaderView

#pragma mark - Accessors

@synthesize titleLabel = _titleLabel;

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont fontWithName:@"Avenir" size:20.0f];
    }
    return _titleLabel;
}


- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.4f];
    }
    return _lineView;
}


#pragma mark - UITableViewHeaderFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithReuseIdentifier:reuseIdentifier])) {
        UIView *backgroundView = [[UIView alloc] init];
        backgroundView.backgroundColor = [UIColor colorWithRed:231.0f/255.0f green:76.0f/255.0f blue:60.0f/255.0f alpha:0.95f];
        self.backgroundView = backgroundView;
        
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.lineView];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(20.0f);
            make.centerY.equalTo(self.contentView);
        }];
        
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView);
            make.width.equalTo(self.contentView);
            make.height.equalTo(@1);
        }];
    }
    return self;
}

@end
