//
//  SingleAmendmentViewController.h
//  Amendments
//
//  Created by Alex Silva on 3/1/13.
//  Copyright (c) 2013 Alex Silva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SingleAmendmentViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSDictionary* amendmentData;
@property (strong, nonatomic) NSDictionary* amendmentCellData;

@property NSUInteger sectionOfAmendment;
@property (strong, nonatomic) NSString *shortTitle;

@property (weak, nonatomic) IBOutlet UILabel *summary;
@property (weak, nonatomic) IBOutlet UITableView *optionsTableView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;



@end