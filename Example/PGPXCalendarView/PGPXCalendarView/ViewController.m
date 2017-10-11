//
//  ViewController.m
//  PGPXCalendarView
//
//  Created by Paul Pilone on 9/26/17.
//  Copyright © 2017 Paul Pilone. All rights reserved.
//

#import "ViewController.h"

#import "PGPXCalendarView.h"

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  // Do any additional setup after loading the view.
}

/* */
- (void)viewWillAppear {
  [super viewWillAppear];
  
  self.calendarView.selectedDate = [NSDate date];
}

- (void)setRepresentedObject:(id)representedObject {
  [super setRepresentedObject:representedObject];

  // Update the view, if already loaded.
}

- (void)calendarView:(PGPXCalendarView *)calendarView didSelectDate:(NSDate *)date {
  // DO Stuff!
}

/* */
- (NSArray *)calendarView:(PGPXCalendarView *)calendarView markersForDate:(NSDate *)date {
  return @[[NSColor redColor], [NSColor blueColor]];
}

@end
