//
//  AmendmentsNewsViewController.h
//  Amendments
//
//  Created by Alex Silva on 3/2/13.
//  Copyright (c) 2013 Alex Silva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExtendedSummaryViewController.h"

@interface AmendmentsNewsViewController : UITableViewController <UIAlertViewDelegate>

@property int amendmentNumberForSorting;
@property (strong, nonatomic) NSString *keyForFeed;
@property (strong, nonatomic) NSMutableArray *feed;
@property (strong, nonatomic) NSString *finalURL;
@property (nonatomic, weak) id <SingleAmendmentDelegate> delegate;

@end
