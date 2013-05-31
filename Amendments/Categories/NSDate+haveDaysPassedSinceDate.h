//
//  NSDate+haveDaysPassedSinceDate.h
//  Amendments
//
//  Created by Alex Silva on 5/29/13.
//  Copyright (c) 2013 Alex Silva. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (haveDaysPassedSinceDate)

+(BOOL)have:(NSUInteger)number daysPassedSince:(NSDate*)startDate;

@end
