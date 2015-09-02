//
//  PGPCalendarViewCell.m
//  Pods
//
//  Created by Paul Pilone on 8/30/15.
//
//

#import "PGPCalendarViewCell.h"

@interface PGPCalendarViewCell ()
@end

@implementation PGPCalendarViewCell

/* */
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.dateLabel.clipsToBounds = YES;
    self.dateLabel.layer.cornerRadius = 3.f;
    self.dateLabel.textColor = self.textColor;
    
    self.todaySelectedTextColor = [UIColor whiteColor];
}

/* */
- (void)prepareForReuse {
    [super prepareForReuse];

    self.today = NO;
}

/* */
- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (selected) {
        if (self.today) {
            self.dateLabel.backgroundColor = self.todaySelectedBackgroundColor;
            self.dateLabel.textColor = self.todaySelectedTextColor;
        } else {
            self.dateLabel.backgroundColor = self.backgroundColor;
            self.dateLabel.textColor = self.tintColor;
        }
    } else {
        self.dateLabel.backgroundColor = self.backgroundColor;

        if (self.today) {
            self.dateLabel.textColor = self.todayTextColor;
        } else {
            self.dateLabel.textColor = self.textColor;
        }
    }
}

/* */
- (void)setToday:(BOOL)today {
    if (_today != today) {
        _today = today;
        
        self.dateLabel.textColor = _today ? self.todayTextColor : self.textColor;
    }
}

@end
