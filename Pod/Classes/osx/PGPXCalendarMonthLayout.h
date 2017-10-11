//
//  PGPXCalendarDayContainerView.h
//  PGPCalendarView-iOS
//
//  Created by Paul Pilone on 9/27/17.
//

#import <Cocoa/Cocoa.h>

@class PGPXCalendarDayItem;

@protocol PGPXCalendarMonthLayoutDelegate;

@interface PGPXCalendarMonthLayout : NSView

/** */
@property (nonatomic, readonly) NSArray <PGPXCalendarDayItem *> *items;

/** */
@property (nonatomic, weak) id <PGPXCalendarMonthLayoutDelegate> delegate;

/** */
- (void)deselectDate:(NSDate *)date;

@end

@protocol PGPXCalendarMonthLayoutDelegate < NSObject >

@optional

- (void)calendarMonthLayout:(PGPXCalendarMonthLayout *)layout didSelectDate:(NSDate *)date;

@end
