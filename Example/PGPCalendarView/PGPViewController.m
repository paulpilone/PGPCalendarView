//
//  PGPViewController.m
//  PGPCalendarView
//
//  Created by Paul Pilone on 08/30/2015.
//  Copyright (c) 2015 Paul Pilone. All rights reserved.
//

#import "PGPViewController.h"

#import "PGPCalendarView.h"

@interface PGPViewController () < PGPCalendarViewDataSource >
@property (weak, nonatomic) IBOutlet PGPCalendarView *calendarView;

@end

@implementation PGPViewController

- (IBAction)today:(id)sender {
    [self.calendarView setSelectedDate:[NSDate date] animated:YES];
}

- (NSArray *)calendarView:(PGPCalendarView *)calendarView markersForDate:(NSDate *)date {
    
    NSDateComponents *comps = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    NSInteger divisible = comps.day % 4;
    if (divisible == 0) {
        return @[
                 [UIColor redColor],
                 [UIColor blueColor],
                 [UIColor greenColor],
                 [UIColor redColor],
                 [UIColor blackColor]
                 ];
    } else if (divisible == 1) {
        return @[
                 [UIColor cyanColor],
                 [UIColor blackColor],
                 [UIColor redColor],
                 [UIColor greenColor]
                ];
    } else if (divisible == 2) {
        return @[
                 [UIColor redColor],
                 [UIColor blueColor],
                 [UIColor greenColor],
                 [UIColor redColor],
                 [UIColor redColor],
                 [UIColor blueColor],
                 [UIColor greenColor],
                 [UIColor redColor]
                 ];
    } else {
        return @[
                 [UIColor cyanColor],
                 [UIColor blackColor],
                 [UIColor redColor]
                 ];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.calendarView.dataSource = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
