//
//  ViewController.h
//  PGPXCalendarView
//
//  Created by Paul Pilone on 9/26/17.
//  Copyright © 2017 Paul Pilone. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "PGPXCalendarView.h"

@interface ViewController : NSViewController < PGPXCalendarViewDataSource, PGPXCalendarViewDelegate >

@property (strong) IBOutlet PGPXCalendarView *calendarView;

@end

