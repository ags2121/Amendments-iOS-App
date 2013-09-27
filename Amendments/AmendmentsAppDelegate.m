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
#import "Constants.h"
#import "iRate.h"

/*
#import "XMLReader.h"
#import "AFHTTPSessionManager.h"
#import "AFURLConnectionOperation.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
 */

@implementation AmendmentsAppDelegate

+ (void)initialize
{
    //TODO: remove for deployment
    //enable iRate preview mode
    //[iRate sharedInstance].previewMode = YES;
}

/*
-(void)XMLTest
{
    NSLog(@"starting XML fetch");
    NSString *stringURL=@"http://news.google.com/news/feeds?gl=us&hl=en&as_occt=title&as_qdr=a&as_nloc=us&q=allintitle:%22second+amendment%22+OR+%222nd+amendment%22+location:us&um=1&ie=UTF-8&output=rss&num=25";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:stringURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *responseString=[[NSString alloc] initWithData:(NSData*)responseObject encoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary *xmlDictionary=[XMLReader dictionaryForXMLString:responseString error:&error];
        NSMutableArray *theFeed = [NSMutableArray arrayWithArray:xmlDictionary[@"rss"][@"channel"][@"item"]];
        NSLog(@"AS ARRAY %@", theFeed);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", [error description]);
    }];
}
*/

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //[self XMLTest];
    [self setPreferenceDefaults]; //set user defaults
    [self customizeAppearance]; //set appearance proxies
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    //add background image
    self.backgroundView = [[UIImageView alloc] initWithFrame: self.window.frame];
    if (IS_IPHONE_5)
        self.backgroundView.image = [UIImage imageNamed:@"AmendmentBackgroundImage-568h@2x"];
    else
        self.backgroundView.image = [UIImage imageNamed:@"AmendmentBackgroundImage"];
        
    [self.window addSubview: self.backgroundView];
    
    //set tab bar controller as root view controller
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Storyboard"
                                                             bundle: nil];
    UITabBarController *tbvc = [mainStoryboard instantiateViewControllerWithIdentifier:@"tabBarController"];
    self.window.rootViewController = tbvc;
    [self.window makeKeyAndVisible];
    
    //TODO: for deployment, only show intro view on first launch
    if ( [[[NSUserDefaults standardUserDefaults] objectForKey:@"Did watch intro"] isEqualToString:@"0"] ) {
        _mivc = [[MYIntroductionViewController alloc] init];
        _mivc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self.window.rootViewController presentViewController:_mivc animated:NO completion:NULL];
        [self markUserDidWatchIntro];
        NSLog(@"User did watch intro");
    }
    
    return YES;
}

//makes sure background image adjusts itself on rotation
- (void) application:(UIApplication *)application
willChangeStatusBarOrientation:(UIInterfaceOrientation)newStatusBarOrientation
            duration:(NSTimeInterval)duration
{
    int yTranslateVal = 77;
    if(IS_IPHONE_5) yTranslateVal = 115;
    
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
        bgImage.transform = CGAffineTransformTranslate(bgImage.transform, 0, yTranslateVal);
        bgImage.transform = CGAffineTransformScale(bgImage.transform, 0.70, 0.70);
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
 * @abstract        Calls appearance proxy methods on interface objects. Sets navigation bar to black tint color.
 *******************************************************************************/
-(void)customizeAppearance
{
    [[UINavigationBar appearance] setTintColor:[UIColor blueColor]];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-70.f, -70.f) forBarMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-70.f, -70.f) forBarMetrics:UIBarMetricsLandscapePhone];
    [[UITableViewHeaderFooterView appearance] setTintColor:[UIColor grayColor]];
}

#pragma mark - Preference Defaults
/*******************************************************************************
 * @method:     setPreferenceDefaults
 * @abstract:   sets user preference defaults. Records initial date of launch and sets "Did add favorites" to false, recording the fact that user has yet to add any favorites. This will be set to true once the user has added a favorite.
 * @see: FavoritesViewController
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

        //add date and "Did add favorites" boolean to NSDictionary
        NSDictionary *newAppDefaults = @{ @"kInitialRun" : [NSDate date], @"Did add favorites" : @"0", @"Did watch intro": @"0" };
        [newAppDefaults writeToFile:path atomically:YES];
    }
    
    //load file and use it to register user defaults 
    NSDictionary *appDefaults = [[NSDictionary alloc] initWithContentsOfFile:path];
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
    [[NSUserDefaults standardUserDefaults] synchronize]; 
    
    NSLog(@"NSUserDefaults at launch: %@", [[NSUserDefaults standardUserDefaults]
                                  dictionaryRepresentation]);
}

-(void)markUserDidWatchIntro
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //change "Did add favorites" to 1 in the plist stored in the documents directory
    if( [[defaults objectForKey:@"Did watch intro"] isEqualToString:@"0"] ) { //if "Did add favorites is 0
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:@"UserDefaults.plist"];
        NSDictionary *updatedDefaults = @{ @"kInitialRun" : [defaults objectForKey:@"kInitialRun"], @"Did add favorites": [defaults objectForKey:@"Did add favorites"], @"Did watch intro" : @"1" };
        [updatedDefaults writeToFile:path atomically:YES];
        //NSLog(@"Updated defaults: %@", updatedDefaults);
        [defaults registerDefaults:updatedDefaults];
        [defaults synchronize];
        NSLog(@"updated NSUserDefaults: %@", [[NSUserDefaults standardUserDefaults]
                                              dictionaryRepresentation]);
    }
}

@end
