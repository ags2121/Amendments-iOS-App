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
    NSMutableArray* favArticles = [[defaults arrayForKey:@"favoriteArticles"] mutableCopy];
    self.favoriteArticlesforAmendment = [favArticles[_amendmentNumber] mutableCopy];
    
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
    NSMutableArray* favArticles = [[defaults arrayForKey:@"favoriteAmendments"] mutableCopy];
    
    if (!favArticles)
        favArticles = [NSMutableArray arrayWithObjects: [NSMutableArray arrayWithCapacity:1] ,[NSMutableArray arrayWithCapacity:1], nil ];
    
    self.favoriteAmendmentsInSection = [favAmendments[_sectionOfAmendment] mutableCopy];
    
    if ( ![self.favoriteAmendmentsInSection containsObject:self.amendmentCellData] ) {
        
        [self.favoriteAmendmentsInSection addObject: self.amendmentCellData];
        
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
        [self.favoriteAmendmentsInSection sortUsingComparator:^(NSDictionary* dict1, NSDictionary* dict2) {
            
            return [[dict1 objectForKey:@"#"] compare:[dict2 objectForKey:@"#"]];
            
        }];
        
        UIBarButtonItem *filledStar = [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"filledstar"]showsTouchWhenHighlighted:NO target:self action:@selector(toggleFavoriteAction:)];
        
        self.navigationItem.rightBarButtonItem = filledStar;
        
        NSLog(@"Adding %@", self.title);
        
    }
    
    else {
        
        [self.favoriteAmendmentsInSection removeObject: self.amendmentCellData];
        
        UIBarButtonItem *emptyStar = [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"emptystar"] showsTouchWhenHighlighted:NO target:self action:@selector(toggleFavoriteAction:)];
        self.navigationItem.rightBarButtonItem = emptyStar;
        NSLog(@"Removing %@", self.title);
        
    }
    
    // Reset the favoriteAmendments userDefaults array
    favAmendments[_sectionOfAmendment] = self.favoriteAmendmentsInSection;
    [defaults setObject:favArticles forKey:@"favoriteAmendments"];
    [defaults synchronize];
    
    // Log it out for debugging
    //NSLog(@" Defaults--- %@", [defaults objectForKey:@"favoriteAmendments"]);
    
}


@end
