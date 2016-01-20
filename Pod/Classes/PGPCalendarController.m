//
//  PGPCalendarController.m
//  Pods
//
//  Created by Paul Pilone on 8/31/15.
//
//

#import "PGPCalendarController.h"

#import "NSDate+PGPCalendarViewAdditions.h"

@interface PGPCalendarController ()

@property (nonatomic, readwrite) NSCalendar *calendar;

@property (nonatomic, readwrite) NSDateFormatter *dateFormatter;

@property (nonatomic, readwrite) NSDate *endDate;

@property (nonatomic, readwrite) NSDate *startDate;

@property (nonatomic, readwrite) NSArray *weekdaySymbols;

@property (nonatomic) NSInteger numberOfAvailableDays;

@property (nonatomic) NSInteger startDateWeekdayOffset;

@end

@implementation PGPCalendarController

/* */
- (instancetype)init {
    self = [super init];
    if (self) {
        _calendar = [NSCalendar currentCalendar];
        _dateFormatter = [[NSDateFormatter alloc] init];
        _numberOfAvailableDays = -1;
        _startDateWeekdayOffset = -1;
        
        NSDateComponents *startComps = [[NSDateComponents alloc] init];
        [startComps setYear:2014];
        [startComps setMonth:1];
        [startComps setDay:1];
        
        _startDate = [_calendar dateFromComponents:startComps];
        
        NSDateComponents *endComps = [[NSDateComponents alloc] init];
        [endComps setYear:2049];
        [endComps setMonth:1];
        [endComps setDay:1];
        
        _endDate = [_calendar dateFromComponents:endComps];
        
        // Determine the weekday our start date represents in order to determine the offset we need for our data source.
        NSLog(@"Initialized PGPCalendarController with start date: %@, end date: %@", _startDate, _endDate);
    }
    
    return self;
}

/* */
- (NSDate *)dateAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath indexAtPosition:1] < self.startDateWeekdayOffset) {
        return nil;
    }
    
    // First attempt at solving this: Use NSDateComponents to determine
    // offset (indexPath.row) from start date in days. From those components,
    // create a new date. This might be really slow -- probably is.
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:[indexPath indexAtPosition:1] - self.startDateWeekdayOffset];
    
    return [self.calendar dateByAddingComponents:comps toDate:self.startDate options:0];
}

/* */
- (NSIndexPath *)indexPathForDate:(NSDate *)date {
    NSInteger startDifference = [self.startDate pgp_numberOfDaysBetweenDate:date];
    NSUInteger indexes[] = { 0, startDifference + self.startDateWeekdayOffset };
    return [[NSIndexPath alloc] initWithIndexes:indexes length:2];
}

/* */
- (BOOL)isToday:(NSDate *)date {
    return [self.calendar isDateInToday:date];
}

/* */
- (BOOL)isValidDate:(NSDate *)date {
    BOOL valid = YES;
    NSComparisonResult startResult = [self.startDate compare:date];
    valid = valid && (startResult == NSOrderedSame || startResult == NSOrderedAscending);
    
    NSComparisonResult endResult = [self.endDate compare:date];
    valid = valid && (endResult = NSOrderedSame || endResult == NSOrderedDescending);

    return valid;
}

/* */
- (NSInteger)numberOfDates {
    return self.numberOfAvailableDays;
}

/* */
- (NSInteger)startDateWeekdayOffset {
    if (_startDateWeekdayOffset == -1) {
        NSInteger calendarWeekday = [[self.calendar components:NSCalendarUnitWeekday fromDate:self.startDate] weekday];
        
        // We'll subtract 1 from our offset so that 'Sunday' appears as 0. This makes
        // calculations for our purposes easier.
        _startDateWeekdayOffset = calendarWeekday - self.calendar.firstWeekday;
    }
    
    return _startDateWeekdayOffset ;
}

/* FIXME: Alternate implementation: assume first weekday is Sunday. Offset based on actual first weekday and just access the formatter's array. */
- (NSArray *)shortWeekdaySymbols {
    NSMutableArray *mutableWeekdaySymbols = [NSMutableArray array];

    NSUInteger zeroIndexFirstWeekday = self.calendar.firstWeekday - 1;
    NSArray *defaultWeekdaySymbols = self.dateFormatter.shortWeekdaySymbols;
    
    [mutableWeekdaySymbols addObjectsFromArray:[defaultWeekdaySymbols subarrayWithRange:NSMakeRange(zeroIndexFirstWeekday, [defaultWeekdaySymbols count] - zeroIndexFirstWeekday)]];
    [mutableWeekdaySymbols addObjectsFromArray:[defaultWeekdaySymbols subarrayWithRange:NSMakeRange(0, zeroIndexFirstWeekday)]];
    
    return mutableWeekdaySymbols;
}

#pragma mark -
#pragma mark Private

/* 
 This value is lazy loaded because it's somewhat of an expensive calculation. Since
 the start and end dates are immutable, we only need calculate this value once.
 */
- (NSInteger)numberOfAvailableDays {
    if (_numberOfAvailableDays == -1) {
        _numberOfAvailableDays = [self.startDate pgp_numberOfDaysBetweenDate:self.endDate] + self.startDateWeekdayOffset;
    }
    
    return _numberOfAvailableDays;
}

@end
