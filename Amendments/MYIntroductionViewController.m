//
//  MYIntroductionViewController.m
//  Amendments
//
//  Created by Alex Silva on 4/16/13.
//  Copyright (c) 2013 Alex Silva. All rights reserved.
//

#import "AmendmentsAppDelegate.h"
#import "MYIntroductionViewController.h"
#import "MYIntroductionPanel.h"
#import "Constants.h"

@interface MYIntroductionViewController ()

@end

@implementation MYIntroductionViewController

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
}

-(void)viewDidAppear:(BOOL)animated
{
    
    //STEP 1 Construct Panels
    MYIntroductionPanel *panel = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"blankimage"] title:@"Welcome to The Amendments" description:@"a lightweight yet powerful guide to American constitutional law and history."];
    
    //You may also add in a title for each panel
    MYIntroductionPanel *panel2 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"all_amendments_spotlight"] title:@"Exploring Amendments" description:@"In the first tab, tap the Amendment you'd like to explore..."];
    
    MYIntroductionPanel *panel25 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"all_amendments2_spotlight"] title:@"Zoom in" description:@"...or tap on the Amendment icon to zoom in and get a closer look."];
    
    MYIntroductionPanel *panel3 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"individual_spotlight"] title:@"Amendment Features" description:@"Each Amendment has an extended summary, the original text, and a news feed."];
    
    MYIntroductionPanel *panel4 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"news_spotlight"] title:@"The News Feed" description:@"Each news feed gathers the latest articles on the web discussing each Amendment."];
    
    MYIntroductionPanel *panel5 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"article_spotlight"] title:@"Adding Favorites" description:@"To add an article to your Favorites, tap the star in the upper right corner. Untap to remove."];
    
    MYIntroductionPanel *panel6 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"fav_articles_spotlight"] title:@"Viewing Favorites" description:@"Your Favorites can be accessed in the second tab."];
    
    MYIntroductionPanel *panel7 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"fav_articles_delete_spotlight"] title:@"Deleting Favorites" description:@"Swipe an article left to reveal the delete button.\nTap anywhere else to hide it."];
    
    MYIntroductionView *introductionView = [[MYIntroductionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) headerImage:[UIImage imageNamed:@"AMLogo_invertedColors"] panels:@[panel, panel2, panel25, panel3, panel4, panel5, panel6, panel7] languageDirection:MYLanguageDirectionLeftToRight];
    
    NSLog(@"view frame: %@", NSStringFromCGRect(self.view.frame));
    
    if(IS_IPHONE_5)
         [introductionView setBackgroundImage:[UIImage imageNamed:@"IntroViewBackground-568h"]];
    else
        [introductionView setBackgroundImage:[UIImage imageNamed:@"IntroViewBackground"]];
    
    //Set delegate to self for callbacks (optional)
    introductionView.delegate = self;
    
    //STEP 3: Show introduction view
    [introductionView showInView:self.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotate{
    return NO;
}

/***********************************************************
 * @method:      dismissSelf
 * @abstract: the dismissTimer callback method. When the user has finished viewing all of the introView panel, or if the user has skipped the intro, a timer will be fired which after a few seconds, call this method which does an animated dismiss of the introViewController. This strategy looked better than the default dismiss which looked too jerky.
 * @see introductionDidFinishWithType:
 **********************************************************/
-(void)dismissSelf:(NSTimer*)theTimer
{
    AmendmentsAppDelegate *appDelegate = (AmendmentsAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.window.rootViewController dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark - Sample Delegate Methods

-(void)introductionDidFinishWithType:(MYFinishType)finishType{
    if (finishType == MYFinishTypeSkipButton) {
        NSLog(@"Did Finish Introduction By Skipping It");
    }
    else if (finishType == MYFinishTypeSwipeOut){
        NSLog(@"Did Finish Introduction By Swiping Out");
    }

    //create timer
    NSTimer *dismissTimer = [NSTimer scheduledTimerWithTimeInterval: 1.2 target:self selector:@selector(dismissSelf:) userInfo:NULL repeats: NO];

    [[NSRunLoop mainRunLoop] addTimer: dismissTimer forMode:NSRunLoopCommonModes];
    
}

-(void)introductionDidChangeToPanel:(MYIntroductionPanel *)panel withIndex:(NSInteger)panelIndex{
    NSLog(@"%@ \nPanelIndex: %d", panel.Description, panelIndex);
}

@end
