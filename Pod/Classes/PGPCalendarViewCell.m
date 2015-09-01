//
//  PGPCalendarViewCell.m
//  Pods
//
//  Created by Paul Pilone on 8/30/15.
//
//

#import "PGPCalendarViewCell.h"

@implementation PGPCalendarViewCell

/* */
- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    self.textLabel.textColor = selected ? [UIColor blueColor] : [UIColor blackColor];
}

@end
