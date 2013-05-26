//
//  SingleAmendmentViewController.m
//  Amendments
//
//  Created by Alex Silva on 3/1/13.
//  Copyright (c) 2013 Alex Silva. All rights reserved.
//

#import "SingleAmendmentViewController.h"
#import "MoreOptionsTableViewCell.h"
#import "AmendmentsNewsViewController.h"
#import "CustomIconButton.h"
#import "ExtendedSummaryViewController.h"
#import "OriginalTextViewController.h"

@interface SingleAmendmentViewController ()

//The template URL whose keywords we replace with the particular queries used for the specific amendment
@property (strong, nonatomic) NSString *templateURL;
@property (strong, nonatomic) NSString *finalURL;
@property (strong, nonatomic) NSString *queryKeyword1;
@property (strong, nonatomic) NSString *queryKeyword2;
@property (strong, nonatomic) NSMutableArray *favoriteAmendmentsInSection;

@end

@implementation SingleAmendmentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*
     Initialize template URL
     specifies location as "America"
     */
    _templateURL = @"http://pipes.yahoo.com/pipes/pipe.run?_id=46bf5af81d4dd0d2c4e267e2fca1af34&_render=json&feedcount=100&feedurl=https%3A%2F%2Fnews.google.com%2Fnews%2Ffeeds%3Fgl%3Dus%26hl%3Den%26as_occt%3Dtitle%26as_qdr%3Da%26as_nloc%3DAmerica%26authuser%3D0%26q%3Dallintitle%3A%2B%2522*%2Bamendment%2522%2BOR%2B%2522¥%2Bamendment%2522%2Blocation%3AAmerica%26um%3D1%26ie%3DUTF-8%26output%3Drss%26num%3D50";
    
    //set Title for VC
    //self.title = [self.amendmentData objectForKey:@"Title"]; /*long title, if wanted (i.e. "First Amendment")*/
    self.title = self.shortTitle;
    
    //set text for UIlabels
    self.summary.text = [self.amendmentData objectForKey:@"Summary"];
    
    //set values for the query keywords
    self.queryKeyword1 = [[self.amendmentData objectForKey:@"queryKeywords"] objectAtIndex:0];
    self.queryKeyword2 = [[self.amendmentData objectForKey:@"queryKeywords"] objectAtIndex:1];
    
    //construct specified URL using keywords
    NSString* urlNew = [self.templateURL stringByReplacingOccurrencesOfString:@"*" withString:self.queryKeyword1];
    self.finalURL = [urlNew stringByReplacingOccurrencesOfString:@"¥" withString:self.queryKeyword2];
    NSLog(@"URL for query: %@", self.finalURL);
}

-(void)viewWillAppear:(BOOL)animated
{
    //add Custom Favorite button, using category (see utility method "returnFavoriteButton")
    //self.navigationItem.rightBarButtonItem = [self returnFavoriteButton];
}

-(void) viewDidAppear:(BOOL)animated
{

    [super viewDidAppear:animated];
    //make sure selected row fades out when user goes back to the Single Amendment VC
    [self.optionsTableView deselectRowAtIndexPath:[self.optionsTableView indexPathForSelectedRow] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row==0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"moreOptionsCell1" forIndexPath:indexPath];
        return cell;
    }
    
    if(indexPath.row==1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"moreOptionsCell2" forIndexPath:indexPath];
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"moreOptionsCell3" forIndexPath:indexPath];
    UILabel *cellLabel = (UILabel *)[cell viewWithTag:1];
    cellLabel.text = [NSString stringWithFormat:@"%@ News", [self.amendmentData objectForKey:@"Title"]];

    return cell;
}

#pragma mark - Table view delegate

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender

{
    if([[segue identifier] isEqualToString:@"extendedSummarySegue"]){
        ExtendedSummaryViewController* esvc = [segue destinationViewController];
        NSString *path = [[NSBundle mainBundle] pathForResource: [self.amendmentData objectForKey:@"extendedSummaryHTMLpath"] ofType:@"html"];
        NSString *htmlString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        NSLog(@"htmlString: %@", htmlString);
        esvc.htmlString = htmlString;
        esvc.title = self.shortTitle;

    }
    
    if([[segue identifier] isEqualToString:@"originalTextSegue"]){
        
        OriginalTextViewController* otvc = [segue destinationViewController];
        NSString *path = [[NSBundle mainBundle] pathForResource: [self.amendmentData objectForKey:@"originalTextHTMLpath"] ofType:@"html"];
        NSString *htmlString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        //NSLog(@"htmlString: %@", htmlString);
        otvc.htmlString = htmlString;
        otvc.title = self.shortTitle;
    }
    
    if([[segue identifier] isEqualToString:@"newsSegue"]){
        AmendmentsNewsViewController* anvc = [segue destinationViewController];
        anvc.finalURL = self.finalURL;
        //ex. keyForFeed = "First Amendment"
        anvc.keyForFeed = [self.amendmentData objectForKey:@"Title"];
        anvc.amendmentNumberForSorting = [[self.amendmentCellData objectForKey:@"#"] intValue];
        NSLog(@"Amendment number for sorting: %d", anvc.amendmentNumberForSorting);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) [self performSegueWithIdentifier:@"extendedSummarySegue" sender:self];
    if (indexPath.row==1) [self performSegueWithIdentifier:@"originalTextSegue" sender:self];
    if (indexPath.row==2) [self performSegueWithIdentifier:@"newsSegue" sender:self];
}

@end
