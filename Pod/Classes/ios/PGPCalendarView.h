//
//  PGPCalendarView.h
//  Pods
//
//  Created by Paul Pilone on 8/30/15.
//
//

#import <UIKit/UIKit.h>

@protocol PGPCalendarViewDelegate, PGPCalendarViewDataSource;

typedef NS_ENUM(NSInteger, PGPCalendarViewDisplayMode) {
    PGPCalendarViewDisplayModeOneWeek = 0,
    PGPCalendarViewDisplayModeTwoWeeks,
    PGPCalendarViewDisplayModeOneMonth
};

@interface PGPCalendarView : UIView

@property (nonatomic) BOOL userNavigationEnabled;

@property (nonatomic, weak) IBOutlet id<PGPCalendarViewDelegate> delegate;

@property (nonatomic, weak) IBOutlet id<PGPCalendarViewDataSource> dataSource;

@property (nonatomic) enum PGPCalendarViewDisplayMode displayMode;

@property (nonatomic, readonly) NSCalendar *calendar;

@property (nonatomic, strong) NSDate *selectedDate;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, readonly) UILabel *monthLabel;

/*
 * Appearance
 */

@property (nonatomic, strong) UIColor *borderColor UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIColor *dayTextColor UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIColor *todaySelectedTextColor UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIColor *todayTextColor UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIColor *todaySelectedBackgroundColor UI_APPEARANCE_SELECTOR;

/**
 
 */
- (void)reloadData;

/**
 
 */
- (void)reloadDate:(NSDate *)date;

/**
 
 */
- (void)setSelectedDate:(NSDate *)selectedDate animated:(BOOL)animated;

/**
 
 */
- (NSInteger)indexForDate:(NSDate *)date;

@end

@protocol PGPCalendarViewDelegate <NSObject>

@required

- (void)calendarView:(PGPCalendarView *)calendarView didSelectDate:(NSDate *)date;

@end

@protocol PGPCalendarViewDataSource <NSObject>

@required

- (NSArray *)calendarView:(PGPCalendarView *)calendarView markersForDate:(NSDate *)date;

@end
