//
//  PGPCalendarHeaderView.m
//  Pods
//
//  Created by Paul Pilone on 8/31/15.
//
//

#import "PGPCalendarHeaderView.h"

@implementation PGPCalendarHeaderView

/* */
- (instancetype)initWithWeekdaySymbols:(NSArray *)weekdaySymbols {
    self = [super init];
    if (self) {
        for (NSInteger i = 0; i < [weekdaySymbols count]; i++) {
            UILabel *label = [self labelWithWeekdaySymbol:weekdaySymbols[i]];
            [self addSubview:label];
            
            if (i == 0) {
                [self addConstraints:@[
                                       [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.f constant:0.f]
                                       ]];
            } else {
                UIView *previousLabel = [self subviews][i - 1];
                [self addConstraints:@[
                                       [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:previousLabel attribute:NSLayoutAttributeTrailing multiplier:1.f constant:0.f],
                                       [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:previousLabel attribute:NSLayoutAttributeWidth multiplier:1.f constant:0.f]
                                       ]];
                
                if (i == ([weekdaySymbols count] - 1)) {
                    [self addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.f constant:0.f]];
                }
            }
            
            [self addConstraints:@[
                                   [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.f constant:0.f],
                                   [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self  attribute:NSLayoutAttributeTop multiplier:1.f constant:0.f],
                                   [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.f constant:0.f]
                                   ]];
        }
    }
    
    return self;
}

#pragma mark -
#pragma mark Private

/* */
- (UILabel *)labelWithWeekdaySymbol:(NSString *)symbol {
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    label.text = [symbol uppercaseString];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    
    return label;
}

@end
