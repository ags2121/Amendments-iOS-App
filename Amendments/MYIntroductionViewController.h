//
//  MYIntroductionViewController.h
//  Amendments
/*
    A ViewController that renders the third-party MYIntroductionView introduction UI. Assembles the different Introduction Panels and their associated assets and places them into a MYIntroductionView. Implements the MYIntroductionDelegate to receive callbacks from user interaction with introview. See 'Supporting Files/MYIntroductionView'
*/
//  Created by Alex Silva on 4/16/13.
//  Copyright (c) 2013 Alex Silva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYIntroductionView.h"

@interface MYIntroductionViewController : UIViewController<MYIntroductionDelegate>

@property (strong, nonatomic) MYIntroductionView *introductionView;

@end
