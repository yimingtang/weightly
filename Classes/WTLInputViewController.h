//
//  WTLInputViewController.h
//  Weightly
//
//  Created by Yiming Tang on 11/5/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WTLTextField;

@interface WTLInputViewController : UIViewController

@property (strong, nonatomic, readonly) WTLTextField *textField;
@property (strong, nonatomic, readonly) UIButton *doneButton;

@end
