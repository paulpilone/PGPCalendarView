//
//  PGPXCalendarViewItem.h
//  PGPCalendarView
//
//  Created by Paul Pilone on 2/26/16.
//  Copyright © 2016 Paul Pilone. All rights reserved.
//

#import <Cocoa/Cocoa.h>

static NSString * __nonnull const PGPXCalendarViewItemIdentifier = @"PGPXCalendarViewItemIdentifier";

@interface PGPXCalendarViewItem : NSCollectionViewItem

@property (nonatomic) BOOL today;

@property (nonatomic, nonnull, strong) NSColor *backgroundColor;

@property (nonatomic, nonnull, strong) NSColor *selectedTextColor;

@property (nonatomic, nonnull, strong) NSColor *textColor;

@property (nonatomic, nonnull, strong) NSColor *todayTextColor;

@property (nonatomic, nonnull, strong) NSColor *todaySelectedTextColor;

@property (nonatomic, nonnull, strong) NSColor *todaySelectedBackgroundColor;

- (void)setMarkers:(nullable NSArray <NSColor *> *)markers;

@end
