//
//  AmendmentsAppDelegate.h
//  Amendments
//
//  Created by Alex Silva on 2/28/13.
//  Copyright (c) 2013 Alex Silva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYIntroductionView.h"
#import "MYIntroductionViewController.h"

@interface AmendmentsAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MYIntroductionViewController *mivc;
@property (strong, nonatomic) UIImageView *backgroundView;
@property (strong, nonatomic) NSMutableData *responseData;

@end
