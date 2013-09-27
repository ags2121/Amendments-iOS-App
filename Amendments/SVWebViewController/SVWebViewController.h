//
//  SVWebViewController.h
//
//  Created by Sam Vermette on 08.11.10.
//  Copyright 2010 Sam Vermette. All rights reserved.
//
//  https://github.com/samvermette/SVWebViewController
/*
    Third-party WebViewController. I replaced the actionSheet with iOS6 UIActivityViewController, when user taps action bar button, and added subclasses of UIActivity. I did a slight change of logic that only sets the navBar title if its nil. This allows the SVModalWebViewController a chance to set a custom navBar title. See also my changes to SVModalWebViewController which is a modal wrapper class for this. See webViewDidFinishLoad.
 */

#import <MessageUI/MessageUI.h>
#import "SVModalWebViewController.h"

@interface SVWebViewController : UIViewController

- (id)initWithAddress:(NSString*)urlString;
- (id)initWithURL:(NSURL*)URL;

@property (nonatomic, readwrite) SVWebViewControllerAvailableActions availableActions;
@property (nonatomic, strong) UIWebView *mainWebView;

@end
