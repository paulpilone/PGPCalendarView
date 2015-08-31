//
//  NSDate+PGPCalendarViewAdditions.h
//  Pods
//
//  Created by Paul Pilone on 8/30/15.
//
//

#import <Foundation/Foundation.h>

@interface NSDate (PGPCalendarViewAdditions)

//
- (NSInteger)pgp_numberOfDaysBetweenDate:(NSDate *)otherDate;

@end
