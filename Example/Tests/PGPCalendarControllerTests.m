//
//  PGPCalendarControllerTests.m
//  PGPCalendarView
//
//  Created by Paul Pilone on 1/13/16.
//  Copyright © 2016 Paul Pilone. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "PGPCalendarController.h"

@interface PGPCalendarControllerTests : XCTestCase

@end

@implementation PGPCalendarControllerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testShortWeekdaySymbols {
    PGPCalendarController *calendarController = [[PGPCalendarController alloc] init];
    NSArray *expectedSymbols = @[@"Sun", @"Mon", @"Tue", @"Wed", @"Thu", @"Fri", @"Sat"];
    XCTAssertEqualObjects(expectedSymbols, calendarController.shortWeekdaySymbols);
}

- (void)testShortWeekdaySymbolsRegionStartingOnMonday {
    PGPCalendarController *calendarController = [[PGPCalendarController alloc] init];
    
    NSLocale *foreignLocale = [NSLocale localeWithLocaleIdentifier:@"de_DE"];
    [calendarController.calendar setLocale:foreignLocale];
    [calendarController.dateFormatter setLocale:foreignLocale];
    
    NSArray *expectedSymbols = @[@"Mo.", @"Di.", @"Mi.", @"Do.", @"Fr.", @"Sa.", @"So."];
    XCTAssertEqualObjects(expectedSymbols, calendarController.shortWeekdaySymbols);
}

@end
