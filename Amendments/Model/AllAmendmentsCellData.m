//
//  AllAmendmentsCellData.m
//  Amendments
//
//  Created by Alex Silva on 2/28/13.
//  Copyright (c) 2013 Alex Silva. All rights reserved.
//

#import "AllAmendmentsCellData.h"

@implementation AllAmendmentsCellData

+ (AllAmendmentsCellData *) sharedInstance {
    static dispatch_once_t _p;
    static AllAmendmentsCellData *_singleton = nil;
    
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
        NSString *path = [[NSBundle mainBundle] pathForResource:@"AmendmentsCellData" ofType:@"plist"];
        NSLog(@"In the AllAmendmentsCellData class, loading AmendmentsCellData from the following path: %@", path);
        _cellData = [[NSArray alloc] initWithContentsOfFile:path];
    }
    
    return self;
}

@end
