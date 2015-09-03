//
//  PGPCalendarViewCell.h
//  Pods
//
//  Created by Paul Pilone on 8/30/15.
//
//

#import <UIKit/UIKit.h>

static NSString * const PGPCalendarViewCellIdentifier = @"PGPCalendarViewCellIdentifier";

@interface PGPCalendarViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (nonatomic, getter=isToday) BOOL today;

@property (nonatomic, strong) UIColor *textColor UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIColor *todayTextColor UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIColor *todaySelectedTextColor UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIColor *todaySelectedBackgroundColor UI_APPEARANCE_SELECTOR;

- (void)setMarkers:(NSArray *)markers;

@end
