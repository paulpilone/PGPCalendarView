//
//  PGPXScrollView.m
//  PGPCalendarView
//
//  Created by Paul Pilone on 2/26/16.
//  Copyright © 2016 Paul Pilone. All rights reserved.
//

#import "PGPXScrollView.h"

@implementation PGPXScrollView

/* */
- (BOOL)hasVerticalScroller {
    return NO;
}

/* */
- (void)scrollWheel:(NSEvent *)theEvent {
    // no-op.
}

@end
