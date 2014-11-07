//
//  WTLTextField.m
//  Weightly
//
//  Created by Yiming Tang on 11/6/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//

#import "WTLTextField.h"
#import "WTLDotKeyButton.h"

@interface WTLTextField ()

@property (nonatomic, strong) WTLDotKeyButton *dotKeyButton;

@end

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


- (WTLDotKeyButton *)dotKeyButton {
    if (!_dotKeyButton) {
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
            _dotKeyButton = [[WTLDotKeyButton alloc] initWithFrame:CGRectMake(0, 122.0f, roundf(screenWidth / 3) - 3.0f, 40.0f)];
        } else {
            _dotKeyButton = [[WTLDotKeyButton alloc] initWithFrame:CGRectMake(0, 163.0f, roundf(screenWidth / 3) - 3.0f, 53.0f)];
        }
        [_dotKeyButton addTarget:self action:@selector(dotKeyClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dotKeyButton;
}


#pragma mark - NSObject

- (void)dealloc {
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [self.dotKeyButton removeFromSuperview];
    }
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
    self.keyboardType = UIKeyboardTypeNumberPad;
    self.layer.cornerRadius = 5.0f;
    self.rightView = self.unitLabel;
    self.rightViewMode = UITextFieldViewModeAlways;
    self.textEdgeInsets = UIEdgeInsetsMake(8.0f, 16.0f, 8.0f, 16.0f);
    self.unitLabelEdgeInsets = UIEdgeInsetsMake(8.0f, 0.0f, 8.0f, 16.0f);
    
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    }
}


#pragma mark - Actions

- (void)dotKeyClicked:(id)sender {
    [self insertText:@"."];
}


#pragma mark - Handle Notifications

- (void)keyboardWillShow:(NSNotification *)notification {
    // Hack the system number pad
    NSArray *windows = [[UIApplication sharedApplication] windows];
    if (windows.count < 2) {
        return;
    }
    
    UIWindow *keyboardWindow = [windows objectAtIndex:1];
    UIView *keyboardView = nil;
    
    // Find the keyboard view
    for (UIView *view in keyboardWindow.subviews) {
        if ([view.description hasPrefix:@"<UIInputSetContainerView"]) {
            for (UIView *subView in view.subviews) {
                if ([subView.description hasPrefix:@"<UIInputSetHostView"]) {
                    keyboardView = subView;
                }
            }
        }
    }
    
    if (!keyboardView) {
        return;
    }
    
    NSDictionary *userInfo = notification.userInfo;
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    // Add dot key if necessary
    if (!self.dotKeyButton.superview) {
        [keyboardView addSubview:self.dotKeyButton];
    }
    CGFloat keyWidth = roundf(keyboardSize.width / 3) - 3.0f;
    CGFloat keyHeight = roundf(keyboardSize.height / 4) - 1.0f;
    self.dotKeyButton.frame = CGRectMake(0.0f, keyboardSize.height - keyHeight, keyWidth, keyHeight);
}


- (void)keyboardDidHide:(NSNotification *)notification {
    [self.dotKeyButton removeFromSuperview];
}

@end
