//
//  WTLSegmentedSettingsTableViewCell.m
//  Weightly
//
//  Created by Yiming Tang on 11/8/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//

#import "WTLSegmentedSettingsTableViewCell.h"
#import <Masonry.h>

@implementation WTLSegmentedSettingsTableViewCell

#pragma mark - Accessors

@synthesize segmentedControl = _segmentedControl;

- (UISegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        _segmentedControl = [[UISegmentedControl alloc] initWithFrame:CGRectZero];
        // Remove borders and highlighted background
        [_segmentedControl setTintColor:[UIColor clearColor]];
        [_segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithWhite:1.0f alpha:0.5f],
                                                    NSFontAttributeName : [UIFont fontWithName:@"Avenir-Light" size:kWTLSettingsTableViewCellFontSize]
                                                    }
                                         forState:UIControlStateNormal];
        [_segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}
                                         forState:UIControlStateSelected];
    }
    return _segmentedControl;
}


#pragma mark - UITableViewCell

- (void)prepareForReuse {
    [self.segmentedControl removeAllSegments];
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        [self.contentView addSubview:self.segmentedControl];
        [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).with.offset(-25.0f);
        }];
    }
    return self;
}

@end
