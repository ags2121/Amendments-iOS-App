//
//  ExtendedSummaryViewController.h
//  Amendments
//
//  Created by Alex Silva on 3/13/13.
//  Copyright (c) 2013 Alex Silva. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ExtendedSummaryViewController;

@protocol SingleAmendmentDelegate

-(void)childViewControllerDidRotateToPortrait;

@end

@interface ExtendedSummaryViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSString* htmlString;
@property (nonatomic, weak) id <SingleAmendmentDelegate> delegate;
@end
