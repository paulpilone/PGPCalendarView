//
//  PGPCalendarView.h
//  Pods
//
//  Created by Paul Pilone on 8/30/15.
//
//

#import <UIKit/UIKit.h>

@interface PGPCalendarView : UIView

@property (nonatomic, strong) NSDate *selectedDate;

- (void)setSelectedDate:(NSDate *)selectedDate animated:(BOOL)animated;

@end
