//
//  SVModalWebViewController.m
//
//  Created by Oliver Letterer on 13.08.11.
//  Copyright 2011 Home. All rights reserved.
//
//  https://github.com/samvermette/SVWebViewController

#import "SVModalWebViewController.h"
#import "SVWebViewController.h"
#import "CustomIconButton.h"

@interface SVModalWebViewController ()

@property (nonatomic, strong) SVWebViewController *webViewController;
@property (nonatomic, strong) NSMutableArray *favoriteArticlesforAmendment;

@end


@implementation SVModalWebViewController

@synthesize barsTintColor, availableActions, webViewController;

#pragma mark - Initialization

- (id)initWithAddress:(NSString*)urlString {

    return [self initWithURL:[NSURL URLWithString:urlString]];
}

- (id)initWithURL:(NSURL *)URL {
    self.webViewController = [[SVWebViewController alloc] initWithURL:URL];
    if (self = [super initWithRootViewController:self.webViewController]) {
        self.webViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:webViewController action:@selector(doneButtonClicked:)];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    
    //self.navigationBar.tintColor = self.barsTintColor;
    
    //change to black color
    self.navigationBar.tintColor = [UIColor blackColor];
    //set title to say "News"
    self.webViewController.navigationItem.title = @"News";
    
    webViewController.navigationItem.rightBarButtonItem = self.returnFavoriteButton;
    
    NSLog(@"Article info: %@", self.articleInfoForFavorites);
}

- (void)setAvailableActions:(SVWebViewControllerAvailableActions)newAvailableActions {
    self.webViewController.availableActions = newAvailableActions;
}

#pragma mark - Utility methods for Favorite Adding Ability

/*******************************************************************************
 * @method      returnFavoriteButton
 * @abstract
 * @description if article is in favorites array, return filled star, otherwise return empty star
 *******************************************************************************/

-(UIBarButtonItem*)returnFavoriteButton
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary* favArticles = [[defaults dictionaryForKey:@"favoriteArticles"] mutableCopy];
    self.favoriteArticlesforAmendment = [favArticles objectForKey: self.keyForAmendment];
    
    if ( ![self.favoriteArticlesforAmendment containsObject:self.articleInfoForFavorites] ) {
        
        UIBarButtonItem *emptyStar = [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"emptystar"] showsTouchWhenHighlighted:NO target:self action:@selector(toggleFavoriteAction:)];
        NSLog(@"Initialized with emptystar");
        return emptyStar;
        
    }
    
    //else:
    UIBarButtonItem *filledStar = [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"filledstar"]showsTouchWhenHighlighted:NO target:self action:@selector(toggleFavoriteAction:)];
    NSLog(@"Initialized with filledstar");
    return filledStar;
    
}

/*******************************************************************************
 * @method      toggleFavoriteAction
 * @abstract
 * @description
 *******************************************************************************/

-(void)toggleFavoriteAction:(UIBarButtonItem *)sender
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary* favArticles = [[defaults dictionaryForKey:@"favoriteArticles"] mutableCopy];
    if(!favArticles)
        favArticles = [NSMutableDictionary dictionaryWithCapacity:1];
    
    self.favoriteArticlesforAmendment = [[favArticles objectForKey: self.keyForAmendment] mutableCopy];
    if (!self.favoriteArticlesforAmendment)
        self.favoriteArticlesforAmendment = [NSMutableArray arrayWithCapacity:1];
    
    if ( ![self.favoriteArticlesforAmendment containsObject:self.articleInfoForFavorites] ) {
        
        [self.favoriteArticlesforAmendment addObject: self.articleInfoForFavorites];
        
        //change "Did add favorites" to 1 in the plist stored in the documents directory
        if( [[defaults objectForKey:@"Did add favorites"] isEqualToString:@"0"] ) { //if "Did add favorites is 0
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *path = [documentsDirectory stringByAppendingPathComponent:@"UserDefaults.plist"];
            NSDictionary *updatedDefaults = @{ @"kInitialRun" : [defaults objectForKey:@"kInitialRun"], @"Did add favorites" : @"1" };
            [updatedDefaults writeToFile:path atomically:YES];
            NSLog(@"Updated defaults: %@", updatedDefaults);
            [defaults registerDefaults:updatedDefaults];
            [defaults synchronize];
            NSLog(@"updated NSUserDefaults: %@", [[NSUserDefaults standardUserDefaults]
                                                  dictionaryRepresentation]);
        }
        
        //sort array by Amendment Index
        
        /*
        [self.favoriteAmendmentsInSection sortUsingComparator:^(NSDictionary* dict1, NSDictionary* dict2) {
            
            return [[dict1 objectForKey:@"#"] compare:[dict2 objectForKey:@"#"]];
            
        }];
         
        */
        
        UIBarButtonItem *filledStar = [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"filledstar"]showsTouchWhenHighlighted:NO target:self action:@selector(toggleFavoriteAction:)];
        
        webViewController.navigationItem.rightBarButtonItem = filledStar;
        
        NSLog(@"Adding %@", [self.articleInfoForFavorites objectForKey:@"Article Title"]);
        
    }
    
    else {
        
        [self.favoriteArticlesforAmendment removeObject: self.articleInfoForFavorites];
        
        UIBarButtonItem *emptyStar = [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"emptystar"] showsTouchWhenHighlighted:NO target:self action:@selector(toggleFavoriteAction:)];
        webViewController.navigationItem.rightBarButtonItem = emptyStar;
        NSLog(@"Removing %@", [self.articleInfoForFavorites objectForKey:@"Article Title"]);
        
    }
    
    //update favArticles with new article List
    [favArticles setObject: self.favoriteArticlesforAmendment forKey:self.keyForAmendment];
    
    // Reset the favoriteArticles userDefaults dictionary
    [defaults setObject:favArticles forKey:@"favoriteArticles"];
    [defaults synchronize];
    
    //Log it out for debugging
    NSLog(@" Defaults--- %@", [defaults objectForKey:@"favoriteArticles"]);
}

@end
