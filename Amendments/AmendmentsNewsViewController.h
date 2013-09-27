//
//  AmendmentsNewsViewController.h
//  Amendments
/*
    A TableViewController for displaying an amendment's news feed. Registers for notifications from the NewsFeeds singleton and makes a call to load a news feed for the current amendment, based on the current amendment's key. See 'Supporting Files/SVModelWebViewController' to see the favoriting logic.
*/
//  Created by Alex Silva on 3/2/13.
//  Copyright (c) 2013 Alex Silva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExtendedSummaryViewController.h"

@interface AmendmentsNewsViewController : UITableViewController <UIAlertViewDelegate,UINavigationControllerDelegate>

@property int amendmentNumberForSorting;
@property (strong, nonatomic) NSString *keyForFeed;
@property (strong, nonatomic) NSMutableArray *feed;
@property (strong, nonatomic) NSString *finalURL;
@property BOOL didSegueFromSingleAmendmentVC;
@property (nonatomic, weak) id <SingleAmendmentDelegate> delegate;

@end
