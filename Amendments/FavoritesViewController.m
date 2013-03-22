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

@interface FavoritesViewController ()

@property(strong,nonatomic) NSMutableArray *favoriteAmendments;

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
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Add your favorite amendments!" message:@"You can put your favorite amendments here by touching the empty star in the upper right corner\n of each amendment menu." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
    }
    
    _favoriteAmendments = [[defaults arrayForKey:@"favoriteAmendments"] mutableCopy];
    [self.tableView reloadData];
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
    return self.favoriteAmendments.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [self.favoriteAmendments[section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if(section == 0)
        return @"Bill of Rights";
    else
        return @"Later Amendments";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"favoritesCell";
    FavoritesCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSArray *section = self.favoriteAmendments[indexPath.section];
    
    //get dictionary key/value pairs for amendment at this index
    NSDictionary *current = section[indexPath.row];
    
    // Configure the cell...
    cell.favoritesImage.image = [UIImage imageNamed: [current objectForKey:@"icon"]];
    cell.favoritesTitle.text = [current objectForKey:@"amendmentNumber"];
    cell.favoritesSubtitle.text = [current objectForKey:@"subtitle"];
    
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
        
        //remove cell from table
        NSMutableArray *editedFavorites = [self.favoriteAmendments[indexPath.section] mutableCopy];
        [editedFavorites removeObjectAtIndex:indexPath.row];
        self.favoriteAmendments[indexPath.section] = editedFavorites;
        [self.tableView reloadData];
        
        //remove amendment from NSUserDefaults
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:self.favoriteAmendments forKey:@"favoriteAmendments"];
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender

{
    //get reference to Singleton class which holds data on the Amendments
    AllAmendmentsText* sharedsingleton = [AllAmendmentsText sharedInstance];
    
    if([[segue identifier] isEqualToString:@"segueToAmendmentDetailFromFavorites"]){
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        /*
         get dictionary data from cell in selected section, in selected row, from the singleton amendment data object
        the indexPath.row value will likely be a different index here
        i.e. the 8th amendment could be the 2nd tablecell in the favorites table, but its the 8th index in the
        static amendment data plist array
         
         I store an amendments actual order in a number object for key "#" in the AmendmentsCellData plist
         This comes in handle in this situation, where users are seeing a subset of the amendments
         */
        
        //retrieving numbers stored in plists is weird; you need to call this method intValue on the object
        //otherwise you get a crazy big number
        int actualRow = [ [self.favoriteAmendments[indexPath.section][indexPath.row] objectForKey:@"#"] intValue];
        
        int section = indexPath.section;
        
        NSLog(@"actual row: %d", actualRow );
        NSLog(@"actual section: %d", section);
        
        NSLog(@"Shared Singleton Data: %@", sharedsingleton.amendmentsData);
        NSLog(@"Shared Singleton Data index 0 index 6: %@", sharedsingleton.amendmentsData[section][actualRow-1]);
        
       //NSDictionary *selectedAmendmentData = [(sharedsingleton.amendmentsData)[indexPath.section] objectAtIndex:actualRow-1];
        NSDictionary *selectedAmendmentData = sharedsingleton.amendmentsData[section][actualRow-1];
        
        SingleAmendmentViewController *savc = [segue destinationViewController];
        savc.amendmentData = selectedAmendmentData;
        
        //pass along section and row info to the next VC
        savc.sectionOfAmendment = indexPath.section;
        
        //pass along amendment Cell data, to be used if adding Amendment to dictionary of favorites in the next VC
        savc.amendmentCellData = self.favoriteAmendments[indexPath.section][indexPath.row];
        
        savc.shortTitle = [self.favoriteAmendments[indexPath.section][indexPath.row] objectForKey:@"amendmentNumber"];
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self performSegueWithIdentifier:@"segueToAmendmentDetailFromFavorites" sender:self];

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
