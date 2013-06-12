//
//  AllAmendmentsText.h
//  Amendments
/*
    Singleton that contains all the information needed by the SingleAmendmentViewController. Loads data from AmendmentsText.plist.
*/
//  Created by Alex Silva on 3/1/13.
//  Copyright (c) 2013 Alex Silva. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AllAmendmentsText : NSObject

@property (strong, nonatomic) NSArray *amendmentsData;
+(AllAmendmentsText *) sharedInstance;

@end


