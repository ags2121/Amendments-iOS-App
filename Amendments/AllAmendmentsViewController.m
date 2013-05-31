//
//  AllAmendmentsViewController.m
//  Amendments
//
//  Created by Alex Silva on 2/28/13.
//  Copyright (c) 2013 Alex Silva. All rights reserved.
//

#import "AllAmendmentsViewController.h"
#import "AllAmendmentsCellData.h"
#import "AmendmentsCell.h"
#import "AllAmendmentsText.h"
#import "SingleAmendmentViewController.h"
#import "MYIntroductionPanel.h"

@interface AllAmendmentsViewController ()

@end

@implementation AllAmendmentsViewController

-(NSArray*)amendmentsTableData
{
    if (!_amendmentsTableData){
        AllAmendmentsCellData* data = [[AllAmendmentsCellData alloc] init];
        _amendmentsTableData = data.cellData;
    }
        return _amendmentsTableData;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Make tableVC's background see through to the parent view
    self.view.backgroundColor = [UIColor clearColor];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.amendmentsTableData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.amendmentsTableData[section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if(section == 0)
        return @"Bill of Rights";
    else
        return @"Later Amendments";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"amendmentCell";
    AmendmentsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSArray *section = self.amendmentsTableData[indexPath.section];
    
    //get dictionary key/value pairs for amendment at this index
    NSDictionary *current = section[indexPath.row];
    
    // Configure the cell...
    cell.amendmentIcon.image = [UIImage imageNamed: [current objectForKey:@"icon"]];
    cell.amendmentNumber.text = [current objectForKey:@"amendmentNumber"];
    cell.amendmentSubtitle.text = [current objectForKey:@"subtitle"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72;
}

/*Use this method if you need to change the positions of any objects on the cell when switching orientations
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    for (AmendmentsCell *cell in [self.tableView visibleCells]) {
        
        if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
            //NSLog(@"Table is going to landscape");
            cell.amendmentNumber.transform = CGAffineTransformTranslate(cell.amendmentNumber.transform, -80, 0);
            cell.amendmentSubtitle.transform = CGAffineTransformTranslate(cell.amendmentSubtitle.transform, -80, 0);
        }
        
        else{
            cell.amendmentNumber.transform = CGAffineTransformTranslate(cell.amendmentNumber.transform, 80, 0);
            cell.amendmentSubtitle.transform = CGAffineTransformTranslate(cell.amendmentSubtitle.transform, 80, 0);
        }
    }
    [self.tableView reloadData];
}
 */

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
}


#pragma mark - Table view delegate

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender

{
    //get reference to Singleton class which holds data on the Amendments
    AllAmendmentsText* sharedsingleton = [AllAmendmentsText sharedInstance];
    
    if([[segue identifier] isEqualToString:@"segueToAmendmentDetail"]){
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        //get dictionary data from cell in selected section, in selected row, from the singleton amendment data object
        NSDictionary *selectedAmendmentData = [(sharedsingleton.amendmentsData)[indexPath.section] objectAtIndex:indexPath.row];
        NSLog(@"Object for key: %@", [selectedAmendmentData objectForKey:@"Title"]);
        SingleAmendmentViewController *savc = [segue destinationViewController];
        savc.amendmentData = selectedAmendmentData;
        
        //pass along section and row info to the next VC
        savc.sectionOfAmendment = indexPath.section;
        
        //pass along amendment Cell data, to be used if adding Amendment to dictionary of favorites in the next VC
        savc.amendmentCellData = self.amendmentsTableData[indexPath.section][indexPath.row];
        
        //pass along whether view controller was in landscape or not
        UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
        if (currentOrientation == UIInterfaceOrientationLandscapeLeft || currentOrientation == UIInterfaceOrientationLandscapeRight)
            savc.parentViewControllerWasInLandscape = YES;
        
        savc.shortTitle = [self.amendmentsTableData[indexPath.section][indexPath.row] objectForKey:@"amendmentNumber"];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"segueToAmendmentDetail" sender:self];
}

@end
