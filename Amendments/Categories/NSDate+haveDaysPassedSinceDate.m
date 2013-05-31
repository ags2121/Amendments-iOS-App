//
//  NSDate+haveDaysPassedSinceDate.m
//  Amendments
//
//  Created by Alex Silva on 5/29/13.
//  Copyright (c) 2013 Alex Silva. All rights reserved.
//

#import "NSDate+haveDaysPassedSinceDate.h"

@implementation NSDate (haveDaysPassedSinceDate)

+(BOOL)have:(NSUInteger)number daysPassedSince:(NSDate*)startDate
{
    NSUInteger unitFlags = NSDayCalendarUnit;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:unitFlags fromDate:startDate toDate:[NSDate date] options:0];
    if ( [components day]  >= number){
        return YES;
    }
    
    return NO;
}

@end
