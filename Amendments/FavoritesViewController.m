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

@end

@implementation FavoritesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Make tableVC's background see through to the parent view
    self.view.backgroundColor = [UIColor clearColor];
    
    //Give VC's tableview a blank footer to stop from displaying extraneous cell separators
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSLog(@"Did add favorites == %@", [defaults objectForKey:@"Did add favorites"]);
    
    //if we've never added favorites, i.e. never changed the value set to 0 in the initial launch to 1,
    //then show a UIAlertView that tells user to add some favorites. 
    if ( [[defaults objectForKey:@"Did add favorites"] isEqualToString:@"0"] ) {
        NSLog(@"User hasn't added favorites");
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Add your favorite articles!" message:@"You can collect favorite articles here by selecting the empty star in the upper right corner of each article." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
    }
    
    _favoriteArticles = [[defaults dictionaryForKey:@"favoriteArticles"] mutableCopy];
    [self.tableView reloadData];
    
    //if there is no data, disable scrolling since otherwise there is an errant cell border
    //that looks messy
    if (self.tableView.visibleCells.count==0) self.tableView.scrollEnabled = NO;
    else self.tableView.scrollEnabled = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    NSArray *keys = [self.favoriteArticles allKeys];
    return keys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    NSArray *unsortedKeys = [self.favoriteArticles allKeys];
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    [nf setNumberStyle:NSNumberFormatterDecimalStyle];
    NSArray *sortedKeys = [unsortedKeys sortedArrayUsingComparator:^(NSString *obj1, NSString *obj2) {
        
        NSArray *splitWords1 = [obj1 componentsSeparatedByString:@"|"];
        NSArray *splitWords2 = [obj2 componentsSeparatedByString:@"|"];
                
        NSNumber *key1 = [nf numberFromString: splitWords1[0]];
        NSNumber *key2 = [nf numberFromString: splitWords2[0]];

        return [key1 compare:key2];
    }];
    
    NSString *key = [sortedKeys objectAtIndex:section];
    return [[self.favoriteArticles objectForKey:key] count];
  
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSArray *unsortedKeys = [self.favoriteArticles allKeys];
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    [nf setNumberStyle:NSNumberFormatterDecimalStyle];
    NSArray *sortedKeys = [unsortedKeys sortedArrayUsingComparator:^(NSString *obj1, NSString *obj2) {
        
        NSArray *splitWords1 = [obj1 componentsSeparatedByString:@"|"];
        NSArray *splitWords2 = [obj2 componentsSeparatedByString:@"|"];
        
        NSNumber *key1 = [nf numberFromString: splitWords1[0]];
        NSNumber *key2 = [nf numberFromString: splitWords2[0]];
        
        return [key1 compare:key2];
    }];
    
    NSString *key = [sortedKeys objectAtIndex:section];
    NSArray *splitWords1 = [key componentsSeparatedByString:@"|"];
    NSArray *splitWords2 = [splitWords1[1] componentsSeparatedByString:@" "];
    return splitWords2[0];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"favoritesCell";
    FavoritesCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSArray *unsortedKeys = [self.favoriteArticles allKeys];
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    [nf setNumberStyle:NSNumberFormatterDecimalStyle];
    NSArray *sortedKeys = [unsortedKeys sortedArrayUsingComparator:^(NSString *obj1, NSString *obj2) {
        
        NSArray *splitWords1 = [obj1 componentsSeparatedByString:@"|"];
        NSArray *splitWords2 = [obj2 componentsSeparatedByString:@"|"];
        
        NSNumber *key1 = [nf numberFromString: splitWords1[0]];
        NSNumber *key2 = [nf numberFromString: splitWords2[0]];
        
        return [key1 compare:key2];
    }];
    
    NSString *key = [sortedKeys objectAtIndex:indexPath.section];
    NSArray *articlesForAmendment = [self.favoriteArticles objectForKey:key];
    NSDictionary *current = articlesForAmendment[indexPath.row];
    
    // Configure the cell...
    cell.articleTitle.text = [current objectForKey:@"Article Title"];
    cell.articlePublication.text = [current objectForKey:@"Article Publication"];
    cell.articleDate.text = [current objectForKey:@"Article Date"];
    
    return cell;

}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
}

// Override to support conditional editing of the table view.
// This only needs to be implemented if you are going to be returning NO
// for some items. By default, all items are editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        //fetch article data related to selected cell
        NSArray *unsortedKeys = [self.favoriteArticles allKeys];
        NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
        [nf setNumberStyle:NSNumberFormatterDecimalStyle];
        NSArray *sortedKeys = [unsortedKeys sortedArrayUsingComparator:^(NSString *obj1, NSString *obj2) {
            
            NSArray *splitWords1 = [obj1 componentsSeparatedByString:@"|"];
            NSArray *splitWords2 = [obj2 componentsSeparatedByString:@"|"];
            
            NSNumber *key1 = [nf numberFromString: splitWords1[0]];
            NSNumber *key2 = [nf numberFromString: splitWords2[0]];
            
            return [key1 compare:key2];
        }];
        
        //remove cell from table data
        NSString *key = [sortedKeys objectAtIndex:indexPath.section];
        NSMutableArray *editedFavoriteArticlesForAmendment = [[self.favoriteArticles objectForKey:key] mutableCopy];
        [editedFavoriteArticlesForAmendment removeObjectAtIndex: indexPath.row];
        [self.favoriteArticles setObject:editedFavoriteArticlesForAmendment forKey:key];
        [self.tableView reloadData];
        
        //remove amendment from NSUserDefaults
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:self.favoriteArticles forKey:@"favoriteArticles"];
        [defaults synchronize];
        
        //if there's no more cells, dont let user scroll since there's an a weird floating cell edge on top
        if (self.tableView.visibleCells.count==0) self.tableView.scrollEnabled = NO;
        
    }
}

//Changes text for delete button on cells
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Remove";
}

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *unsortedKeys = [self.favoriteArticles allKeys];
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    [nf setNumberStyle:NSNumberFormatterDecimalStyle];
    NSArray *sortedKeys = [unsortedKeys sortedArrayUsingComparator:^(NSString *obj1, NSString *obj2) {
        
        NSArray *splitWords1 = [obj1 componentsSeparatedByString:@"|"];
        NSArray *splitWords2 = [obj2 componentsSeparatedByString:@"|"];
        
        NSNumber *key1 = [nf numberFromString: splitWords1[0]];
        NSNumber *key2 = [nf numberFromString: splitWords2[0]];
        
        return [key1 compare:key2];
    }];
    
    NSString *key = [sortedKeys objectAtIndex:indexPath.section];
    NSArray *articlesForAmendment = [self.favoriteArticles objectForKey:key];
    NSDictionary *infoForSelectedArticle = articlesForAmendment[indexPath.row];
    NSURL *URLforwebview = [NSURL URLWithString: [infoForSelectedArticle objectForKey:@"Article URL String"]];
    
    SVModalWebViewController *webViewController = [[SVModalWebViewController alloc] initWithURL: URLforwebview];
    webViewController.articleInfoForFavorites = infoForSelectedArticle;
    
    //append amendment number to beginning for keyForFeed string
    webViewController.keyForAmendment = key;
    [self presentViewController:webViewController animated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ( [tableView.dataSource tableView:tableView numberOfRowsInSection:section] == 0) return 0;
    return 22;
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"User was alerted that they haven't added any favorites yet from the FavoritesViewController");
    
    //pop user back to list of Amendments
    self.tabBarController.selectedIndex = 0;
    
}



@end
