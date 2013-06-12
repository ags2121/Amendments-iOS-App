//
//  OriginalTextViewController.h
//  Amendments
/*
    A ViewController with a WebView that renders an amendment's original text html string. Communicates orientation changes back to SingleAmendmentViewController. Allows html hyperlinks to be opened in a modified SVWebViewController. See 'Model/originalTextHTMLfiles'
*/
//  Created by Alex Silva on 3/13/13.
//  Copyright (c) 2013 Alex Silva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExtendedSummaryViewController.h"

@interface OriginalTextViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSString* htmlString;
@property (nonatomic, weak) id <SingleAmendmentDelegate> delegate;

@end
