//
//  NewsFeeds.h
//  Amendments
/*
    A singleton class that makes calls to google news to fetch amendment news on behalf of the AmendmentNewsViewController. Implements a caching strategy using NSCache. Uses Google's GTMHTTPFetcher for networking. Responds to the calling class with either DidLoadDataFromSingleton, NoDataInFeed, or CouldNotConnectToFeed. Filters out certain publications. Sorts chronologically. Uses Yahoo puts to get the Google news XML into JSON.
*/
//  Created by Alex Silva on 3/2/13.
//  Copyright (c) 2013 Alex Silva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTMHTTPFetcher.h"
#import "AmendmentsNewsViewController.h"

@interface NewsFeeds : NSObject

@property (strong, nonatomic) NSCache *newsFeedCache;
@property (strong, nonatomic) NSMutableArray* aFeed;
@property (strong, nonatomic) NSString* currentKey;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) UIView* activityView;

+(NewsFeeds *) sharedInstance;

-(void)loadNewsFeed: (NSString*)finalURL forAmendment:(NSString*)key isRefreshing:(BOOL)refreshing;
- (void)newsFeedFetcher:(GTMHTTPFetcher *)fetcher finishedWithData:(NSData *)retrievedData error:(NSError *)error;

@end
