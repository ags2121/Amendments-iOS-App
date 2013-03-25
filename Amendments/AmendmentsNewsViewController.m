//
//  AmendmentsNewsViewController.m
//  Amendments
//
//  Created by Alex Silva on 3/2/13.
//  Copyright (c) 2013 Alex Silva. All rights reserved.
//

#import "AmendmentsNewsViewController.h"
#import "GTMHTTPFetcher.h"
#import "NewsFeedCell.h"
#import "NewsFeeds.h"
#import "SVWebViewController.h"
#import "AmendmentsAppDelegate.h"

@interface AmendmentsNewsViewController ()

@property BOOL didJustShowUIAlertNoData;
@property BOOL didJustShowDefaultArticle;

@end

@implementation AmendmentsNewsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Make tableVC's background see through to the parent view
    self.view.backgroundColor = [UIColor clearColor];
    
    //Set VC title
    self.title = [NSString stringWithFormat:@"%@ News", self.keyForFeed];
    
    //Give VC's tableview a blank footer to stop from displaying extraneous cell separators
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    //register VC as accepting of notifications named "DidLoadDataFromSingleton" from NewsFeed singleton
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadTable:)
                                                 name:@"DidLoadDataFromSingleton"
                                               object:nil];
    
    //register VC as accepting of notifications named "CouldNotConnectToFeed" from NewsFeed singleton
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showUIAlert:)
                                                 name:@"CouldNotConnectToFeed"
                                               object:nil];
    
    //register VC as accepting of notifications named "NoDataInFeed" from NewsFeed singleton
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showUIAlert:)
                                                 name:@"NoDataInFeed"
                                               object:nil];
    
    //retrieve individual news Feed from global pool of previously retrieved new feeds
    NewsFeeds* allNewsFeeds = [NewsFeeds sharedInstance];
    
    //NSLog(@"newsFeed: %@", [allNewsFeeds.individualNewsFeeds objectForKey:self.keyForFeed]);
    
    //if we've never instantiated this feed...
    if(![allNewsFeeds.individualNewsFeeds objectForKey:self.keyForFeed]) {
        
        //hide tableview while loading
        [self.tableView setHidden:YES];
        
        //load the feed from the Singleton NewsFeeds
        [allNewsFeeds loadNewsFeed:self.finalURL forAmendment:self.keyForFeed forTableViewController:self];
        
    }
    else{
        NewsFeeds* allNewsFeeds = [NewsFeeds sharedInstance];
        self.feed = [allNewsFeeds.individualNewsFeeds objectForKey:self.keyForFeed];
        [self.tableView reloadData];
    }
    
    //Set up refreshAction
    UIRefreshControl *pullToRefresh = [[UIRefreshControl alloc] init];
    pullToRefresh.tintColor = [UIColor blackColor];
    [pullToRefresh addTarget:self action: @selector(refreshTable) forControlEvents: UIControlEventValueChanged];
    
    self.refreshControl = pullToRefresh;

}

-(void) viewWillAppear:(BOOL)animated
{
    
    if(self.didJustShowDefaultArticle){
        NSLog(@"ViewDidLoad and didJustShowDefaultArticle");
        self.didJustShowDefaultArticle = NO;
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    NewsFeeds* allNewsFeeds = [NewsFeeds sharedInstance];
    self.feed = [allNewsFeeds.individualNewsFeeds objectForKey:self.keyForFeed];
    [self.tableView reloadData];
    
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    NSLog(@"Number of rows in section: %u", self.feed.count);
    return self.feed.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"newsFeedCell";
    NewsFeedCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.backgroundColor = [UIColor whiteColor];
    
    //TITLE and PUBLICATION
    NSLog(@"Working on cell: %d", indexPath.row);
    NSDictionary *article = self.feed[indexPath.row];
    NSArray *titleAndPub = [self formatIntoTitleAndPub: [article objectForKey:@"title"]];
    
    cell.articleTitle.text = [titleAndPub objectAtIndex:0];
    cell.articlePublication.text = [titleAndPub objectAtIndex:1];
    
    //DATE
    NSString *originalDate = [article objectForKey:@"pubDate"];
    
    NSString *splitSliceJoinDate = [ [ [[originalDate componentsSeparatedByString:@" "] mutableCopy] subarrayWithRange:NSMakeRange(0, 4) ] componentsJoinedByString:@" " ];
    
    cell.articleDate.text = splitSliceJoinDate;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

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
    
    NSDictionary *article = self.feed[indexPath.row];
    
    NSString* trimmedURL = [self formatURL:[article objectForKey:@"link"]];
    
    NSLog(@"Trimmed URL: %@", trimmedURL);
    
    NSURL* finalURL = [NSURL URLWithString:trimmedURL];
    
    //package cell display information so that the webview can save this info to add to the favorites arrsay
    NSString* articleTitleforFav = [[(NewsFeedCell*)[self.tableView cellForRowAtIndexPath:indexPath] articleTitle] text];
    NSString* articlePubforFav = [[(NewsFeedCell*)[self.tableView cellForRowAtIndexPath:indexPath] articlePublication] text];
    NSString* articleDateForFav = [[(NewsFeedCell*)[self.tableView cellForRowAtIndexPath:indexPath] articleDate] text];
    NSString* articleTrimmedURLforFav = trimmedURL;
    
    //add cell display info to dictionary to pass to modalWebView VC
    NSDictionary *articleDisplayInfoforCell = @{@"Article Title" : articleTitleforFav, @"Article Publication" : articlePubforFav, @"Article Date" : articleDateForFav, @"Article URL String" : articleTrimmedURLforFav};
    
    SVModalWebViewController *webViewController = [[SVModalWebViewController alloc] initWithURL:finalURL];
    webViewController.articleInfoForFavorites = articleDisplayInfoforCell;
    
    //append amendment number to beginning for keyForFeed string
    webViewController.keyForAmendment = [NSString stringWithFormat:@"%d|%@", self.amendmentNumberForSorting, self.keyForFeed];
    [self presentViewController:webViewController animated:YES completion:nil];
}

#pragma mark - Utility methods

/*******************************************************************************
 * @method      formatIntoTitleAndPub
 
 * @abstract
 * @description The title contains both the article title and the publication,
 so we need to split and trim the string into two different strings
 *******************************************************************************/

-(NSArray *)formatIntoTitleAndPub:(NSString *)input
{
    
    //SPLIT
    NSArray *splitWords = [input componentsSeparatedByString:@" - "];
    
    NSString *newTitle = [[splitWords objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSString *newPub = [[splitWords objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    //TRIM
    NSString *trimmedPub;
    if ([newPub rangeOfString:@" (press release)"].location != NSNotFound){
        
        NSLog(@"pub title contains (press release)");
        trimmedPub = [newPub substringToIndex:[newPub rangeOfString:@" (press release)"].location];
    }
    else if ([newPub rangeOfString:@" (blog)"].location != NSNotFound){
        
        NSLog(@"pub title contains (blog)");
        trimmedPub = [newPub substringToIndex:[newPub rangeOfString:@" (blog)"].location];
    }
    else if ([newPub rangeOfString:@" (subscription)"].location != NSNotFound){
        
        NSLog(@"pub title contains (subscription)");
        trimmedPub = [newPub substringToIndex:[newPub rangeOfString:@" (subscription)"].location];
    }
    else(trimmedPub = newPub);
    
    NSArray *result = [[NSArray alloc] initWithObjects: newTitle, trimmedPub, nil];
    
    return result;
    
}

/*******************************************************************************
 * @method      formatURL
 * @abstract
 * @description feed pulls URLs which are prefixed with a googlenews URL, so this
                gets rid of the google url
 *******************************************************************************/

-(NSString*)formatURL:(NSString*)inputURL
{
    NSArray *splitURL = [inputURL componentsSeparatedByString:@"&url="];
    return splitURL[1];
}

/*******************************************************************************
 * @method      loadTable
 * @abstract
 * @description receives notifications from the NewsFeed singleton when feed download 
                has completed
 *******************************************************************************/

- (void)loadTable:(NSNotification *)notif
{
    NSLog(@"loading table");
    
    //retrieve the feed and set it equal to this class's feed variable
    NewsFeeds* allNewsFeeds2 = [NewsFeeds sharedInstance];
    self.feed = [allNewsFeeds2.individualNewsFeeds objectForKey:self.keyForFeed];
    
    //NSLog(@"newsFeed after loading: %@", self.feed);
    
    //reload the table
    [self.tableView reloadData];
    
    //Unhide tableview
    [self.tableView setHidden:NO];
    
    // Remove the UIRefreshControll spinner on the table
    if(self.refreshControl.isRefreshing){
        [self.refreshControl endRefreshing];
    }
}
/*******************************************************************************
 * @method      refreshTable
 * @abstract
 * @description gets an instance of the Singleton feed data loading class and makes it load new data
 *******************************************************************************/

-(void)refreshTable
{
    
    //retrieve individual news Feed from global pool of previously retrieved new feeds
    NewsFeeds* allNewsFeeds = [NewsFeeds sharedInstance];
    
    //load the feed from the Singleton NewsFeeds
    [allNewsFeeds loadNewsFeed:self.finalURL forAmendment:self.keyForFeed forTableViewController:self];
    
}

/*******************************************************************************
 * @method      showUIAlert
 * @abstract
 * @description will present a UIAlertView that either indicates there was a connection error
                or that there is no data in the feed
 *******************************************************************************/

-(void)showUIAlert:(NSNotification *)notif
{
    NSString* alertMessage;
    
    if ([notif.name isEqualToString:@"CouldNotConnectToFeed"]) alertMessage = @"Could not connect to feed.\nPlease check internet connection.";
    
    else if([notif.name isEqualToString:@"NoDataInFeed"]) alertMessage = [NSString stringWithFormat:@"No recent %@ articles!", self.keyForFeed];

    UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:alertMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [av show];
    
}

/*******************************************************************************
 * @method      alertView
 * @abstract
 * @description implemented because this VC is a UIAlertView delegate, pops us back to the prior VC
 *******************************************************************************/

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

        NSLog(@"user pressed OK for alertView in NewsViewController");

    //Often there are no Third Amendment articles, so here we show the user a funny Onion article on Third Amendment rights lobbyists. Within this VC's viewWillAppear method, we check to see if the didJustShowDefaultArticle BOOL property is YES. If it is, then once the user dismisses the modal webviewcontroller, this VC sets the BOOL back to NO and pops back to the prior view.
    if([self.keyForFeed isEqualToString: @"Third Amendment"]){
        
        self.didJustShowDefaultArticle = YES;
        
        SVModalWebViewController *webViewController = [[SVModalWebViewController alloc] initWithAddress: @"http://www.theonion.com/articles/third-amendment-rights-group-celebrates-another-su,2296/?ref=auto"];

        [self presentViewController:webViewController animated:YES completion:nil];
        
    }
    else{
        //TODO: find default articles for other obscure amendments
        //for now, just pop back if there are no articles for the other amendments
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
