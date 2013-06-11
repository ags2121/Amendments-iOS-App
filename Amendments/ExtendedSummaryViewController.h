//
//  ExtendedSummaryViewController.h
//  Amendments
//
//  Created by Alex Silva on 3/13/13.
//  Copyright (c) 2013 Alex Silva. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ExtendedSummaryViewController;

/************************************************************
 * @protocol:       SingleAmendmentDelegate
 * @description:    this protocol is implemented by child view controllers of the SingleAmendmentViewController, so that they may alert their parent that they have changed interface orientation. Every child view controller records their initial interface orientation in viewDidLoad, and if that orientation differs from the orientation recorded in viewWillDisappear, then the child sends a message to the delegate that its orientation has changed, so that the delegate can update its subviews to match the new orientation.
 ***********************************************************/

@protocol SingleAmendmentDelegate

@property (atomic) BOOL childViewControllerDidRotateToLandscape;
@property (atomic) BOOL childViewControllerDidRotateToPortrait;

@end

@interface ExtendedSummaryViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSString* htmlString;
@property (nonatomic, weak) id <SingleAmendmentDelegate> delegate;

@end
