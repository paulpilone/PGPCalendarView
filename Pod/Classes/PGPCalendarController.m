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

@property (nonatomic, readwrite) NSDate *endDate;

@property (nonatomic, readwrite) NSDate *startDate;

@property (nonatomic) NSInteger numberOfAvailableDays;

@end

@implementation PGPCalendarController

/* */
- (instancetype)init {
    self = [super init];
    if (self) {
        _numberOfAvailableDays = -1;
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        
        NSDateComponents *startComps = [[NSDateComponents alloc] init];
        [startComps setYear:2010];
        [startComps setMonth:1];
        [startComps setDay:1];
        
        _startDate = [calendar dateFromComponents:startComps];
        
        NSDateComponents *endComps = [[NSDateComponents alloc] init];
        [endComps setYear:2049];
        [endComps setMonth:1];
        [endComps setDay:1];
        
        _endDate = [calendar dateFromComponents:endComps];
        NSLog(@"Initialized PGPCalendarController with start date: %@, end date: %@", _startDate, _endDate);
    }
    
    return self;
}

/* */
- (NSDate *)dateAtIndexPath:(NSIndexPath *)indexPath {
    // First attempt at solving this: Use NSDateComponents to determine
    // offset (indexPath.row) from start date in days. From those components,
    // create a new date. This might be really slow -- probably is.
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:[indexPath indexAtPosition:1]];
    
    return [calendar dateByAddingComponents:comps toDate:self.startDate options:0];
}

/* */
- (NSInteger)numberOfDates {
    return self.numberOfAvailableDays;
}

#pragma mark -
#pragma mark Private

/* 
 This value is lazy loaded because it's somewhat of an expensive calculation. Since
 the start and end dates are immutable, we only need calculate this value once.
 */
- (NSInteger)numberOfAvailableDays {
    if (_numberOfAvailableDays == -1) {
        _numberOfAvailableDays = [self.startDate pgp_numberOfDaysBetweenDate:self.endDate];
    }
    
    return _numberOfAvailableDays;
}

@end
