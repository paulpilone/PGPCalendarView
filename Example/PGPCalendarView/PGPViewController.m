//
//  PGPViewController.m
//  PGPCalendarView
//
//  Created by Paul Pilone on 08/30/2015.
//  Copyright (c) 2015 Paul Pilone. All rights reserved.
//

#import "PGPViewController.h"

#import "PGPCalendarView.h"

@interface PGPViewController ()
@property (weak, nonatomic) IBOutlet PGPCalendarView *calendarView;

@end

@implementation PGPViewController

- (IBAction)today:(id)sender {
    [self.calendarView setSelectedDate:[NSDate date] animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
