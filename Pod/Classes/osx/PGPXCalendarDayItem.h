//
//  PGPXCalendarDayView.h
//  PGPCalendarView-iOS
//
//  Created by Paul Pilone on 9/27/17.
//

#import <Cocoa/Cocoa.h>

@class PGPXMarkerView;
@class PGPXDateCalloutTextField;

@interface PGPXCalendarDayItem : NSView

@property (weak, nonatomic) id target;

@property (nonatomic) SEL action;

@property (nonatomic) BOOL selected;

@property (nonatomic) BOOL selectable;

@property (nonatomic) BOOL today;

@property (nonatomic, strong) NSColor *backgroundColor;

@property (nonatomic, strong) NSColor *selectedTextColor;

@property (nonatomic, strong) NSColor *textColor;

@property (nonatomic, strong) NSColor *todayTextColor;

@property (nonatomic, strong) NSColor *todaySelectedTextColor;

@property (nonatomic, strong) NSColor *todaySelectedBackgroundColor;

@property (nonatomic, readonly) PGPXDateCalloutTextField *textField;

@property (nonatomic, readonly) PGPXMarkerView *markerView;

@property (nonatomic, strong) NSDate *date;

- (void)setMarkers:(NSArray <NSColor *> *)markers;

@end
