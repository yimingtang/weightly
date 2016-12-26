//
//  WTLWeightView.m
//  Weightly
//
//  Created by Yiming Tang on 11/30/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//

#import "WTLWeightView.h"
#import "WTLUnitConverter.h"
#import "WTLBMICalculator.h"
#import "WTLPreferences.h"
#import <Masonry/Masonry.h>

@implementation WTLWeightView

#pragma mark - Accessors

@synthesize weightButton = _weightButton;
@synthesize bmiLabel = _bmiLabel;
@synthesize weight = _weight;

- (UIButton *)weightButton {
    if (!_weightButton) {
        _weightButton = [[UIButton alloc] init];
        _weightButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _weightButton.clipsToBounds = YES;
    }
    return _weightButton;
}


- (UILabel *)bmiLabel {
    if (!_bmiLabel) {
        _bmiLabel = [[UILabel alloc] init];
        _bmiLabel.numberOfLines = 2;
        _bmiLabel.textAlignment = NSTextAlignmentCenter;
        _bmiLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.5f];
        _bmiLabel.font = [UIFont fontWithName:@"Avenir-Light" size:16.0];
    }
    return _bmiLabel;
}


- (void)setWeight:(CGFloat)weight {
    _weight = weight;
    
    WTLUnitConverter *unitConverter = [WTLUnitConverter sharedConverter];
    // Set the latest units type
    WTLPreferences *preferences = [WTLPreferences sharedPreferences];
    unitConverter.targetUnitsType = [[preferences objectForKey:kWTLUnitsKey] integerValue];
    
    NSString *symbolString = [unitConverter targetMassUnitSymbol];
    NSString *fullString = [[unitConverter targetDisplayStringForMetricMass:weight] uppercaseString];
    // `1` for space
    NSRange symbolRange = NSMakeRange(fullString.length - symbolString.length - 1, symbolString.length + 1);
    
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:fullString attributes:[self weightAttributes]];
    [mutableAttributedString addAttributes:[self symbolAttributes] range:symbolRange];
    [self.weightButton setAttributedTitle:mutableAttributedString forState:UIControlStateNormal];
    
    float height = [[preferences objectForKey:kWTLHeightKey] floatValue];
    NSString *bmiDescription = [WTLBMICalculator fullBMIDescriptionForWeight:weight height:height];
    self.bmiLabel.text = [bmiDescription uppercaseString];
}


#pragma mark - UIView

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self setupViews];
        [self setupConstraints];
    }
    return self;
}


#pragma mark - Configuration

- (CGFloat)verticalSpacing {
    return 5.0;
}


- (void)setupViews {
    [self addSubview:self.weightButton];
    [self addSubview:self.bmiLabel];
}


#pragma mark - Class Methods

- (NSDictionary *)weightAttributes {
    static NSDictionary *_weightAttributes = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _weightAttributes = @{NSFontAttributeName: [UIFont fontWithName:@"Avenir" size:70.0],
                              NSForegroundColorAttributeName: [UIColor whiteColor]};
    });
    return _weightAttributes;
}


- (NSDictionary *)symbolAttributes {
    static NSDictionary *_symbolAttributes = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _symbolAttributes = @{NSFontAttributeName : [UIFont fontWithName:@"Avenir" size:20.0]};
    });
    return _symbolAttributes;
}


#pragma mark - Private

- (void)setupConstraints {
    [self.weightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).with.offset(10.0);
        make.top.equalTo(self);
        make.height.lessThanOrEqualTo(@70.0);
    }];

    [self.bmiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self);
        make.top.equalTo(self.weightButton.mas_bottom).with.offset(self.verticalSpacing);
    }];
}

@end
