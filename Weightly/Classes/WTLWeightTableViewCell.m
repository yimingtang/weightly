//
//  WTLWeightTableViewCell.m
//  Weightly
//
//  Created by Yiming Tang on 11/8/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//

#import "WTLWeightTableViewCell.h"
#import <Masonry.h>

@interface WTLWeightTableViewCell ()

@property (nonatomic) UIView *lineView;
@property (nonatomic) UIView *circleView;

@end


@implementation WTLWeightTableViewCell

@synthesize lineView = _lineView;
@synthesize circleView = _circleView;
@synthesize minor = _minor;

#pragma mark - Accessors

@synthesize titleLabel = _titleLabel;
@synthesize dateLabel = _dateLabel;

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont fontWithName:@"Avenir" size:20.0f];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}


- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.font = [UIFont fontWithName:@"Avenir-Light" size:20.0f];
        _dateLabel.textColor = [UIColor colorWithWhite:1.0f alpha:0.5f];;
        _dateLabel.textAlignment = NSTextAlignmentRight;
    }
    return _dateLabel;
}


- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.4f];
    }
    return _lineView;
}


- (UIView *)circleView {
    if (!_circleView) {
        _circleView = [[UIView alloc] init];
        _circleView.backgroundColor = [UIColor colorWithRed:231.0f/255.0f green:76.0f/255.0f blue:60.0f/255.0f alpha:1.0f];
        _circleView.layer.borderWidth = 1.0f;
        _circleView.layer.cornerRadius = 8.0f;
    }
    return _circleView;
}


- (void)setMinor:(BOOL)minor {
    _minor = minor;
    
    self.titleLabel.textColor = minor ? self.dateLabel.textColor : [UIColor whiteColor];
    self.circleView.layer.borderColor = minor ? [UIColor colorWithWhite:1.0f alpha:0.4f].CGColor : [UIColor colorWithWhite:1.0f alpha:0.75f].CGColor;
}


#pragma mark - UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        self.backgroundColor = [UIColor colorWithRed:231.0f/255.0f green:76.0f/255.0f blue:60.0f/255.0f alpha:0.95f];
        
        [self.contentView addSubview:self.dateLabel];
        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.circleView];
        [self.contentView addSubview:self.titleLabel];
        
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.contentView);
            make.left.equalTo(self.contentView.mas_right).dividedBy(2.618f);
            make.width.equalTo(@2.0f);
        }];
        
        [self.circleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.centerX.equalTo(self.lineView);
            make.size.mas_equalTo(CGSizeMake(16.0f, 16.0f));
        }];
        
        [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.circleView.mas_left).with.offset(-15.0f);
            make.centerY.equalTo(self.contentView);
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.circleView.mas_right).with.offset(15.0f);
        }];
    }
    return self;
}

@end
