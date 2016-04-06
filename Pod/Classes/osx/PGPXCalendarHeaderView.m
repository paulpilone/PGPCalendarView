//
//  PGPXCalendarHeaderView.m
//  iHomework2OSX
//
//  Created by Paul Pilone on 2/27/16.
//  Copyright © 2016 Paul Pilone. All rights reserved.
//

#import "PGPXCalendarHeaderView.h"

@implementation PGPXCalendarHeaderView

/* */
- (instancetype)initWithWeekdaySymbols:(NSArray<NSString *> *)weekdaySymbols {
    self = [super init];
    if (self) {
        for (NSInteger i = 0; i < [weekdaySymbols count]; i++) {
            NSTextField *label = [self labelWithWeekdaySymbol:weekdaySymbols[i]];
            [self addSubview:label];
            
            if (i == 0) {
                [self addConstraints:@[
                                       [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.f constant:0.f]
                                       ]];
            } else {
                NSTextField *previousLabel = [self subviews][i - 1];
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
                                   [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self  attribute:NSLayoutAttributeTop multiplier:1.f constant:2.f],
                                   [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.f constant:-2.f]
                                   ]];
        }
        
    }
    
    return self;
}

#pragma mark -
#pragma mark Private

/* */
- (NSTextField *)labelWithWeekdaySymbol:(NSString *)symbol {
    NSTextField *label = [[NSTextField alloc] init];
    label.alignment = NSTextAlignmentCenter;
    label.bordered = NO;
    label.drawsBackground = NO;
    label.editable = NO;
    label.font = [NSFont systemFontOfSize:[NSFont systemFontSizeForControlSize:NSMiniControlSize]
                                   weight:NSFontWeightSemibold];
    label.textColor = [NSColor colorWithWhite:.4 alpha:1.f];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [label setStringValue:[symbol uppercaseString]];

    return label;
}

@end
