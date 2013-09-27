//
//  FavoritesViewController.h
//  Amendments
/*
    A TableViewController for displaying the user's favorite amendments. Favorite amendments are stored in UserDefaults. They are retrieved, sorted by amendment number, and displayed here. The article title text dynamically resizes its cell height based on orientation changes as well as whether the user is in cell delete mode.
*/
//  Created by Alex Silva on 2/28/13.
//  Copyright (c) 2013 Alex Silva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExtendedSummaryViewController.h"

@interface FavoritesViewController : UITableViewController<UIAlertViewDelegate>

@property (atomic) UIInterfaceOrientation singleAmendmentVcOrientation;

@end
