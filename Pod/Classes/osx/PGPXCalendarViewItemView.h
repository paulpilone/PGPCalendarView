//
//  PGPXCalendarViewItemView.h
//  PGPCalendarView
//
//  Created by Paul Pilone on 2/27/16.
//  Copyright © 2016 Paul Pilone. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PGPXDateCalloutTextField;
@class PGPXMarkerView;

@interface PGPXCalendarViewItemView : NSView

@property (weak) IBOutlet PGPXDateCalloutTextField *dateField;

@property (weak) IBOutlet PGPXMarkerView *markerView;

@end
