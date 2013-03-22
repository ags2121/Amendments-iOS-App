//
//  AllAmendmentsText.h
//  Amendments
//
//  Created by Alex Silva on 3/1/13.
//  Copyright (c) 2013 Alex Silva. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AllAmendmentsText : NSObject

@property (strong, nonatomic) NSArray *amendmentsData;
+(AllAmendmentsText *) sharedInstance;

@end


