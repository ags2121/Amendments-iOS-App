//
//  AllAmendmentsViewController.h
//  Amendments
/*
    A TableViewController and first responder and first tab in the TabViewController array. Displays all of the amendments in a tableview. Each cell segues to a SingleAmendmentViewController, passing on amendment cell data and amendment text data (i.e. extended summary html path, original text html path). If an icon is tapped, an IconDetailViewController is instantiated and presents a larger detail image of the thumbnail icon.
*/
//  Created by Alex Silva on 2/28/13.
//  Copyright (c) 2013 Alex Silva. All rights reserved.

#import <UIKit/UIKit.h>
#import "MYIntroductionView.h"
#import "IconDetailViewController.h"

@interface AllAmendmentsViewController : UITableViewController<UIGestureRecognizerDelegate, IconDetailDelegate>

@property (strong, nonatomic) NSArray *amendmentsTableData;

@end
