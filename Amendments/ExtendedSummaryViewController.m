//
//  ExtendedSummaryViewController.m
//  Amendments
//
//  Created by Alex Silva on 3/13/13.
//  Copyright (c) 2013 Alex Silva. All rights reserved.
//

#import "ExtendedSummaryViewController.h"

@interface ExtendedSummaryViewController ()

@end

@implementation ExtendedSummaryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Make VC's background see through to the parent view background
    self.view.backgroundColor = [UIColor clearColor];
    
    [self.webView loadHTMLString:self.htmlString baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]bundlePath]]];
    [self fixWebViewsScrollview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)fixWebViewsScrollview
{
    [self.webView.scrollView setContentSize: CGSizeMake(self.webView.frame.size.width, self.webView.scrollView.contentSize.height)];
}

@end
