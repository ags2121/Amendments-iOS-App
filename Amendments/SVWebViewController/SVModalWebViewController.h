//
//  SVModalWebViewController.h
//
//  Created by Oliver Letterer on 13.08.11.
//  Copyright 2011 Home. All rights reserved.
//
//  https://github.com/samvermette/SVWebViewController
/*
    Third-party WebViewController, the modal wrapper class for SVWebViewController. I added logic that allows you to pass in arguments for the navigation bar title; if you assign a value to this property it will get used. Otherwise it will default to the title string for the article, which is pulled down in the html. I have all the logic for adding favorites here. I also allow for the toggling of the presence of the favorite star icon, which we will want disabled in some cases, like when a user visits an online citation from an ExtendedSummaryViewController. 
 */

#import <UIKit/UIKit.h>

enum {
    SVWebViewControllerAvailableActionsNone             = 0,
    SVWebViewControllerAvailableActionsOpenInSafari     = 1 << 0,
    SVWebViewControllerAvailableActionsMailLink         = 1 << 1,
    SVWebViewControllerAvailableActionsCopyLink         = 1 << 2,
    SVWebViewControllerAvailableActionsOpenInChrome     = 1 << 3
};

typedef NSUInteger SVWebViewControllerAvailableActions;


@class SVWebViewController;

@interface SVModalWebViewController : UINavigationController

- (id)initWithAddress:(NSString*)urlString;
- (id)initWithURL:(NSURL *)URL;
-(UIBarButtonItem*)returnFavoriteButton;

@property (nonatomic, strong) UIColor *barsTintColor;
@property (nonatomic, readwrite) SVWebViewControllerAvailableActions availableActions;

@property (nonatomic, strong) NSDictionary *articleInfoForFavorites;
@property (nonatomic, strong) NSString *keyForAmendment;
@property (nonatomic, strong) NSString *titleForNavBar;
@property (nonatomic) BOOL loadFavoriteButton;

@end
