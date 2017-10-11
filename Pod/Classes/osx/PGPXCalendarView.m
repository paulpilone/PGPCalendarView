//
//  PGPXCalendarView.m
//  PGPCalendarView
//
//  Created by Paul Pilone on 2/25/16.
//  Copyright © 2016 Paul Pilone. All rights reserved.
//

#import "PGPXCalendarView.h"

#import "PGPCalendarController.h"
#import "PGPXCalendarViewItem.h"
#import "PGPXScrollView.h"
#import "PGPXCalendarHeaderView.h"
#import "PGPXCalendarMonthLayout.h"
#import "PGPXCalendarDayItem.h"

@interface PGPXCalendarView () < PGPXCalendarMonthLayoutDelegate >

@property (nonatomic, strong) NSDateFormatter *monthFormatter;

@property (nonatomic, strong) IBOutlet NSButton *moveBackwardButton;

@property (nonatomic, strong) IBOutlet NSButton *moveForwardButton;

@property (nonatomic, strong) IBOutlet NSView *navigationView;

@property (nonatomic, strong) IBOutlet NSTextField *monthField;

@property (nonatomic, strong) IBOutlet PGPXCalendarHeaderView *headerView;

@property (nonatomic, strong) PGPCalendarController *calendarController;

@property (nonatomic, strong) PGPXCalendarMonthLayout *monthLayout;

@property (nonatomic, strong) NSDate *firstVisibleDate;

@property (nonatomic, strong) NSDate *lastVisibleDate;

@end

@interface NSImage (PGPXCalendarViewAdditions)

- (NSImage *)pgpx_imageTintedWithColor:(NSColor *)tint;

@end

@implementation PGPXCalendarView

/* */
- (instancetype)init {
    return [self initWithFrame:NSZeroRect];
}

/* */
- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self baseInit];
    }
    
    return self;
}

/* */
- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self) {
        [self baseInit];
    }
    
    return self;
}

/* */
- (void)awakeFromNib {
    [super awakeFromNib];
}

/* */
- (NSCalendar *)calendar {
    return self.calendarController.calendar;
}

/* */
- (CGSize)intrinsicContentSize {
  return CGSizeMake(280.f, 290.f);
}

/* */
- (void)reloadItems {
  // Reload the month layout.
  for (NSInteger i = 0; i < 42; i++) {
    NSDate *date = [self.calendarController.calendar dateByAddingUnit:NSCalendarUnitDay value:i toDate:self.firstVisibleDate options:0];
    
    PGPXCalendarDayItem *item = self.monthLayout.items[i];
    if (date) {
      item.date = date;
      item.selected = [date isEqual:self.selectedDate];
      item.today = [self.calendarController isToday:date];
      
      BOOL isSelectable = [self.calendarController.calendar isDate:date
                                                        equalToDate:self.selectedDate
                                                  toUnitGranularity:NSCalendarUnitMonth];
      item.selectable = isSelectable;
      
      NSArray *markers = [self.dataSource calendarView:self markersForDate:date];
      [item setMarkers:markers];
    } else {
      item.date = nil;
      item.today = NO;
      [item setMarkers:@[]];
    }
  }
}

/* */
- (void)setSelectedDate:(NSDate *)selectedDate {
  if (![self.calendarController isValidDate:selectedDate]) {
      return;
  }
  
  NSDate *startOfSelectedDate = [self.calendarController.calendar startOfDayForDate:selectedDate];
  if (_selectedDate != startOfSelectedDate) {
    _selectedDate = startOfSelectedDate;
    
    // Get the weekday for the start of the selected date's month.
    NSDateComponents *selectedComps = [self.calendarController.calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:_selectedDate];
    selectedComps.day = 1;
    
    NSDate *firstDayOfSelectedMonth = [self.calendarController.calendar dateFromComponents:selectedComps];
    
    selectedComps.month += 1;
    selectedComps.day = 0;
    
    NSDate *lastDayOfSelectedMonth = [self.calendarController.calendar dateFromComponents:selectedComps];
    
    // Find the day of week for the first day of the month.
    NSInteger firstDayOfSelectedMonthWeekday = [self.calendarController.calendar components:NSCalendarUnitWeekday fromDate:firstDayOfSelectedMonth].weekday;
    
    NSInteger daysOfPreviousMonthToShow = -1;
    if (firstDayOfSelectedMonthWeekday < self.calendarController.calendar.firstWeekday) {
      daysOfPreviousMonthToShow = 7 - firstDayOfSelectedMonthWeekday;
    } else if (firstDayOfSelectedMonthWeekday > self.calendarController.calendar.firstWeekday) {
      daysOfPreviousMonthToShow = firstDayOfSelectedMonthWeekday - self.calendarController.calendar.firstWeekday;
    } else {
      daysOfPreviousMonthToShow = 0;
    }
    self.firstVisibleDate = [self.calendarController.calendar dateByAddingUnit:NSCalendarUnitDay value:-(daysOfPreviousMonthToShow) toDate:firstDayOfSelectedMonth options:0];
    
    NSRange numberOfDaysInSelectedMonth = [self.calendarController.calendar rangeOfUnit:NSCalendarUnitDay
                                                                                 inUnit:NSCalendarUnitMonth
                                                                                forDate:_selectedDate];
    NSInteger daysOfNextMonthToShow = 42 - (daysOfPreviousMonthToShow + numberOfDaysInSelectedMonth.length);
    
    self.lastVisibleDate = [self.calendarController.calendar dateByAddingUnit:NSCalendarUnitDay value:daysOfNextMonthToShow toDate:lastDayOfSelectedMonth options:0];

    [self reloadItems];
    
    [self updateMonthLabelForDate:self.selectedDate];
  }
}

#pragma mark -
#pragma mark Actions

/* */
- (IBAction)pageBackward:(id)sender {
  NSDateComponents *selectedMonthComps = [self.calendarController.calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.selectedDate];
  selectedMonthComps.day = 0;
  
  self.selectedDate = [self.calendarController.calendar dateFromComponents:selectedMonthComps];
  
  if ([self.delegate respondsToSelector:@selector(calendarView:didSelectDate:)]) {
      [self.delegate calendarView:self didSelectDate:self.selectedDate];
  }
}

/* */
- (IBAction)pageForward:(id)sender {
  NSDateComponents *selectedMonthComps = [self.calendarController.calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.selectedDate];
  selectedMonthComps.month += 1;
  selectedMonthComps.day = 1;
  
  self.selectedDate = [self.calendarController.calendar dateFromComponents:selectedMonthComps];

  if ([self.delegate respondsToSelector:@selector(calendarView:didSelectDate:)]) {
      [self.delegate calendarView:self didSelectDate:self.selectedDate];
  }
}

#pragma mark -
#pragma mark PGPXCalendarMonthLayoutDelegate

/* */
- (void)calendarMonthLayout:(PGPXCalendarMonthLayout *)layout didSelectDate:(NSDate *)date {
  [self.monthLayout deselectDate:self.selectedDate];
  self.selectedDate = date;
  
  if ([self.delegate respondsToSelector:@selector(calendarView:didSelectDate:)]) {
    [self.delegate calendarView:self didSelectDate:date];
  }
}

#pragma mark -
#pragma mark NSView

/* */
- (BOOL)isFlipped {
    return YES;
}

/* */
- (void)mouseDown:(NSEvent *)theEvent {
    NSPoint locationInSelf = [self convertPoint:theEvent.locationInWindow fromView:nil];
    if (NSPointInRect(locationInSelf, self.monthField.frame)) {
        NSDate *today = [NSDate date];
        self.selectedDate = today;
        
        if ([self.delegate respondsToSelector:@selector(calendarView:didSelectDate:)]) {
            [self.delegate calendarView:self didSelectDate:today];
        }
    }
}

#pragma mark -
#pragma mark Private

/* */
- (void)baseInit {
  _calendarController = [[PGPCalendarController alloc] init];

  NSString *dateFormatTemplate = [NSDateFormatter dateFormatFromTemplate:@"MMMM yyyy" options:0 locale:[NSLocale localeWithLocaleIdentifier:@"en"]];
  _monthFormatter = [[NSDateFormatter alloc] init];
  [_monthFormatter setDateFormat:dateFormatTemplate];
  
  _selectedDate = _calendarController.startDate;

  _calendarHeaderTextColor = [NSColor colorWithWhite:.4 alpha:1.f];
  _calendarTextColor = [NSColor colorWithWhite:.26 alpha:1.f];
  _navigationButtonColor = [NSColor colorWithRed:231.f/255.f green:76.f/255.f blue:60.f/255.f alpha:1.f];
  _navigationTextColor = [NSColor colorWithWhite:.4 alpha:1.f];
  
  _navigationView = [[NSView alloc] init];
  _navigationView.translatesAutoresizingMaskIntoConstraints = NO;
  [self addSubview:_navigationView];
    
    _monthField = [[NSTextField alloc] init];
    _monthField.bordered = NO;
    _monthField.drawsBackground = NO;
    _monthField.editable = NO;
    _monthField.font = [NSFont systemFontOfSize:15.f];
    _monthField.textColor = _navigationTextColor;
    _monthField.translatesAutoresizingMaskIntoConstraints = NO;
    [_navigationView addSubview:_monthField];
    
    _moveBackwardButton = [[NSButton alloc] init];
    _moveBackwardButton.bordered = NO;
    _moveBackwardButton.imagePosition = NSImageOnly;
    _moveBackwardButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_moveBackwardButton setAction:@selector(pageBackward:)];
    [_moveBackwardButton setButtonType:NSMomentaryChangeButton];
    [_moveBackwardButton setTarget:self];
    ((NSButtonCell *)_moveBackwardButton.cell).imageScaling = NSImageScaleProportionallyDown;
    
    _moveForwardButton = [[NSButton alloc] init];
    _moveForwardButton.bordered = NO;
    _moveForwardButton.imagePosition = NSImageOnly;
    _moveForwardButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_moveForwardButton setAction:@selector(pageForward:)];
    [_moveForwardButton setButtonType:NSMomentaryChangeButton];
    [_moveForwardButton setTarget:self];
    ((NSButtonCell *)_moveForwardButton.cell).imageScaling = NSImageScaleProportionallyDown;
    
    [_navigationView addSubview:_moveBackwardButton];
    [_navigationView addSubview:_moveForwardButton];
    
    _headerView = [[PGPXCalendarHeaderView alloc] initWithWeekdaySymbols:_calendarController.shortWeekdaySymbols];
    _headerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_headerView];
  
  _monthLayout = [[PGPXCalendarMonthLayout alloc] init];
  _monthLayout.delegate = self;
  [self addSubview:_monthLayout];
  
    NSDictionary *views = @{ @"monthField" : _monthField,
                             @"navigationView" : _navigationView,
                             @"moveBackwardButton" : _moveBackwardButton,
                             @"moveForwardButton" : _moveForwardButton,
                             @"headerView" : _headerView,
                             @"monthLayout" : _monthLayout
                           };
    
    [_navigationView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-9-[monthField]-[moveBackwardButton(18)]-12-[moveForwardButton(18)]-9-|" options:0 metrics:nil views:views]];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:_monthField attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:_navigationView attribute:NSLayoutAttributeTop multiplier:1.f constant:0.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_monthField attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationLessThanOrEqual toItem:_navigationView attribute:NSLayoutAttributeBottom multiplier:1.f constant:0.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_monthField attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_navigationView attribute:NSLayoutAttributeCenterY multiplier:1.f constant:0.f]];
    
    [_navigationView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[moveForwardButton]|" options:0 metrics:nil views:views]];
    [_navigationView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[moveBackwardButton]|" options:0 metrics:nil views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-10-[navigationView]-10-|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-10-[headerView]-10-|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-10-[monthLayout]-10-|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[navigationView(32)][headerView(17)][monthLayout]|" options:0 metrics:nil views:views]];
  
    NSString *calendarBundlePath = [[NSBundle mainBundle] pathForResource:@"PGPCalendarView" ofType:@"bundle"];
    NSBundle *calendarBundle = [NSBundle bundleWithPath:calendarBundlePath];

    NSString *arrowPath = [calendarBundle pathForImageResource:@"HWExpandArrow.tiff"];
    NSImage *arrowImage = [[NSImage alloc] initWithContentsOfFile:arrowPath];
    [_moveForwardButton setImage:[arrowImage pgpx_imageTintedWithColor:_navigationButtonColor]];
    
    arrowPath = [calendarBundle pathForImageResource:@"HWCollapseArrow.tiff"];
    arrowImage = [[NSImage alloc] initWithContentsOfFile:arrowPath];
    [_moveBackwardButton setImage:[arrowImage pgpx_imageTintedWithColor:_navigationButtonColor]];
}

/* */
- (void)updateMonthLabelForDate:(NSDate *)date {
  if (date) {
    self.monthField.stringValue = [self.monthFormatter stringFromDate:date];
  } else {
    self.monthField.stringValue = @"";
  }
}

@end

@implementation NSImage (PGPXCalendarViewAdditions)

/* */
- (NSImage *)pgpx_imageTintedWithColor:(NSColor *)tint {
    NSImage *image = [self copy];
    
    if (tint == nil) {
        return image;
    }
    
    [image lockFocus];
    
    [tint set];
    NSRect imageRect = {NSZeroPoint, [image size]};
    NSRectFillUsingOperation(imageRect, NSCompositeSourceAtop);
    
    [image unlockFocus];
    
    return image;
}

@end
