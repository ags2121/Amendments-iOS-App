//
//  NewsFeeds.m
//  Amendments
//
//  Created by Alex Silva on 3/2/13.
//  Copyright (c) 2013 Alex Silva. All rights reserved.
//

#import "NewsFeeds.h"
#import "AmendmentsAppDelegate.h"

//Cache update interval, in days
static int cacheUpdateInterval = 1;
NSString * const kCachedDate = @"cachedDate";

@implementation NewsFeeds

+ (NewsFeeds *) sharedInstance {
    static dispatch_once_t _p;
    static NewsFeeds *_singleton = nil;
    
    dispatch_once(&_p, ^{
        _singleton = [[super allocWithZone:nil] init];
    });
    
    return _singleton;
}

+ (id) allocWithZone:(NSZone *)zone {
    return [self sharedInstance];
}

- (id)init
{
    self = [super init];
    
    if (self) {
        //individualNewsFeeds is a mutable array of dictionaries containing an individual amendment's newsfeed, keyed by title, i.e. "One"
        _newsFeedCache = [[NSCache alloc] init];
        
        //initialize date formatter format, to be used when we sort the feed by date
        _dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss zzz"];
    }
    
    return self;
}

-(void)loadNewsFeed: (NSString*)finalURL forAmendment:(NSString*)key isRefreshing:(BOOL)refreshing;
{
    //set NewsFeeds instance variable for the currentKey to key (the name of the amendment we're fetching news for
    self.currentKey = key;
    
    //if cache needs to be updated OR if user forces refresh
    if ([self cacheNeedsToBeUpdated] || refreshing) {
        
        NSLog(@"Cache needs to be updated");
        
        //start Activity Indicator
        [NSThread detachNewThreadSelector:@selector(showActivityViewer) toTarget:self withObject:nil];
        
        NSLog(@"currentKey: %@", self.currentKey);
        
        NSLog(@"URL query: %@", finalURL);
        
        NSURL *url = [NSURL URLWithString: finalURL];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        GTMHTTPFetcher* myFetcher = [GTMHTTPFetcher fetcherWithRequest:request];
        [myFetcher beginFetchWithDelegate:self
                        didFinishSelector:@selector(newsFeedFetcher:finishedWithData:error:)];
    }
    
    //else, send useCachedData notification
    else{
        NSLog(@"Cache DIDNT need to be updated");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DidLoadDataFromSingleton" object:nil];
    }
}

- (void)newsFeedFetcher:(GTMHTTPFetcher *)fetcher finishedWithData:(NSData *)retrievedData error:(NSError *)error
{
    if (error != nil) {
        // failed; either an NSURLConnection error occurred, or the server returned
        // a status value of at least 300
        //
        // the NSError domain string for server status errors is kGTMHTTPFetcherStatusDomain
        int status = [error code];
        
        NSLog(@"Connection error! Error code: %d", status);
        
        //TODO: no connection, connection time-out handling
        
        //send message to present AlertView that connection could not be established.
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CouldNotConnectToFeed"
                                                            object:nil];
        
    } else {
        
        NSDictionary* results = [NSJSONSerialization JSONObjectWithData:retrievedData options:kNilOptions error:&error];
        
        NSMutableArray *theFeed = [NSMutableArray arrayWithArray:[[results objectForKey:@"value"] objectForKey:@"items"] ];
        
        //Articles to delete it from the feed
        NSMutableArray *articlesToDiscard = [NSMutableArray array];
        for(NSDictionary* dict in theFeed){
            
            //Don't include articles you need to register for, or letters to the editor
            if( [[dict objectForKey:@"title"] rangeOfString:@"(registration)"].location != NSNotFound
               || [[dict objectForKey:@"title"] rangeOfString:@"Letter: "].location != NSNotFound
               
               //Begin blacklist (sites that are too stupid and/or provincial to be included, or foreign sites)
               || [[dict objectForKey:@"link"] rangeOfString:@"http://thedailynewsonline.com/"].location != NSNotFound
               || [[dict objectForKey:@"link"] rangeOfString:@"http://www.journalgazette.net/"].location != NSNotFound
               || [[dict objectForKey:@"link"] rangeOfString:@"http://www.fosters.com/"].location != NSNotFound
               || [[dict objectForKey:@"link"] rangeOfString:@"limaohio.com/"].location != NSNotFound
               || [[dict objectForKey:@"link"] rangeOfString:@"http://www.globalpost.com/"].location != NSNotFound
               || [[dict objectForKey:@"link"] rangeOfString:@".com.pk"].location != NSNotFound
               || [[dict objectForKey:@"link"] rangeOfString:@".hu/"].location != NSNotFound
               || [[dict objectForKey:@"link"] rangeOfString:@"casperjournal.com/"].location != NSNotFound
               || [[dict objectForKey:@"link"] rangeOfString:@"eastcountymagazine.org"].location != NSNotFound
               || [[dict objectForKey:@"link"] rangeOfString:@"colombogazette.com/"].location != NSNotFound
               || [[dict objectForKey:@"link"] rangeOfString:@"http://www.thehindu.com/"].location != NSNotFound
               || [[dict objectForKey:@"link"] rangeOfString:@"lankaweb"].location != NSNotFound
               || [[dict objectForKey:@"link"] rangeOfString:@"asiantribune"].location != NSNotFound
               || [[dict objectForKey:@"link"] rangeOfString:@"asiantribune"].location != NSNotFound
               || [[dict objectForKey:@"link"] rangeOfString:@".lk/"].location != NSNotFound
               || [[dict objectForKey:@"link"] rangeOfString:@"brecorder.com"].location != NSNotFound
               || [[dict objectForKey:@"link"] rangeOfString:@"newindianexpress.com"].location != NSNotFound
               || [[dict objectForKey:@"title"] rangeOfString:@"Sri Lanka"].location != NSNotFound

               )
            {
                [articlesToDiscard addObject:dict];
            }
            //if the amendment we're creating a news feed for is NOT the second amendment, don't include articles with "second amendment", "2nd amendment", "gun control", "gun-control", "bear arms" (case-insensitive) in the title
            if( ![self.currentKey isEqualToString:@"Second Amendment"] &&
               
               (
                [[dict objectForKey:@"title"] rangeOfString:@"Second Amendment" options:NSCaseInsensitiveSearch].location != NSNotFound
                || [[dict objectForKey:@"title"] rangeOfString:@"2nd Amendment" options:NSCaseInsensitiveSearch].location != NSNotFound
                || [[dict objectForKey:@"title"] rangeOfString:@"gun control" options:NSCaseInsensitiveSearch].location != NSNotFound
                || [[dict objectForKey:@"title"] rangeOfString:@"gun-control" options:NSCaseInsensitiveSearch].location != NSNotFound
                || [[dict objectForKey:@"title"] rangeOfString:@"bear arms" options:NSCaseInsensitiveSearch].location != NSNotFound)
               )
            {
                [articlesToDiscard addObject:dict];
            }
        }
        [theFeed removeObjectsInArray:articlesToDiscard];
         
        //sort feed by date
        [theFeed sortUsingComparator:^(NSDictionary* dict1, NSDictionary* dict2) {
            
            NSDate* date1 = [self.dateFormatter dateFromString: [dict1 objectForKey:@"pubDate"] ];
            NSDate* date2 = [self.dateFormatter dateFromString: [dict2 objectForKey:@"pubDate"] ];
            return [date2 compare:date1];
            
        }];
        
        //NSLog(@"Sorted newsFeed: %@", self.aFeed);
        
        //If there are no articles in the feed, send a notification to NewsFeed VC
        if (theFeed.count==0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NoDataInFeed"
                                                            object:nil];
        }
        else{
        
            NSMutableDictionary *mutableResults = [@{} mutableCopy];
            //store results
            [mutableResults setObject:theFeed forKey:@"results"];
            //and date of fetch
            [mutableResults setObject:[NSDate date] forKey:kCachedDate];
            
        
            //add feed to global mutableArray of feeds maintained by this class, keyed on the amendment title
            [self.newsFeedCache setObject:mutableResults forKey:self.currentKey];
                
        
            //send message to reload current table view
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DidLoadDataFromSingleton"
                                                            object:nil];
        }
    }
    
    //stop Activity indicator
    [self hideActivityViewer];
}


#pragma mark - Activity Viewer methods

-(void)showActivityViewer
{
    
    AmendmentsAppDelegate *delegate = (AmendmentsAppDelegate*)[[UIApplication sharedApplication] delegate];
    UIWindow *window = delegate.window;
    _activityView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, window.bounds.size.width, window.bounds.size.height)];
    self.activityView.backgroundColor = [UIColor blackColor];
    self.activityView.alpha = 0.5;
    
    UIActivityIndicatorView *activityWheel = [[UIActivityIndicatorView alloc] initWithFrame: CGRectMake(window.bounds.size.width / 2 - 12, window.bounds.size.height / 2 - 12, 24, 24)];
    activityWheel.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    activityWheel.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
                                      UIViewAutoresizingFlexibleRightMargin |
                                      UIViewAutoresizingFlexibleTopMargin |
                                      UIViewAutoresizingFlexibleBottomMargin);
    [self.activityView addSubview:activityWheel];
    [window addSubview: self.activityView];
    
    [[[self.activityView subviews] objectAtIndex:0] startAnimating];
}

-(void)hideActivityViewer
{
    [[[self.activityView subviews] objectAtIndex:0] stopAnimating];
    [self.activityView removeFromSuperview];
    self.activityView = nil;
}


#pragma mark - Utility methods

-(BOOL)hasCacheUpdateIntervalElapsed:(NSDate*)cachedDate
{
    NSLog(@"cachedDate: %@", cachedDate);
    
    NSUInteger unitFlags = NSDayCalendarUnit;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:unitFlags fromDate:cachedDate toDate:[NSDate date] options:0];
    if ( [components day]  >= cacheUpdateInterval){
        NSLog(@"Days between dates: %d", ([components day] + 1));
        return YES;
    }
    
    return NO;
}


-(BOOL)cacheNeedsToBeUpdated
{
    NSDate *dateOfCache = (NSDate*)[self.newsFeedCache objectForKey:self.currentKey][kCachedDate];
    
    if( ![self.newsFeedCache objectForKey:self.currentKey] )
        return YES;
    
    
    else if( [self hasCacheUpdateIntervalElapsed: dateOfCache] ){
        return YES;
    }
    
    return NO;
}


@end
