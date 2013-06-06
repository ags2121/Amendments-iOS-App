//
//  AllAmendmentsViewController.h
//  Amendments
//
//  Created by Alex Silva on 2/28/13.
//  Copyright (c) 2013 Alex Silva. All rights reserved.

#import <UIKit/UIKit.h>
#import "MYIntroductionView.h"
#import "IconDetailViewController.h"

@interface AllAmendmentsViewController : UITableViewController<UIGestureRecognizerDelegate, IconDetailDelegate>

@property (strong, nonatomic) NSArray *amendmentsTableData;

@end
