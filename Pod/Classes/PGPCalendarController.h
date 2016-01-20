//
//  PGPCalendarController.h
//  Pods
//
//  Created by Paul Pilone on 8/31/15.
//
//

#import <Foundation/Foundation.h>

@interface PGPCalendarController : NSObject

/** 
 The calendar used to provide dates and perform calculations. Defaults
 to the user's current calendar.
 */
@property (nonatomic, readonly) NSCalendar *calendar;

/**
 The date formatter used to provide date information and formatting.
 */
@property (nonatomic, readonly) NSDateFormatter *dateFormatter;

/**
 The latest date the calendar allows. Defaults to Jan 1 2049.
 */
@property (nonatomic, readonly) NSDate *endDate;

/**
 The earliest date the calendar allows. Defaults to Jan 1 2014.
 */
@property (nonatomic, readonly) NSDate *startDate;

/**
 The weekday symbols (strings) displayed in the calendar header. Accounts for
 first weekday offset.
 */
@property (nonatomic, readonly) NSArray *shortWeekdaySymbols;

/** Number of dates calculated between the start and end dates */
- (NSInteger)numberOfDates;

/** Returns the date at the specificed index path. */
- (NSDate *)dateAtIndexPath:(NSIndexPath *)indexPath;

/** Provides the index path for the given date. */
- (NSIndexPath *)indexPathForDate:(NSDate *)date;

/** Checks if the given date is today or contained in today. */
- (BOOL)isToday:(NSDate *)date;

/** Checks if the given date is contained in the start and end range. */
- (BOOL)isValidDate:(NSDate *)date;

@end
