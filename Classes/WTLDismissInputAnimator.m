//
//  WTLDismissInputAnimator.m
//  Weightly
//
//  Created by Yiming Tang on 11/6/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//

#import "WTLDismissInputAnimator.h"

@implementation WTLDismissInputAnimator

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}


- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromViewController.view.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [fromViewController.view removeFromSuperview];
        [transitionContext completeTransition:YES];
    }];
}

@end
