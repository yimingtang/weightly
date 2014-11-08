//
//  WTLInputViewController.h
//  Weightly
//
//  Created by Yiming Tang on 11/5/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WTLTextField;
@protocol WTLInputViewControllerDelegate;

@interface WTLInputViewController : UIViewController

@property (nonatomic, strong, readonly) WTLTextField *textField;
@property (nonatomic, strong, readonly) UIButton *doneButton;
@property (nonatomic, copy) NSString *unitString;
@property (nonatomic, copy) NSString *initialInput;
@property (nonatomic, weak) id<WTLInputViewControllerDelegate> delegate;

@end

@protocol WTLInputViewControllerDelegate <NSObject>
@optional
- (void)inputViewController:(WTLInputViewController *)inputViewController didFinishEditingWithResult:(NSString *)result;
@end
