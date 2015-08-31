//
//  NSDate+PGPCalendarViewAdditions.m
//  Pods
//
//  Created by Paul Pilone on 8/30/15.
//
//

#import "NSDate+PGPCalendarViewAdditions.h"

@implementation NSDate (PGPCalendarViewAdditions)

/* */
- (NSInteger)pgp_numberOfDaysBetweenDate:(NSDate *)otherDate {
    NSDate *selfDatep = nil;
    NSDate *otherDatep = nil;
    
    NSDate *selfDate = self;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&selfDatep
                 interval:NULL forDate:selfDate];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&otherDatep
                 interval:NULL forDate:otherDate];
    
    NSDateComponents *differenceComps = [calendar components:NSCalendarUnitDay
                                               fromDate:otherDatep toDate:selfDatep options:0];
    return ABS([differenceComps day]);
}

@end
