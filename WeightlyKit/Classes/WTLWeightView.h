//
//  WTLWeightView.h
//  Weightly
//
//  Created by Yiming Tang on 11/30/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//

@import UIKit;

@interface WTLWeightView : UIView

@property (nonatomic) CGFloat weight;
@property (nonatomic, readonly) UIButton *weightButton;
@property (nonatomic, readonly) UILabel *bmiLabel;

- (CGFloat)verticalSpacing;
- (NSDictionary *)weightAttributes;
- (NSDictionary *)symbolAttributes;

- (void)setupViews;
- (void)setupConstraints;

@end
