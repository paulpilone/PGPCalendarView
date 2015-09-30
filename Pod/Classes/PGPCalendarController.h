//
//  PGPCalendarController.h
//  Pods
//
//  Created by Paul Pilone on 8/31/15.
//
//

#import <Foundation/Foundation.h>

@interface PGPCalendarController : NSObject

@property (nonatomic, readonly) NSCalendar *calendar;

@property (nonatomic, readonly) NSDate *endDate;

@property (nonatomic, readonly) NSDate *startDate;

@property (nonatomic, readonly) NSArray *shortWeekdaySymbols;

/* */
- (NSInteger)numberOfDates;

/* */
- (NSDate *)dateAtIndexPath:(NSIndexPath *)indexPath;

/* */
- (NSIndexPath *)indexPathForDate:(NSDate *)date;

/* */
- (BOOL)isToday:(NSDate *)date;

/* */
- (BOOL)isValidDate:(NSDate *)date;

@end
