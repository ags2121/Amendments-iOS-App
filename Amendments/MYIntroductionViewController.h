//
//  MYIntroductionViewController.h
//  Amendments
//
//  Created by Alex Silva on 4/16/13.
//  Copyright (c) 2013 Alex Silva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYIntroductionView.h"

@interface MYIntroductionViewController : UIViewController<MYIntroductionDelegate>

@property (strong, nonatomic) MYIntroductionView *introductionView;

@end
