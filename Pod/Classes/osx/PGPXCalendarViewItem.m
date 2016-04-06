//
//  PGPXCalendarViewItem.m
//  PGPCalendarView
//
//  Created by Paul Pilone on 2/26/16.
//  Copyright © 2016 Paul Pilone. All rights reserved.
//

#import "PGPXCalendarViewItem.h"

#import "PGPXCalendarViewItemView.h"
#import "PGPXDateCalloutTextField.h"
#import "PGPXMarkerView.h"

@implementation PGPXCalendarViewItem

/* */
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [NSColor colorWithRed:253.f/255.f green:253.f/255.f blue:253.f/255.f alpha:1.f];
    self.selectedTextColor = [NSColor colorWithRed:231.f/255.f green:76.f/255.f blue:60.f/255.f alpha:1.f];
    self.textColor = [NSColor colorWithWhite:.25 alpha:1.f];
    self.todayTextColor = [NSColor colorWithRed:52.f/255.f green:152.f/255.f blue:219.f/255.f alpha:1.f];
    self.todaySelectedTextColor = [NSColor whiteColor];
    self.todaySelectedBackgroundColor = [NSColor colorWithRed:52.f/255.f green:152.f/255.f blue:219.f/255.f alpha:1.f];
}

/* */
- (void)setMarkers:(NSArray<NSColor *> *)markers {
    PGPXCalendarViewItemView *itemView = (PGPXCalendarViewItemView *)self.view;
    [itemView.markerView setMarkers:markers];
}

/* */
- (void)setToday:(BOOL)today {
    if (_today != today) {
        _today = today;
        
        [self updateDateField];
    }
}

/* */
- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    [self updateDateField];
}

#pragma mark -
#pragma mark Private

/* */
- (void)updateDateField {
    PGPXCalendarViewItemView *itemView = (PGPXCalendarViewItemView *)self.view;
    
    NSColor *textColor = nil;
    NSColor *fillColor = nil;
    if (self.selected && self.today) {
        fillColor = self.todaySelectedBackgroundColor;
        textColor = self.todaySelectedTextColor;
    } else if (self.selected && !self.today) {
        fillColor = self.backgroundColor;
        textColor = self.selectedTextColor;
    } else if (!self.selected && self.today) {
        fillColor = self.backgroundColor;
        textColor = self.todayTextColor;
    } else if (!self.selected) {
        fillColor = self.backgroundColor;
        textColor = self.textColor;
    }

    itemView.dateField.fillColor = fillColor;
    itemView.dateField.textColor = textColor;
}

@end
