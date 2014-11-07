//
//  WTLTextField.m
//  Weightly
//
//  Created by Yiming Tang on 11/6/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//

#import "WTLTextField.h"
#import "WTLDotKeyButton.h"

@implementation WTLTextField

#pragma mark - Accessors

@synthesize unitLabel = _unitLabel;

- (UILabel *)unitLabel {
    if (!_unitLabel) {
        _unitLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _unitLabel.textColor = [UIColor colorWithWhite:1.0f alpha:0.5f];
        _unitLabel.font = [UIFont fontWithName:@"Avenir-Light" size:30.0f];
    }
    return _unitLabel;
}


#pragma mark - UIView

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self initialize];
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self initialize];
    }
    return self;
}


#pragma mark - UITextField

- (CGRect)textRectForBounds:(CGRect)bounds {
    return UIEdgeInsetsInsetRect([super textRectForBounds:bounds], self.textEdgeInsets);
}


- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}


- (CGRect)rightViewRectForBounds:(CGRect)bounds {
    CGSize labelSize = [self.unitLabel sizeThatFits:bounds.size];
    return CGRectMake(bounds.size.width - labelSize.width - self.unitLabelEdgeInsets.right, self.unitLabelEdgeInsets.top, labelSize.width, labelSize.height);
}


#pragma mark - Private

- (void)initialize {
    self.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.1f];
    self.textAlignment = NSTextAlignmentCenter;
    self.textColor = [UIColor whiteColor];
    self.font = [UIFont fontWithName:@"Avenir" size:30.0f];
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"0" attributes:
                                  @{NSForegroundColorAttributeName : [UIColor colorWithWhite:1.0f alpha:0.5f]}];
    self.keyboardType = UIKeyboardTypeDecimalPad;
    self.layer.cornerRadius = 5.0f;
    self.rightView = self.unitLabel;
    self.rightViewMode = UITextFieldViewModeAlways;
    self.textEdgeInsets = UIEdgeInsetsMake(8.0f, 16.0f, 8.0f, 16.0f);
    self.unitLabelEdgeInsets = UIEdgeInsetsMake(8.0f, 0.0f, 8.0f, 16.0f);
}

@end
