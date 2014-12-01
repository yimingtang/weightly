//
//  WTLInputViewController.m
//  Weightly
//
//  Created by Yiming Tang on 11/5/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//

#import "WTLInputViewController.h"
#import "WTLTextField.h"
#import "WTLNumberValidator.h"
#import "UIColor+Weightly.h"

#import <Masonry/Masonry.h>

@interface WTLInputViewController ()
@property (nonatomic, readonly) WTLTextField *textField;
@property (nonatomic, readonly) UIButton *doneButton;
@end

@implementation WTLInputViewController

#pragma mark - Accessors

@synthesize textField = _textField;
@synthesize doneButton = _doneButton;
@synthesize delegate = _delegate;
@synthesize inputString = _inputString;
@synthesize suffixString = _suffixString;
@synthesize validator = _validator;

- (WTLTextField *)textField {
    if (!_textField) {
        _textField = [[WTLTextField alloc] initWithFrame:CGRectZero];
    }
    return _textField;
}


- (UIButton *)doneButton {
    if (!_doneButton) {
        _doneButton = [[UIButton alloc] init];
        _doneButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Light" size:16.0f];
        [_doneButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.5f] forState:UIControlStateNormal];
        [_doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_doneButton addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
        [_doneButton setTitle:@"Done" forState:UIControlStateNormal];
        _doneButton.contentEdgeInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
        _doneButton.layer.cornerRadius = 5.0;
        _doneButton.layer.borderWidth = 1.0;
        _doneButton.layer.borderColor = [[UIColor colorWithWhite:1.0 alpha:0.5f] CGColor];
    }
    return _doneButton;
}


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor wtl_redColor];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self.view addGestureRecognizer:tapGesture];
    
    [self.view addSubview:self.doneButton];
    [self.view addSubview:self.textField];
    self.textField.text = self.inputString;
    self.textField.suffixLabel.text = self.suffixString;
    
    [self resetViewConstraints];
    [self.view layoutIfNeeded];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.textField becomeFirstResponder];
    [self animateViewsIn];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.textField resignFirstResponder];
    [self animateViewsOut];
}


#pragma mark - Actions

- (void)save:(id)sender {
    if (![self validateInput]) {
        self.textField.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.8f, 0.8f);
        
        void (^animations)(void) = ^{
            self.textField.transform = CGAffineTransformIdentity;
        };
        
        [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.3f initialSpringVelocity:1.0 options:0 animations:animations completion:nil];
        return;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([self.delegate respondsToSelector:@selector(inputViewController:didFinishEditingWithText:)]) {
        [self.delegate inputViewController:self didFinishEditingWithText:self.textField.text];
    }
}


- (void)handleTapGesture:(UIGestureRecognizer *)gestureRecognizer {
    [self save:nil];
}


#pragma mark - Private Methods

- (BOOL)validateInput {
    if (!self.validator) {
        return YES;
    }
    
    NSString *string = self.textField.text;
    if (!string) {
        string = @"";
    }
    
    return [self.validator validateValue:(strtof([string cStringUsingEncoding:NSASCIIStringEncoding], nil))];
}


- (void)resetViewConstraints {
    [self.doneButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).with.offset(-20.0);
        make.bottom.equalTo(self.view.mas_top);
    }];
    [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).multipliedBy(1.25f);
        make.width.equalTo(self.view).multipliedBy(0.85f);
    }];
}


- (void)animateViewsIn {
    CGFloat offsetY = [UIApplication sharedApplication].statusBarHidden ? 0 : 20.0;
    
    [self.doneButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).with.offset(-20.0);
        make.top.equalTo(self.view.mas_top).with.offset(12.0 + offsetY);
    }];
    
    [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view.mas_bottom).dividedBy(3.0);
        make.width.equalTo(self.view).multipliedBy(0.85f);
    }];
    
    [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:1 options:0 animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];
}


- (void)animateViewsOut {
    [self resetViewConstraints];
    
    // duration = keyboard animation duration
    // option = keyboard animation curve. not documented
    [UIView animateWithDuration:0.3 delay:0 options:kNilOptions animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];
}

@end
