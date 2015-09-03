//
//  PGPCalendarView.h
//  Pods
//
//  Created by Paul Pilone on 8/30/15.
//
//

#import <UIKit/UIKit.h>

@protocol PGPCalendarViewDelegate, PGPCalendarViewDataSource;

@interface PGPCalendarView : UIView

@property (nonatomic, weak) id<PGPCalendarViewDelegate> delegate;

@property (nonatomic, weak) id<PGPCalendarViewDataSource> dataSource;

@property (nonatomic, strong) NSDate *selectedDate;

/*
 * Appearance
 */

@property (nonatomic, strong) UIColor *todayColor UI_APPEARANCE_SELECTOR;

- (void)setSelectedDate:(NSDate *)selectedDate animated:(BOOL)animated;

@end

@protocol PGPCalendarViewDelegate <NSObject>

@required

- (void)calendarView:(PGPCalendarView *)calendarView didSelectDate:(NSDate *)date;

@end

@protocol PGPCalendarViewDataSource <NSObject>

@required

- (NSArray *)calendarView:(PGPCalendarView *)calendarView markersForDate:(NSDate *)date;

@end
