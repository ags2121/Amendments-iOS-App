//
//  AmendmentsNewsViewController.m
//  Amendments
//
//  Created by Alex Silva on 3/2/13.
//  Copyright (c) 2013 Alex Silva. All rights reserved.
//

#import "AmendmentsNewsViewController.h"
#import "NewsFeedCell.h"
#import "NewsFeeds.h"
#import "SVWebViewController.h"
#import "AmendmentsAppDelegate.h"
#import "Constants.h"

@interface AmendmentsNewsViewController ()

@property (atomic) UIInterfaceOrientation startingOrientation;
@property BOOL didJustShowUIAlertNoData;
@property BOOL didJustShowDefaultArticle;
@property (strong, nonatomic) UIImageView *defaultView;

@end

@implementation AmendmentsNewsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    if ( [viewController isEqual:self] ) {
        self.tableView.backgroundView = nil;
        NSLog(@"This should only get called in NEWS VC");
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.delegate = self;
    [self setUpView];
    [self setUpRefreshAction];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self registerNotifications];
    
    //record initial orientation
    self.startingOrientation = [UIApplication sharedApplication].statusBarOrientation;
    
    //set up default view
    if(self.didSegueFromSingleAmendmentVC) {
        [self setUpDefaultView];
        self.didSegueFromSingleAmendmentVC = NO;
    }
    
    if(self.didJustShowDefaultArticle){
        NSLog(@"ViewWillAppear and didJustShowDefaultArticle");
        self.didJustShowDefaultArticle = NO;
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        //retrieve individual news Feed from global pool of previously retrieved new feeds
        NewsFeeds* allNewsFeeds = [NewsFeeds sharedInstance];
        
        //hide tableview while loading
//        [self.tableView setHidden:YES];
        
        //load the feed from the Singleton NewsFeeds
        [allNewsFeeds loadNewsFeed:self.finalURL forAmendment:self.keyForFeed isRefreshing:NO];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [self unregisterNotifications];
    
    UIInterfaceOrientation endingOrientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if ( self.startingOrientation == UIInterfaceOrientationPortrait &&endingOrientation != self.startingOrientation ){
        [self.delegate setChildViewControllerDidRotateToLandscape:YES];
    }
    
    else if ( (self.startingOrientation == UIInterfaceOrientationLandscapeLeft || self.startingOrientation == UIInterfaceOrientationLandscapeRight)
             && endingOrientation == UIInterfaceOrientationPortrait){
        [self.delegate setChildViewControllerDidRotateToPortrait:YES];
    }
    else{
        [self.delegate setChildViewControllerDidRotateToLandscape:NO];
        [self.delegate setChildViewControllerDidRotateToPortrait:NO];
    }
    
    self.navigationController.delegate = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - viewDidLoad methods

-(void)setUpView
{
    //Make tableVC's background see through to the parent view background
//    self.view.backgroundColor = [UIColor clearColor];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.title = @"News";
    
    //Give VC's tableview a blank footer to stop from displaying extraneous cell separators
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

-(void)registerNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadTable:)
                                                 name:@"DidLoadDataFromSingleton"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showUIAlert:)
                                                 name:@"CouldNotConnectToFeed"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showUIAlert:)
                                                 name:@"NoDataInFeed"
                                               object:nil];
}

-(void)unregisterNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)setUpRefreshAction
{
    UIRefreshControl *pullToRefresh = [[UIRefreshControl alloc] init];
    pullToRefresh.tintColor = [UIColor grayColor];
    [pullToRefresh addTarget:self action: @selector(refreshTable) forControlEvents: UIControlEventValueChanged];
    self.refreshControl = pullToRefresh;
    [self.tableView addSubview:pullToRefresh];
}

-(void)setUpDefaultView
{
    UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if (IS_IPHONE_5) {
        if (currentOrientation == UIInterfaceOrientationPortrait) {
            self.defaultView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AmendmentBackgroundImage-568h@2x"]];
            [self.defaultView setFrame:self.view.superview.frame];
            self.tableView.backgroundView = self.defaultView;
        }
        else if (UIInterfaceOrientationIsLandscape(currentOrientation)) {
                self.defaultView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"newsVC_placeholder_background_landscape-568h@2x"]];
                [self.defaultView setFrame:self.view.superview.frame];
                self.tableView.backgroundView = self.defaultView;
        }
    }
    else {
    
        if (currentOrientation == UIInterfaceOrientationPortrait) {
            self.defaultView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"newsVC_placeholder_background"]];
            self.defaultView.contentMode=UIViewContentModeCenter;
            [self.defaultView setFrame:self.view.frame];
            self.tableView.backgroundView = self.defaultView;
        }
        
        else if (UIInterfaceOrientationIsLandscape(currentOrientation))
        {
            self.defaultView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"newsVC_placeholder_background_landscape"]];
            self.defaultView.contentMode=UIViewContentModeCenter;
            [self.defaultView setFrame:self.view.frame];
            self.tableView.backgroundView = self.defaultView;
        }
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"Number of rows in section: %u", self.feed.count);
    return self.feed.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"newsFeedCell";
    NewsFeedCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    //TITLE and PUBLICATION
    NSLog(@"Working on cell: %d", indexPath.row);
    NSDictionary *article = self.feed[indexPath.row];
    NSArray *titleAndPub = [self formatIntoTitleAndPub: article[@"title"][@"text"]];
    
    cell.articleTitle.text = [titleAndPub objectAtIndex:0];
    cell.articlePublication.text = [titleAndPub objectAtIndex:1];
    
    //DATE
    NSString *originalDate = article[@"pubDate"][@"text"];
    NSString *splitSliceJoinDate = [ [ [[originalDate componentsSeparatedByString:@" "] mutableCopy] subarrayWithRange:NSMakeRange(0, 4) ] componentsJoinedByString:@" " ];
    
    cell.articleDate.text = splitSliceJoinDate;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
}


#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *article = self.feed[indexPath.row];
    NSArray *titleAndPub = [self formatIntoTitleAndPub: article[@"title"][@"text"]];
    CGSize size;
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)){
         size = [ [titleAndPub objectAtIndex:0]
                   sizeWithFont:[UIFont boldSystemFontOfSize:16]
                   constrainedToSize:CGSizeMake(440, 9999)];
    }
    
    else{
        size = [ [titleAndPub objectAtIndex:0]
                       sizeWithFont:[UIFont boldSystemFontOfSize:16]
                       constrainedToSize:CGSizeMake(280, 9999)];
    }
    
    return size.height + 54;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //extract and create NSURL object for the webview
    NSDictionary *article = self.feed[indexPath.row];
    NSString* trimmedURL = [self formatURL: article[@"link"][@"text"]];
    NSURL* finalURL = [NSURL URLWithString:trimmedURL];
    
    //extract cell display information
    NSString* articleTitleForFav = [[(NewsFeedCell*)[self.tableView cellForRowAtIndexPath:indexPath] articleTitle] text];
    NSString* articlePubForFav = [[(NewsFeedCell*)[self.tableView cellForRowAtIndexPath:indexPath] articlePublication] text];
    NSString* articleDateForFav = [[(NewsFeedCell*)[self.tableView cellForRowAtIndexPath:indexPath] articleDate] text];
    NSString* articleTrimmedURLforFav = trimmedURL;
    
    //add cell display info to dictionary to pass to modalWebView VC, will be needed to saved to UserDefaults if user favorites article. See SVWebViewController for the favoriting logic
    NSDictionary *articleDisplayInfoforCell = @{@"Article Title" : articleTitleForFav, @"Article Publication" : articlePubForFav, @"Article Date" : articleDateForFav, @"Article URL String" : articleTrimmedURLforFav};
    
    //init SVModalWebViewController and pass 
    SVModalWebViewController *webViewController = [[SVModalWebViewController alloc] initWithURL:finalURL];
    webViewController.articleInfoForFavorites = articleDisplayInfoforCell;
    webViewController.titleForNavBar = @"News";
    webViewController.loadFavoriteButton = YES;
    
    //append amendment number to beginning of keyForFeed string; this property will be used for sorting favorite articles
    webViewController.keyForAmendment = [NSString stringWithFormat:@"%d|%@", self.amendmentNumberForSorting, self.keyForFeed];
    [self presentViewController:webViewController animated:YES completion:nil];
    NSLog(@"User tapped article titled: %@", articleTitleForFav);
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
    
    //REPLACE TITLE
    NSString* trimmedTitle = [newTitle stringByReplacingOccurrencesOfString:@" ..." withString:@"..."];

    
    if ([newPub rangeOfString:@"American Civil Liberties Union"].location != NSNotFound){
        
        newPub = [newPub substringToIndex:[newPub rangeOfString:@" and Information"].location];
    }
    
    //TRIM PUB part 2
    //NSString *trimmedPub;
    else if ([newPub rangeOfString:@" (press release)"].location != NSNotFound){
        
        NSLog(@"pub title contains (press release)");
        newPub = [newPub substringToIndex:[newPub rangeOfString:@" (press release)"].location];
    }
    else if ([newPub rangeOfString:@" (blog)"].location != NSNotFound){
        
        NSLog(@"pub title contains (blog)");
        newPub = [newPub substringToIndex:[newPub rangeOfString:@" (blog)"].location];
    }
    else if ([newPub rangeOfString:@" (subscription)"].location != NSNotFound){
        
        NSLog(@"pub title contains (subscription)");
       newPub = [newPub substringToIndex:[newPub rangeOfString:@" (subscription)"].location];
    }
    
    NSArray *result = [[NSArray alloc] initWithObjects: trimmedTitle, newPub, nil];
    
    return result;
}

/*******************************************************************************
 * @method      formatURL
 * @abstract    the feed pulls URLs which are prefixed with a googlenews URL, so this gets rid of the google url prefix
 *******************************************************************************/
-(NSString*)formatURL:(NSString*)inputURL
{
    NSArray *splitURL = [inputURL componentsSeparatedByString:@"&url="];
    return splitURL[1];
}

/*******************************************************************************
 * @method      refreshTable
 * @abstract    refresh action callback method; gets an instance of the Singleton
                feed data loading class and makes it load new data
 *******************************************************************************/
-(void)refreshTable
{
    //retrieve individual news Feed from global pool of previously retrieved new feeds
    NewsFeeds* allNewsFeeds = [NewsFeeds sharedInstance];
    
    //load the feed from the Singleton NewsFeeds
    [allNewsFeeds loadNewsFeed:self.finalURL forAmendment:self.keyForFeed isRefreshing:YES];
}


#pragma mark - Notification callback methods

/*******************************************************************************
 * @method      loadTable
 * @abstract    receives notifications from the NewsFeed singleton when feed download has completed
 *******************************************************************************/
- (void)loadTable:(NSNotification *)notif
{
    NSLog(@"loading table in AmendmentNewsViewController.");
    
    //retrieve the feed and set it equal to this class's feed variable
    NewsFeeds* sharedInstance = [NewsFeeds sharedInstance];
    
    self.feed = [sharedInstance.newsFeedCache objectForKey:self.keyForFeed][@"results"];
    
    //reload the table
    [self.tableView reloadData];
    
    //Unhide tableview
//    [self.tableView setHidden:NO];
    
//    [self.defaultView removeFromSuperview];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    // Remove the UIRefreshControll spinner on the table
    if(self.refreshControl.isRefreshing){
        [self.refreshControl endRefreshing];
    }
}

/*******************************************************************************
 * @method      showUIAlert
 * @abstract    will present a UIAlertView that either indicates there was a
                connection error or that there is no data in the feed
 *******************************************************************************/
-(void)showUIAlert:(NSNotification *)notif
{
    NSString* alertMessage;
    
    if ([notif.name isEqualToString:@"CouldNotConnectToFeed"]) alertMessage = @"Could not connect to feed.\nPlease check internet connection.";
    
    else if([notif.name isEqualToString:@"NoDataInFeed"]) alertMessage = [NSString stringWithFormat:@"No recent %@ articles!", self.keyForFeed];

    UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:alertMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [av show];
}


#pragma mark - UIAlertView methods

/*******************************************************************************
 * @method      alertView
 * @abstract    implemented because this VC is a UIAlertView delegate, pops us back to the prior VC when there are no articles in the news feed
 *******************************************************************************/
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"user pressed OK for alertView in NewsViewController");
    /*
     Often there are no Third Amendment articles, so here we show the user a funny Onion article on Third
     Amendment rights lobbyists. Within this VC's viewWillAppear method, we check to see if the
     didJustShowDefaultArticle BOOL property is YES. If it is, then once the user dismisses the modal 
     webviewcontroller, this VC sets the BOOL back to NO and pops back to the prior view.
     */
    if([self.keyForFeed isEqualToString: @"Third Amendment"]){
        
        self.didJustShowDefaultArticle = YES;
        
        NSString *thirdAmendmentDefaultTitle = @"Third Amendment Rights Group Celebrates Another Successful Year";
        NSString *thirdAmendmentDefaultPub = @"The Onion";
        NSString *thirdAmendmentDefaultDate = @"Fri, 5 Oct 2007";
        NSString *thirdAmendmentDefaultURL = @"http://www.theonion.com/articles/third-amendment-rights-group-celebrates-another-su,2296/?ref=auto";
        
        SVModalWebViewController *webViewController = [[SVModalWebViewController alloc] initWithAddress: thirdAmendmentDefaultURL];
        NSDictionary *articleDisplayInfoforCell = @{@"Article Title" : thirdAmendmentDefaultTitle, @"Article Publication" : thirdAmendmentDefaultPub, @"Article Date" : thirdAmendmentDefaultDate, @"Article URL String" : thirdAmendmentDefaultURL};
        
        webViewController.articleInfoForFavorites = articleDisplayInfoforCell;
        webViewController.loadFavoriteButton = YES;
        [self presentViewController:webViewController animated:YES completion:nil];
        
    }
    else{
        //TODO: find default articles for other obscure amendments
        //for now, just pop back if there are no articles for the other amendments
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)removeDefaultView
{
    self.tableView.backgroundView = nil;
    NSLog(@"Remove default view from browser WORKS");
}

@end
