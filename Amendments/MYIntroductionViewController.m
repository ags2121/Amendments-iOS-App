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
	// Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    
    //STEP 1 Construct Panels
    MYIntroductionPanel *panel = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"blankimage"] title:@"Welcome to The Amendments app, a lightweight yet powerful guide to American constitutional law and history." description:@""];
    
    //You may also add in a title for each panel
    MYIntroductionPanel *panel2 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"articleFav_spotlight"] title:@"Adding favorites" description:@"Tap the star in the upper right corner to add an article to your favorites. Untap to remove."];
    
    MYIntroductionView *introductionView = [[MYIntroductionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) headerImage:[UIImage imageNamed:@"AmendmentIntroViewHeaderTitle@2x"] panels:@[panel, panel2] languageDirection:MYLanguageDirectionLeftToRight];
    [introductionView setBackgroundImage:[UIImage imageNamed:@"AmendmentIntroViewBackGroundNOTITLE@2x"]];
    
    
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

#pragma mark - Sample Delegate Methods

-(void)introductionDidFinishWithType:(MYFinishType)finishType{
    if (finishType == MYFinishTypeSkipButton) {
        NSLog(@"Did Finish Introduction By Skipping It");
    }
    else if (finishType == MYFinishTypeSwipeOut){
        NSLog(@"Did Finish Introduction By Swiping Out");
    }
    
    AmendmentsAppDelegate *appDelegate = (AmendmentsAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [appDelegate.window.rootViewController dismissViewControllerAnimated:NO completion:NULL];
    
//    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Storyboard"
//                                                             bundle: nil];
//    UINavigationController *nbvc = [mainStoryboard instantiateViewControllerWithIdentifier:@"navbBarController"];
//    
//    [self.tabBarController presentViewController:nbvc animated:NO completion:NULL];
//    
    
    
    //One might consider making the introductionview a class variable and releasing it here.
    // I didn't do this to keep things simple for the sake of example.
}

-(void)introductionDidChangeToPanel:(MYIntroductionPanel *)panel withIndex:(NSInteger)panelIndex{
    NSLog(@"%@ \nPanelIndex: %d", panel.Description, panelIndex);
}

@end
