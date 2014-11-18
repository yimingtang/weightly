//
//  WTLInputViewController.m
//  Weightly
//
//  Created by Yiming Tang on 11/5/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//

#import "WTLInputViewController.h"
#import "WTLTextField.h"
#import <Masonry.h>

@implementation WTLInputViewController

#pragma mark - Accessors

@synthesize textField = _textField;
@synthesize doneButton = _doneButton;

- (WTLTextField *)textField {
    if (!_textField) {
        _textField = [[WTLTextField alloc] initWithFrame:CGRectZero];
    }
    return _textField;
}


- (UIButton *)doneButton {
    if (!_doneButton) {
        _doneButton = [[UIButton alloc] initWithFrame:CGRectZero];
        _doneButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Light" size:16.0f];
        [_doneButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateNormal];
        [_doneButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.8f] forState:UIControlStateHighlighted];
        [_doneButton addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
        [_doneButton setTitle:@"Done" forState:UIControlStateNormal];
        _doneButton.contentEdgeInsets = UIEdgeInsetsMake(8.0f, 10.0f, 8.0f, 10.0f);
        _doneButton.layer.cornerRadius = 4.0f;
        _doneButton.layer.borderColor = [[UIColor colorWithWhite:1.0f alpha:0.5f] CGColor];
        _doneButton.layer.borderWidth = 1.0f;
    }
    return _doneButton;
}


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:231.0f/255.0f green:76.0f/255.0f blue:60.0f/255.0f alpha:1.0f];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)]];
    [self.view addSubview:self.doneButton];
    [self.view addSubview:self.textField];
    
    self.textField.text = self.initialInput;
    self.textField.unitLabel.text = self.unitString;
    
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
    [self dismissViewControllerAnimated:YES completion:nil];
    if ([self.delegate respondsToSelector:@selector(inputViewController:didFinishEditingWithResult:)]) {
        [self.delegate inputViewController:self didFinishEditingWithResult:self.textField.text];
    }
}


- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer {
    [self save:nil];
}


#pragma mark - Private Methods

- (void)resetViewConstraints {
    [self.doneButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).with.offset(-20.0f);
        make.bottom.equalTo(self.view.mas_top);
    }];
    [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).multipliedBy(1.25f);
        make.width.equalTo(self.view).multipliedBy(0.85f);
    }];
}


- (void)animateViewsIn {
    CGFloat offsetY = [UIApplication sharedApplication].statusBarHidden ? 0 : 20.0f;
    
    [self.doneButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).with.offset(-20.0f);
        make.top.equalTo(self.view.mas_top).with.offset(12.0f + offsetY);
    }];
    
    [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view.mas_bottom).dividedBy(3.0f);
        make.width.equalTo(self.view).multipliedBy(0.85f);
    }];
    
    [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:0.65f initialSpringVelocity:0.75f options:0 animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];
}


- (void)animateViewsOut {
    [self resetViewConstraints];
    
    // duration = keyboard animation duration
    // option = keyboard animation curve. not documented
    [UIView animateWithDuration:0.3 delay:0 options:(7 << 16) animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];
}

@end
