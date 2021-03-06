//
//  NewsFeeds.m
//  Amendments
//
//  Created by Alex Silva on 3/2/13.
//  Copyright (c) 2013 Alex Silva. All rights reserved.
//
#import "NewsFeeds.h"
#import "AmendmentsAppDelegate.h"
#import "XMLReader.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"

/**************STATIC PROPERTIES**************/

/************************************************************
 * @property:       cacheUpdateInterval
 * @abstract:    used to set the amount of time, in days, that must pass before the newsFeedsCache will refresh one of its feeds
 * @see             hasCacheUpdateIntervalElapsed and hasCacheUpdateIntervalElapsed:
 ***********************************************************/
static int cacheUpdateInterval = 1;

/************************************************************
 * @property:       kCachedDate
 * @abstract:    const string identifier for accessing the date when a particular feed was cached from the newsFeedCache
 ***********************************************************/
static NSString * const kCachedDate = @"cachedDate";

/************END STATIC PROPERTIES************/

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

-(void)loadNewsFeed:(NSString*)finalURL forAmendment:(NSString*)key isRefreshing:(BOOL)refreshing;
{
    //set NewsFeeds instance variable for the currentKey to key (the name of the amendment we're fetching news for
    self.currentKey = key;
    
    //if cache needs to be updated OR if user forces refresh
    if ([self cacheNeedsToBeUpdated] || refreshing) {
        
        NSLog(@"Cache needs to be updated");
        
        //start Activity Indicator, unless refreshing (since the newsVC's refresh control has its own UI spinner)
        if (!refreshing)
            [NSThread detachNewThreadSelector:@selector(showActivityViewer) toTarget:self withObject:nil];
        
        NSLog(@"currentKey: %@", self.currentKey);
        
        NSLog(@"URL query: %@", finalURL);
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:finalURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString *responseString=[[NSString alloc] initWithData:(NSData*)responseObject encoding:NSUTF8StringEncoding];
            NSError *error = nil;
            NSDictionary *xmlDictionary=[XMLReader dictionaryForXMLString:responseString error:&error];
            NSMutableArray *theFeed = [NSMutableArray arrayWithArray:xmlDictionary[@"rss"][@"channel"][@"item"]];
            NSLog(@"AS ARRAY %@", theFeed);
            //If there are no articles in the feed, send a notification to NewsFeed VC
            if (theFeed.count==0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NoDataInFeed"
                                                                    object:nil];
                //stop Activity indicator
                [self hideActivityViewer];
            }
            else {
                [self filterSortAndStoreResults:theFeed];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"Error downloading feed: %@", [error description]);
            //TODO: no connection, connection time-out handling
            //send message to present AlertView that connection could not be established.
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CouldNotConnectToFeed"
                                                            object:nil];
            //stop Activity indicator
            [self hideActivityViewer];
        }];

    }
    //else, send useCachedData notification
    else{
        NSLog(@"Cache DIDNT need to be updated");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DidLoadDataFromSingleton" object:nil];
    }
}

-(void)filterSortAndStoreResults:(NSMutableArray*)rawFeed
{
    //Articles to delete it from the feed
    NSMutableArray *articlesToDiscard = [NSMutableArray array];
    for(NSDictionary *dict in rawFeed){
        
        NSLog(@"Type of element: %@", [dict class]);
        
        NSLog(@"Type of inner element: %@", [dict[@"title"][@"text"] class]);
        
        //Don't include articles you need to register for, or letters to the editor
        if( [dict[@"title"][@"text"] rangeOfString:@"(registration)"].location != NSNotFound
           || [dict[@"title"][@"text"] rangeOfString:@"Letter: "].location != NSNotFound
           
           //Begin blacklist (sites that are too stupid and/or provincial to be included, or foreign sites)
           || [dict[@"link"][@"text"] rangeOfString:@"http://thedailynewsonline.com/"].location != NSNotFound
           || [dict[@"link"][@"text"] rangeOfString:@"http://www.journalgazette.net/"].location != NSNotFound
           || [dict[@"link"][@"text"] rangeOfString:@"http://www.fosters.com/"].location != NSNotFound
           || [dict[@"link"][@"text"] rangeOfString:@"limaohio.com/"].location != NSNotFound
           || [dict[@"link"][@"text"] rangeOfString:@"http://www.globalpost.com/"].location != NSNotFound
           || [dict[@"link"][@"text"] rangeOfString:@".com.pk"].location != NSNotFound
           || [dict[@"link"][@"text"] rangeOfString:@".hu/"].location != NSNotFound
           || [dict[@"link"][@"text"] rangeOfString:@"casperjournal.com/"].location != NSNotFound
           || [dict[@"link"][@"text"] rangeOfString:@"eastcountymagazine.org"].location != NSNotFound
           || [dict[@"link"][@"text"] rangeOfString:@"colombogazette.com/"].location != NSNotFound
           || [dict[@"link"][@"text"] rangeOfString:@"http://www.thehindu.com/"].location != NSNotFound
           || [dict[@"link"][@"text"] rangeOfString:@"lankaweb"].location != NSNotFound
           || [dict[@"link"][@"text"] rangeOfString:@"asiantribune"].location != NSNotFound
           || [dict[@"link"][@"text"] rangeOfString:@"asiantribune"].location != NSNotFound
           || [dict[@"link"][@"text"] rangeOfString:@".lk/"].location != NSNotFound
           || [dict[@"link"][@"text"] rangeOfString:@"brecorder.com"].location != NSNotFound
           || [dict[@"link"][@"text"] rangeOfString:@"newindianexpress.com"].location != NSNotFound
           || [dict[@"link"][@"text"] rangeOfString:@"tenthamendmentcenter.com"].location != NSNotFound
           || [dict[@"title"][@"text"] rangeOfString:@"Sri Lanka"].location != NSNotFound
           
           )
        {
            [articlesToDiscard addObject:dict];
        }
        //if the amendment we're creating a news feed for is NOT the second amendment, don't include articles with "second amendment", "2nd amendment", "gun control", "gun-control", "bear arms" (case-insensitive) in the title
        if( ![self.currentKey isEqualToString:@"Second Amendment"] &&
           
           (
            [dict[@"title"][@"text"] rangeOfString:@"Second Amendment" options:NSCaseInsensitiveSearch].location != NSNotFound
            || [dict[@"title"][@"text"] rangeOfString:@"2nd Amendment" options:NSCaseInsensitiveSearch].location != NSNotFound
            || [dict[@"title"][@"text"] rangeOfString:@"gun control" options:NSCaseInsensitiveSearch].location != NSNotFound
            || [dict[@"title"][@"text"] rangeOfString:@"gun-control" options:NSCaseInsensitiveSearch].location != NSNotFound
            || [dict[@"title"][@"text"] rangeOfString:@"bear arms" options:NSCaseInsensitiveSearch].location != NSNotFound)
           )
        {
            [articlesToDiscard addObject:dict];
        }
    }
    
    //discard the articles
    [rawFeed removeObjectsInArray:articlesToDiscard];
    
    //sort feed by date
    [rawFeed sortUsingComparator:^(NSDictionary* dict1, NSDictionary* dict2) {
        
        NSDate* date1 = [self.dateFormatter dateFromString: dict1[@"pubDate"][@"text"] ];
        NSDate* date2 = [self.dateFormatter dateFromString: dict2[@"pubDate"][@"text"] ];
        return [date2 compare:date1];
        
    }];
    
    NSLog(@"Sorted news feed: %@", rawFeed);
    
    NSMutableDictionary *mutableResults = [@{} mutableCopy];
    //store results
    [mutableResults setObject:rawFeed forKey:@"results"];
    //and date of fetch
    [mutableResults setObject:[NSDate date] forKey:kCachedDate];
    
    //add feed to global mutableArray of feeds maintained by this class, keyed on the amendment title
    [self.newsFeedCache setObject:mutableResults forKey:self.currentKey];
    
    //send message to reload current table view
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DidLoadDataFromSingleton"
                                                        object:nil];
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

/***********************************************************
 * @method:      cacheNeedsToBeUpdated
 * @abstract: checks whether cache needs to updated. YES if newsFeedCache doesn't have an entry for the current amendment being checked. YES if the cacheUpdateInterval has elapsed and needs to be refreshed. NO otherwise.
 **********************************************************/
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

/***********************************************************
 * @method:      hasCacheUpdateIntervalElapsed:
 * @abstract: checks whether cache update interval has elapsed, comparing the date the feed cache was set against the current date, and whether the difference is greater than or equal to the cacheUpdateInterval property
 **********************************************************/
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

@end
