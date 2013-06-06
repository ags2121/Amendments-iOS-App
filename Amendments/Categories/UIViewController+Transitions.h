//
//  UIViewController+Transitions.h
//  Amendments
//
//  Created by Alex Silva on 6/5/13.
//  Copyright (c) 2013 Alex Silva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface UIViewController (Transitions)

// make a transition that looks like a modal view
//  is expanding from a subview
- (void)expandView:(UIView *)sourceView
toModalViewController:(UIViewController *)modalViewController;

// make a transition that looks like the current modal view
//  is shrinking into a subview
- (void)dismissModalViewControllerToView:(UIView *)view;

@end