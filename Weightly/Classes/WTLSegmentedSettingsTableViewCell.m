//
//  WTLSegmentedSettingsTableViewCell.m
//  Weightly
//
//  Created by Yiming Tang on 11/8/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//

#import "WTLSegmentedSettingsTableViewCell.h"
#import "WTLSegmentedControl.h"

#import <Masonry.h>

@implementation WTLSegmentedSettingsTableViewCell

#pragma mark - Accessors

@synthesize segmentedControl = _segmentedControl;

- (WTLSegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        _segmentedControl = [[WTLSegmentedControl alloc] initWithFrame:CGRectZero];
        _segmentedControl.cell = self;
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
            make.right.equalTo(self.contentView).with.offset(-25.0);
        }];
    }
    return self;
}

@end
