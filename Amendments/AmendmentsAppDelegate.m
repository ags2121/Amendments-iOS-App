//
//  AmendmentsAppDelegate.m
//  Amendments
//
//  Created by Alex Silva on 2/28/13.
//  Copyright (c) 2013 Alex Silva. All rights reserved.
//

#import "AmendmentsAppDelegate.h"
#import "NewsFeeds.h"
#import "AmendmentsNewsViewController.h"

@implementation AmendmentsAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setPreferenceDefaults]; //set user defaults
    [self customizeAppearance]; //set appearance proxies
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    //add background image
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame: self.window.frame];
    backgroundView.image = [UIImage imageNamed:@"AmendmentBackgroundImage"];
    [self.window addSubview:backgroundView];
    
    //set tab bar controller as root view controller
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Storyboard"
                                                             bundle: nil];
    UITabBarController *tbvc = [mainStoryboard instantiateViewControllerWithIdentifier:@"tabBarController"];
    self.window.rootViewController = tbvc;
    [self.window makeKeyAndVisible];
    
    //TODO: add logic for how many times intro view will be shown
    _mivc = [[MYIntroductionViewController alloc] init];
    _mivc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.window.rootViewController presentViewController:_mivc animated:NO completion:NULL];
    
    return YES;
}

//makes sure background image adjusts itself on rotation
- (void) application:(UIApplication *)application
willChangeStatusBarOrientation:(UIInterfaceOrientation)newStatusBarOrientation
            duration:(NSTimeInterval)duration
{
    
    UIImageView *bgImage = self.window.subviews[0];
    
    if (newStatusBarOrientation == UIInterfaceOrientationPortrait)
        bgImage.transform      = CGAffineTransformIdentity;
    else if (newStatusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)
        bgImage.transform      = CGAffineTransformMakeRotation(-M_PI);
    
    else if (UIInterfaceOrientationIsLandscape(newStatusBarOrientation))
    {
        float rotate    = ((newStatusBarOrientation == UIInterfaceOrientationLandscapeLeft) ? -1:1) * (M_PI / 2.0);
        bgImage.transform      = CGAffineTransformMakeRotation(rotate);
        bgImage.transform      = CGAffineTransformTranslate(bgImage.transform, 0, -bgImage.frame.origin.y);
        bgImage.transform = CGAffineTransformTranslate(bgImage.transform, 0, 77);
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    //retrieve individual news Feed from global pool of previously retrieved new feeds
//    
//    if( [application.keyWindow.rootViewController isKindOfClass: [AmendmentsNewsViewController class]] ){
//        
//        AmendmentsNewsViewController *currentNewsVC = (AmendmentsNewsViewController*)application.keyWindow.rootViewController;
//        
//        NewsFeeds* allNewsFeeds = [NewsFeeds sharedInstance];
//        
//        //load the feed from the Singleton NewsFeeds
//        [allNewsFeeds loadNewsFeed:currentNewsVC.finalURL forAmendment:currentNewsVC.keyForFeed forTableViewController:currentNewsVC];
//        
//    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - Appearance Proxy
/*******************************************************************************
 * @method          customizeAppearance
 * @abstract        Call the appearance proxy methods on interface objects
 * @description     sets navigation bar to black tint color; sets 
 *******************************************************************************/

-(void)customizeAppearance
{
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    [[UITableViewHeaderFooterView appearance] setTintColor:[UIColor grayColor]];
}

#pragma mark - Preference Defaults
/*******************************************************************************
 * @method      setPreferenceDefaults
 * @abstract
 * @description sets user preference defaults 
 *******************************************************************************/

- (void)setPreferenceDefaults
{
    //use NSFileManager to retrieve plist of user preferences, located in documents directory
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"UserDefaults.plist"];
    
    //if file doesn't exist, create it
    if( ![fileManager fileExistsAtPath: path] ){
        
        //get current date and format
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"dd-MM-yy HH:mm"];
        NSString *dateString = [df stringFromDate:[NSDate date]];
    
        //add date and "Did add favorites" boolean to NSDictionary 
        NSDictionary *newAppDefaults = @{ @"kInitialRun" : dateString, @"Did add favorites" : @"0" };
        [newAppDefaults writeToFile:path atomically:YES];
    }
    
    //load file and use it to register user defaults 
    NSDictionary *appDefaults = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSLog(@"Initial preferences at launch: %@", appDefaults);
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
    [[NSUserDefaults standardUserDefaults] setObject:[appDefaults objectForKey: @"kInitialRun"] forKey: @"kInitialRun"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"NSUserDefaults: %@", [[NSUserDefaults standardUserDefaults]
                                  dictionaryRepresentation]);
}

@end
