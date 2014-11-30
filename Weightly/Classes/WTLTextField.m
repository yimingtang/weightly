//
//  WTLTextField.m
//  Weightly
//
//  Created by Yiming Tang on 11/6/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//

#import "WTLTextField.h"

@implementation WTLTextField

#pragma mark - Accessors

@synthesize suffixLabel = _suffixLabel;
@synthesize textEdgeInsets = _textEdgeInsets;
@synthesize suffixLabelEdgeInsets = _suffixLabelEdgeInsets;

- (UILabel *)suffixLabel {
    if (!_suffixLabel) {
        _suffixLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _suffixLabel.textColor = [UIColor colorWithWhite:1.0f alpha:0.5f];
        _suffixLabel.font = self.font;
    }
    return _suffixLabel;
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
    CGSize labelSize = [self.suffixLabel sizeThatFits:bounds.size];
    return CGRectMake(bounds.size.width - labelSize.width - self.suffixLabelEdgeInsets.right, self.suffixLabelEdgeInsets.top, labelSize.width, labelSize.height);
}


#pragma mark - Private

- (void)initialize {
    self.keyboardType = UIKeyboardTypeDecimalPad;
    self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.1f];
    self.textColor = [UIColor whiteColor];
    self.textAlignment = NSTextAlignmentCenter;
    self.font = [UIFont fontWithName:@"Avenir-Light" size:30.0];
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"0" attributes:
                                  @{NSForegroundColorAttributeName : [UIColor colorWithWhite:1.0 alpha:0.3f]}];
    self.layer.cornerRadius = 5.0;
    
    self.rightView = self.suffixLabel;
    self.rightViewMode = UITextFieldViewModeAlways;
    self.textEdgeInsets = UIEdgeInsetsMake(8.0, 16.0, 8.0, 16.0);
    self.suffixLabelEdgeInsets = UIEdgeInsetsMake(8.0, 0.0, 8.0, 16.0);
}

@end
