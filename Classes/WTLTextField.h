//
//  WTLTextField.h
//  Weightly
//
//  Created by Yiming Tang on 11/6/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTLTextField : UITextField

@property (nonatomic, readonly) UILabel *unitLabel;
@property (nonatomic) UIEdgeInsets textEdgeInsets;
@property (nonatomic) UIEdgeInsets unitLabelEdgeInsets;

@end
