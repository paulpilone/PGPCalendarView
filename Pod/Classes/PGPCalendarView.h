//
//  PGPCalendarView.h
//  Pods
//
//  Created by Paul Pilone on 8/30/15.
//
//

#import <UIKit/UIKit.h>

@protocol PGPCalendarViewDelegate;

@interface PGPCalendarView : UIView

@property (nonatomic, weak) id<PGPCalendarViewDelegate> delegate;

@property (nonatomic, strong) NSDate *selectedDate;

@property (nonatomic, readonly) NSDate *monthYearDate;

- (void)setSelectedDate:(NSDate *)selectedDate animated:(BOOL)animated;

@end

@protocol PGPCalendarViewDelegate <NSObject>

@required

- (void)calendarView:(PGPCalendarView *)calendarView didSelectDate:(NSDate *)date;

@end
