//
//  FavoritesViewController.m
//  Amendments
//
//  Created by Alex Silva on 2/28/13.
//  Copyright (c) 2013 Alex Silva. All rights reserved.
//

#import "FavoritesViewController.h"
#import "FavoritesCell.h"
#import "AllAmendmentsText.h"
#import "SingleAmendmentViewController.h"
#import "SVWebViewController.h"

@interface FavoritesViewController ()

@property(strong,nonatomic) NSMutableDictionary *favoriteArticles;
@property(strong,nonatomic) NSArray *favoriteArticlesSortedByKey;

@end

@implementation FavoritesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Make tableVC's background see through to the parent view
    self.view.backgroundColor = [UIColor clearColor];
    
    //Give VC's tableview a blank footer to stop from displaying extraneous cell separators
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self checkIfUserHasEverAddedFavorites];
    [self fetchAndSortFavorites];
    
    //if there is no data, disable scrolling since otherwise there is an errant cell border that looks messy
    if (self.tableView.visibleCells.count==0) self.tableView.scrollEnabled = NO;
    else self.tableView.scrollEnabled = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - viewWillAppear methods

/***********************************************************
 * @method:     checkIfUserHasEverAddedFavorites
 * @abstract:   if user has never added favorites, i.e. never changed the value set to 0 in the initial launch to 1 (keyed on "Did add favorites" in UserDefaults), then show a UIAlertView that tells the user to add some favorites.
 * @see: alertView:clickedButtonAtIndex:
 **********************************************************/
-(void)checkIfUserHasEverAddedFavorites
{
    NSLog(@"Did user add favorites == %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"Did add favorites"]);

    if ( [[[NSUserDefaults standardUserDefaults] objectForKey:@"Did add favorites"] isEqualToString:@"0"] ) {
        NSLog(@"User hasn't added favorites");
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Add your favorite articles!" message:@"You can collect favorite articles here by selecting the empty star in the upper right corner of each article." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
    }
}

/***********************************************************
 * @method:     fetchAndSortFavorites
 * @abstract:   fetches the favorites dictionary from UserDefaults and sorts the dictionary by each entries key. Each key is prefixed by the amendment number the article corresponds to, so we grab that bit and sort by that and place it into an array favoriteArticlesSortedByKey which populates the tableview.
 **********************************************************/
-(void)fetchAndSortFavorites
{
    //retrieve fav articles from NSDefaults
    self.favoriteArticles = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"favoriteArticles"] mutableCopy];
    
    //sort articles by key
    NSArray *unsortedKeys = [self.favoriteArticles allKeys];
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    [nf setNumberStyle:NSNumberFormatterDecimalStyle];
    self.favoriteArticlesSortedByKey = [unsortedKeys sortedArrayUsingComparator:^(NSString *obj1, NSString *obj2) {
        
        NSArray *splitWords1 = [obj1 componentsSeparatedByString:@"|"];
        NSArray *splitWords2 = [obj2 componentsSeparatedByString:@"|"];
        
        NSNumber *key1 = [nf numberFromString: splitWords1[0]];
        NSNumber *key2 = [nf numberFromString: splitWords2[0]];
        
        return [key1 compare:key2];
    }];
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.favoriteArticlesSortedByKey count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = [self.favoriteArticlesSortedByKey objectAtIndex:section];
    return [[self.favoriteArticles objectForKey:key] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{    
    NSString *key = [self.favoriteArticlesSortedByKey objectAtIndex:section];
    NSArray *splitWords1 = [key componentsSeparatedByString:@"|"];
    NSArray *splitWords2 = [splitWords1[1] componentsSeparatedByString:@" "];
    return splitWords2[0];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"favoritesCell";
    FavoritesCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSString *key = [self.favoriteArticlesSortedByKey objectAtIndex:indexPath.section];
    NSArray *articlesForAmendment = [self.favoriteArticles objectForKey:key];
    NSDictionary *current = articlesForAmendment[indexPath.row];
    
    cell.articleTitle.text = [current objectForKey:@"Article Title"];
    cell.articlePublication.text = [current objectForKey:@"Article Publication"];
    cell.articleDate.text = [current objectForKey:@"Article Date"];
    cell.articleTitle.numberOfLines = [self howManyLinesOfText: cell.articleTitle];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        //remove cell from table data and reset local dictionary of favorite Articles
        NSString *key = [self.favoriteArticlesSortedByKey objectAtIndex:indexPath.section];
        NSMutableArray *editedFavoriteArticlesForAmendment = [[self.favoriteArticles objectForKey:key] mutableCopy];
        [editedFavoriteArticlesForAmendment removeObjectAtIndex: indexPath.row];
        [self.favoriteArticles setObject:editedFavoriteArticlesForAmendment forKey:key];
        
        [self.tableView reloadData];
        
        //remove amendment from NSUserDefaults by resetting NSUserdefaults dictionary with local dictionary
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:self.favoriteArticles forKey:@"favoriteArticles"];
        [defaults synchronize];
        
        //if there's no more cells, dont let user scroll since there's an a weird floating cell edge on top
        if (self.tableView.visibleCells.count==0) self.tableView.scrollEnabled = NO;
    }
}

//Changes text for delete button on cells
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Remove";
}


#pragma mark - Table view delegate

/***********************************************************
 * @method:     tableView:heightForRowAtIndexPath:
 * @abstract:   an important implementation of a TableView delegate method that allows the Favorite Cell to dynamically change its height based on how tall the article title text is in different orientations.
 **********************************************************/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = [self.favoriteArticlesSortedByKey objectAtIndex:indexPath.section];
    NSArray *articlesForAmendment = [self.favoriteArticles objectForKey:key];
    NSDictionary *current = articlesForAmendment[indexPath.row];
    CGSize size;
    
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)){
        size = [ [current objectForKey:@"Article Title"]
                sizeWithFont:[UIFont boldSystemFontOfSize:16]
                constrainedToSize:CGSizeMake(438, 9999)];
    }
    
    else{
        size = [ [current objectForKey:@"Article Title"]
                sizeWithFont:[UIFont boldSystemFontOfSize:16]
                constrainedToSize:CGSizeMake(278, 9999)];
    }
    
    return size.height + 54;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = [self.favoriteArticlesSortedByKey objectAtIndex:indexPath.section];
    NSArray *articlesForAmendment = [self.favoriteArticles objectForKey:key];
    NSDictionary *infoForSelectedArticle = articlesForAmendment[indexPath.row];
    NSURL *URLforwebview = [NSURL URLWithString: [infoForSelectedArticle objectForKey:@"Article URL String"]];
    
    SVModalWebViewController *webViewController = [[SVModalWebViewController alloc] initWithURL: URLforwebview];
    webViewController.articleInfoForFavorites = infoForSelectedArticle;
    webViewController.loadFavoriteButton = YES;
    
    //append amendment number to beginning for keyForFeed string
    webViewController.keyForAmendment = key;
    [self presentViewController:webViewController animated:YES completion:nil];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, tableView.frame.size.width, 18)];
    [label setFont:[UIFont boldSystemFontOfSize:14]];
    label.textColor = [UIColor whiteColor];
    NSString *string = [self tableView:tableView titleForHeaderInSection:section];
    
    [label setText:string];
    [view addSubview:label];
    view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.9f];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ( [tableView.dataSource tableView:tableView numberOfRowsInSection:section] == 0) return 0;
    return 22;
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.tableView reloadData];
}

#pragma mark - UIAlert view delegate 

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"User was alerted that they haven't added any favorites yet from the FavoritesViewController");
    self.tabBarController.selectedIndex = 0; //pop user back to list of Amendments
}

#pragma mark - Utility methods

/***********************************************************
 * @method:     howManyLinesOfText
 * @abstract:   returns how many lines a given string will have when fit to its Label's dimensions. This value is used to set an initial number of lines for a given cell's article title
 **********************************************************/
-(NSInteger)howManyLinesOfText:(UILabel*)label
{
    CGRect requiredSize2 = [label.text boundingRectWithSize: label.frame.size options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: label.font} context:nil];
    
//    CGSize requiredSize = [label.text sizeWithFont:label.font constrainedToSize: label.frame.size lineBreakMode:label.lineBreakMode];

    NSInteger charSize = label.font.lineHeight;
    NSInteger rHeight = requiredSize2.size.height;

    return floor(rHeight/charSize);
}

@end
