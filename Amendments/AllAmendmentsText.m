//
//  AllAmendmentsText.m
//  Amendments
//
//  Created by Alex Silva on 3/1/13.
//  Copyright (c) 2013 Alex Silva. All rights reserved.
//

#import "AllAmendmentsText.h"

@implementation AllAmendmentsText

+ (AllAmendmentsText *) sharedInstance {
    static dispatch_once_t _p;
    static AllAmendmentsText *_singleton = nil;
    
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
        NSString *path = [[NSBundle mainBundle] pathForResource:@"AmendmentsText" ofType:@"plist"];
        _amendmentsData = [[NSArray alloc] initWithContentsOfFile:path];
    }
    
    return self;
}

@end
