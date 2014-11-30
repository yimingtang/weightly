//
//  WTLInputViewController.h
//  Weightly
//
//  Created by Yiming Tang on 11/5/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//

@import UIKit;

@protocol WTLInputViewControllerDelegate;

@interface WTLInputViewController : UIViewController
@property (nonatomic, copy) NSString *inputString;
@property (nonatomic, copy) NSString *suffixString;
@property (nonatomic, weak) id<WTLInputViewControllerDelegate> delegate;
@end

@protocol WTLInputViewControllerDelegate <NSObject>
@optional
- (void)inputViewController:(WTLInputViewController *)inputViewController didFinishEditingWithResult:(NSString *)result;
@end
