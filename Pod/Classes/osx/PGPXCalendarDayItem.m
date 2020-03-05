//
//  PGPXCalendarDayView.m
//  PGPCalendarView-iOS
//
//  Created by Paul Pilone on 9/27/17.
//

#import "PGPXCalendarDayItem.h"

#import "PGPXMarkerView.h"
#import "PGPXDateCalloutTextField.h"

@interface PGPXCalendarDayItem ()

@property (nonatomic, readwrite) PGPXDateCalloutTextField *textField;

@end

@implementation PGPXCalendarDayItem

/* */
- (instancetype)init {
  return [self initWithFrame:NSZeroRect];
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
- (instancetype)initWithCoder:(NSCoder *)decoder {
  self = [super initWithCoder:decoder];
  if (self) {
    [self baseInit];
  }
  
  return self;
}

/* */
- (void)mouseUp:(NSEvent *)event {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
  
  [self.target performSelector:self.action withObject:self];
  
#pragma clang diagnostic pop
}

- (void)setDate:(NSDate *)date {
  _date = date;
  
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDateComponents *comps = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:_date];
  self.textField.stringValue = [NSString stringWithFormat:@"%ld", comps.day];
}

- (void)setMarkers:(NSArray <NSColor *> *)markers {
  [self.markerView setMarkers:markers];
}

- (void)setSelectable:(BOOL)selectable {
  _selectable = selectable;
  
  [self updateTextField];
}

- (void)setSelected:(BOOL)selected {
  _selected = selected;
  
  [self updateTextField];
}

- (void)setToday:(BOOL)today {
  _today = today;
  
  [self updateTextField];
}

#pragma mark -
#pragma mark Private

/* */
- (void)baseInit {
  self.backgroundColor = [NSColor colorWithRed:253.f/255.f green:253.f/255.f blue:253.f/255.f alpha:1.f];
  self.selectedTextColor = [NSColor colorWithRed:231.f/255.f green:76.f/255.f blue:60.f/255.f alpha:1.f];
  self.textColor = [NSColor colorWithWhite:.25 alpha:1.f];
  self.todayTextColor = [NSColor colorWithRed:52.f/255.f green:152.f/255.f blue:219.f/255.f alpha:1.f];
  self.todaySelectedTextColor = [NSColor whiteColor];
  self.todaySelectedBackgroundColor = [NSColor colorWithRed:52.f/255.f green:152.f/255.f blue:219.f/255.f alpha:1.f];
  
  _textField = [[PGPXDateCalloutTextField alloc] init];
  _textField.translatesAutoresizingMaskIntoConstraints = NO;
  
  [_textField addConstraints:@[[NSLayoutConstraint constraintWithItem:_textField attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:18.f]]];
  
  _markerView = [[PGPXMarkerView alloc] init];
  _markerView.translatesAutoresizingMaskIntoConstraints = NO;
  [_markerView addConstraints:@[
                                [NSLayoutConstraint constraintWithItem:_markerView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:34.f],
                                [NSLayoutConstraint constraintWithItem:_markerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:18.f]
                                ]];
  
  [self addSubview:_textField];
  [self addSubview:_markerView];
  
  [self addConstraints:@[
                         [NSLayoutConstraint constraintWithItem:_textField attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.f constant:0.f],
                         [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:_textField attribute:NSLayoutAttributeTrailing multiplier:1.f constant:0.f],
                         [NSLayoutConstraint constraintWithItem:_textField attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f],
                         [NSLayoutConstraint constraintWithItem:_markerView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f],
                         [NSLayoutConstraint constraintWithItem:_textField attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual  toItem:_markerView attribute:NSLayoutAttributeTop multiplier:1.f constant:0.f],
                         ]];
}

/* */
- (void)updateTextField {
  NSColor *textColor = nil;
  NSColor *fillColor = nil;
  
  if (self.selectable && self.selected && self.today) {
    fillColor = self.todaySelectedBackgroundColor;
    textColor = self.todaySelectedTextColor;
  } else if (self.selectable && self.selected && !self.today) {
    fillColor = self.backgroundColor;
    textColor = self.selectedTextColor;
  } else if (!self.selectable && self.today) {
    fillColor = self.backgroundColor;
    textColor = self.todayTextColor;
  } else if (self.selectable) {
    fillColor = self.backgroundColor;
    textColor = self.textColor;
  } else {
    fillColor = self.backgroundColor;
    textColor = [NSColor colorWithWhite:.6 alpha:1.f];
  }
  
  self.textField.fillColor = fillColor;
  self.textField.textColor = textColor;
}

@end
