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
#import "Constants.h"

/********************************************/
//static int values for controlling subview layout values
static const int iPhone4landscapeWidth = 480;
static const int iPhone4landscapeHeight = 410;
static const int iPhone4PortraitWidth = 320;
static const int iPhone4PortraitHeight = 480;

static const int iPhone5landscapeWidth = 480;
static const int iPhone5landscapeHeight = 410;
static const int iPhone5PortraitWidth = 320;
static const int iPhone5PortraitHeight = 568;

static const int iPhone4TableViewTranslate = 100;
static const int iPhone4SummaryTranslate = 27;

static const int iPhone5TableViewTranslate = 100;
static const int iPhone5SummaryTranslate = 67;

//templateURL - the template URL whose keywords we replace with the particular queries used for the specific amendment
static NSString const *templateURL = @"http://pipes.yahoo.com/pipes/pipe.run?_id=46bf5af81d4dd0d2c4e267e2fca1af34&_render=json&feedcount=100&feedurl=https%3A%2F%2Fnews.google.com%2Fnews%2Ffeeds%3Fgl%3Dus%26hl%3Den%26as_occt%3Dtitle%26as_qdr%3Da%26as_nloc%3DAmerica%26authuser%3D0%26q%3Dallintitle%3A%2B%2522*%2Bamendment%2522%2BOR%2B%2522¥%2Bamendment%2522%2Blocation%3AAmerica%26um%3D1%26ie%3DUTF-8%26output%3Drss%26num%3D50";
/********************************************/

@interface SingleAmendmentViewController ()

@property (strong, nonatomic) NSString *finalURL;
@property (strong, nonatomic) NSString *queryKeyword1;
@property (strong, nonatomic) NSString *queryKeyword2;
@property (strong, nonatomic) NSMutableArray *favoriteAmendmentsInSection;

@end

@implementation SingleAmendmentViewController

@synthesize childViewControllerDidRotateToLandscape;
@synthesize childViewControllerDidRotateToPortrait;

- (void)viewDidLoad
{
    if (IS_IPHONE_5) {
        [self adjustLayoutForiPhone5];
    }
    [self setTextForView];
    [self constructAmendmentNewsQueryURL];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if (self.parentViewControllerWasInLandscape) {
        [self adjustSubviewsForLandscapeOrientation];
        self.parentViewControllerWasInLandscape = NO;
    }
    
    if (self.childViewControllerDidRotateToLandscape) {
        [self adjustSubviewsForLandscapeOrientation];
        self.childViewControllerDidRotateToLandscape = NO;
    }
    
    if (self.childViewControllerDidRotateToPortrait) {
        [self resetSubviewsForPortraitOrientation];
        self.childViewControllerDidRotateToPortrait = NO;
    }
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


#pragma mark - viewDidLoad methods

-(void)adjustLayoutForiPhone5
{
    //move tableView down
    self.optionsTableView.center = CGPointMake(self.optionsTableView.center.x, self.optionsTableView.center.y-20);
    //move summary label down
    self.summary.center = CGPointMake(self.summary.center.x, self.optionsTableView.frame.origin.y/2.75);
    //increase font size by 1 point
    [self.summary setFont:[UIFont systemFontOfSize:self.summary.font.pointSize+1.0]];
    //add one more line space to the label's height
    self.summary.frame = CGRectMake(self.summary.frame.origin.x, self.summary.frame.origin.y, self.summary.frame.size.width, self.summary.frame.size.height+self.summary.font.pointSize);
}

-(void)setTextForView
{
    //set title for view controller
    self.title = self.shortTitle;
    
    //set text for summary UILabel
    self.summary.text = [self.amendmentData objectForKey:@"Summary"];
}

-(void)constructAmendmentNewsQueryURL
{
    //set values for the query keywords
    self.queryKeyword1 = [[self.amendmentData objectForKey:@"queryKeywords"] objectAtIndex:0];
    self.queryKeyword2 = [[self.amendmentData objectForKey:@"queryKeywords"] objectAtIndex:1];
    
    //construct specified URL using keywords
    NSString* urlNew = [templateURL stringByReplacingOccurrencesOfString:@"*" withString:self.queryKeyword1];
    self.finalURL = [urlNew stringByReplacingOccurrencesOfString:@"¥" withString:self.queryKeyword2];
    //NSLog(@"URL for query: %@", self.finalURL);
}

#pragma mark - viewWillAppear methods
                                                                   
-(void)adjustSubviewsForLandscapeOrientation
{
    int landscapeWidth = iPhone4landscapeWidth; int lh = iPhone4landscapeHeight;
    int tvt = iPhone4TableViewTranslate; int st = iPhone4SummaryTranslate;
    if (IS_IPHONE_5) {
        landscapeWidth = iPhone5landscapeWidth; lh = iPhone5landscapeHeight;
        tvt = iPhone5TableViewTranslate; st = iPhone5SummaryTranslate;
    }
    
    CGRect frame = CGRectMake(0, 0, landscapeWidth, lh);
    self.optionsTableView.center = CGPointMake(self.optionsTableView.center.x, self.optionsTableView.center.y+tvt);
    self.summary.center = CGPointMake(self.summary.center.x, self.summary.center.y-st);
    
    self.view.frame = frame;
    self.scrollView.contentSize = CGSizeMake(frame.size.width, frame.size.height);
}

-(void)resetSubviewsForPortraitOrientation
{
    int portraitWidth = iPhone4PortraitWidth; int ph = iPhone4PortraitHeight;
    int tvt = iPhone4TableViewTranslate; int st = iPhone4SummaryTranslate;
    if (IS_IPHONE_5) {
        portraitWidth = iPhone5PortraitWidth; ph = iPhone5PortraitHeight;
        tvt = iPhone5TableViewTranslate; st = iPhone5SummaryTranslate;
    }
    
    CGRect frame = CGRectMake(0, 0, portraitWidth, ph);
    self.optionsTableView.center = CGPointMake(self.optionsTableView.center.x, self.optionsTableView.center.y-tvt);
    self.summary.center = CGPointMake(self.summary.center.x, self.summary.center.y+st);
    
    self.view.frame = frame;
    self.scrollView.contentSize = CGSizeMake(frame.size.width, frame.size.height);
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
        esvc.delegate = self;
        esvc.title = self.shortTitle;

    }
    
    if([[segue identifier] isEqualToString:@"originalTextSegue"]){
        
        OriginalTextViewController* otvc = [segue destinationViewController];
        NSString *path = [[NSBundle mainBundle] pathForResource: [self.amendmentData objectForKey:@"originalTextHTMLpath"] ofType:@"html"];
        NSString *htmlString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        //NSLog(@"htmlString: %@", htmlString);
        otvc.htmlString = htmlString;
        otvc.delegate = self;
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


#pragma mark - Interface Rotation handling methods

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (IS_IPHONE_5)
        [self translateSubviews:iPhone5landscapeWidth landscapeHeight:iPhone5landscapeHeight portraitWidth:iPhone5PortraitWidth portraitHeight:iPhone5PortraitHeight tableViewTranslate:iPhone5TableViewTranslate summaryTranslate:iPhone5SummaryTranslate toOrientation:toInterfaceOrientation];
    else
        [self translateSubviews:iPhone4landscapeWidth landscapeHeight:iPhone4landscapeHeight portraitWidth:iPhone4PortraitWidth portraitHeight:iPhone4PortraitHeight tableViewTranslate:iPhone4TableViewTranslate summaryTranslate:iPhone4SummaryTranslate toOrientation:toInterfaceOrientation];
}

-(void)translateSubviews:(int)landscapeWidth landscapeHeight:(int)lh portraitWidth:(int)pw portraitHeight:(int)ph tableViewTranslate:(int)tvt summaryTranslate:(int)st toOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    CGRect frame;
    UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if ((toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)) {
        
        frame = CGRectMake(0, 0, landscapeWidth, lh);
        if (currentOrientation != UIInterfaceOrientationLandscapeLeft && currentOrientation != UIInterfaceOrientationLandscapeRight) {
            self.optionsTableView.center = CGPointMake(self.optionsTableView.center.x, self.optionsTableView.center.y+tvt);
            self.summary.center = CGPointMake(self.summary.center.x, self.summary.center.y-st);
        }
    }
    else {
        frame = CGRectMake(0, 0, pw, ph);
        self.optionsTableView.center = CGPointMake(self.optionsTableView.center.x, self.optionsTableView.center.y-tvt);
        self.summary.center = CGPointMake(self.summary.center.x, self.summary.center.y+st);
    }
    
    self.view.frame = frame;
    self.scrollView.contentSize = CGSizeMake(frame.size.width, frame.size.height);
}


@end
