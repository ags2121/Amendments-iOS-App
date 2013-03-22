//
//  AllAmendmentsCellData.m
//  Amendments
//
//  Created by Alex Silva on 2/28/13.
//  Copyright (c) 2013 Alex Silva. All rights reserved.
//

#import "AllAmendmentsCellData.h"

@implementation AllAmendmentsCellData

-(NSArray*)cellData
{
    if (!_cellData){
        NSString *path = [[NSBundle mainBundle] pathForResource:@"AmendmentsCellData" ofType:@"plist"];
        _cellData = [[NSArray alloc] initWithContentsOfFile:path];
    }
    
    return _cellData;
}

@end
