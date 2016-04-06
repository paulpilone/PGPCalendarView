//
//  PGPXCalendarView.h
//  PGPCalendarView
//
//  Created by Paul Pilone on 2/25/16.
//  Copyright © 2016 Paul Pilone. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol PGPXCalendarViewDataSource, PGPXCalendarViewDelegate;

@interface PGPXCalendarView : NSView

@property (nonatomic, weak) IBOutlet id<PGPXCalendarViewDelegate> delegate;

@property (nonatomic, weak) IBOutlet id<PGPXCalendarViewDataSource> dataSource;

@property (nonatomic, readonly) NSCalendar *calendar;

@property (nonatomic, strong) NSDate *selectedDate;

@property (nonatomic, strong) NSColor *backgroundColor;

@property (nonatomic, strong) NSColor *navigationTextColor;

@property (nonatomic, strong) NSColor *navigationButtonColor;

@property (nonatomic, strong) NSColor *calendarHeaderTextColor;

@property (nonatomic, strong) NSColor *calendarTextColor;

/** */
- (void)reloadData;

@end

@protocol PGPXCalendarViewDelegate <NSObject>

@required

- (void)calendarView:(PGPXCalendarView *)calendarView didSelectDate:(NSDate *)date;

@end

@protocol PGPXCalendarViewDataSource <NSObject>

@required

- (NSArray *)calendarView:(PGPXCalendarView *)calendarView markersForDate:(NSDate *)date;

@end
