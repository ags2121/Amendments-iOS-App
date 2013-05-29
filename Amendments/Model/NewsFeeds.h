//
//  NewsFeeds.h
//  Amendments
//
//  Created by Alex Silva on 3/2/13.
//  Copyright (c) 2013 Alex Silva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTMHTTPFetcher.h"
#import "AmendmentsNewsViewController.h"

@interface NewsFeeds : NSObject

@property (strong, nonatomic) NSMutableDictionary *individualNewsFeeds;
@property (strong, nonatomic) NSCache *newsFeedCache;



@property (strong, nonatomic) NSMutableArray* aFeed;
@property (strong, nonatomic) NSString* currentKey;
@property (strong, nonatomic) AmendmentsNewsViewController* currentViewController;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) UIView* activityView;

+(NewsFeeds *) sharedInstance;

-(void)loadNewsFeed: (NSString*)finalURL forAmendment:(NSString*)key isRefreshing:(BOOL)refreshing forViewController:(UIViewController*)tbvc;
- (void)newsFeedFetcher:(GTMHTTPFetcher *)fetcher finishedWithData:(NSData *)retrievedData error:(NSError *)error;

@end
