//
//  WTLWeightTableViewCell.h
//  Weightly
//
//  Created by Yiming Tang on 11/8/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//

@import UIKit;

@interface WTLWeightTableViewCell : UITableViewCell

@property (nonatomic, readonly) UILabel *dateLabel;
@property (nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic) BOOL minor;

@end
