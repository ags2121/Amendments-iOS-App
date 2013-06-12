//
//  AllAmendmentsCellData.h
//  Amendments
/*
    Singleton that holds and points to all the data and assets needed for display on Amendment cells in the AllAmendmentsViewController TableView. Loads info from AmendmentsCellData.plist.
*/
//  Created by Alex Silva on 2/28/13.
//  Copyright (c) 2013 Alex Silva. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AllAmendmentsCellData : NSObject

@property (strong, nonatomic) NSArray *cellData;
+(AllAmendmentsCellData *) sharedInstance;

@end
