//
//  PGPCalendarController.h
//  Pods
//
//  Created by Paul Pilone on 8/31/15.
//
//

#import <Foundation/Foundation.h>

@interface PGPCalendarController : NSObject

@property (nonatomic, readonly) NSDate *endDate;

@property (nonatomic, readonly) NSDate *startDate;

/* */
- (NSInteger)numberOfDates;

/* */
- (NSDate *)dateAtIndexPath:(NSIndexPath *)indexPath;

@end
