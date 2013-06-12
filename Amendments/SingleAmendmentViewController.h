//
//  SingleAmendmentViewController.h
//  Amendments
/*
    A Scrollview which contains a Label and TableView as subviews, which display an amendment's summary text and branching segues to different amendment features, respectively. Implements the SingleAmendmentDelegate to allow its child view controllers to communicate information about interface orientation. 
*/
//  Created by Alex Silva on 3/1/13.
//  Copyright (c) 2013 Alex Silva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExtendedSummaryViewController.h"
#import "OriginalTextViewController.h"

@interface SingleAmendmentViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, SingleAmendmentDelegate>

@property NSUInteger sectionOfAmendment;
@property (strong, nonatomic) NSDictionary* amendmentData;
@property (strong, nonatomic) NSDictionary* amendmentCellData;
@property (strong, nonatomic) NSString *shortTitle;

@property (atomic) BOOL parentViewControllerWasInLandscape;

@property (weak, nonatomic) IBOutlet UILabel *summary;
@property (weak, nonatomic) IBOutlet UITableView *optionsTableView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
