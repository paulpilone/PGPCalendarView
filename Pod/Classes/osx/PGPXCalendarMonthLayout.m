//
//  PGPXCalendarDayContainerView.m
//  PGPCalendarView-iOS
//
//  Created by Paul Pilone on 9/27/17.
//

#import "PGPXCalendarMonthLayout.h"

#import "PGPXCalendarDayItem.h"

@interface PGPXCalendarMonthLayout ()

@property (strong, readwrite) NSArray *items;

@end

@implementation PGPXCalendarMonthLayout

static NSInteger PGPXCalendarMonthLayoutNumberOfColumns = 7;
static NSInteger PGPXCalendarMonthLayoutNumberOfRows = 6;

/* */
- (instancetype)init {
  return [self initWithFrame:NSZeroRect];
}

/* */
- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self baseInit];
  }
  
  return self;
}

/* */
- (instancetype)initWithCoder:(NSCoder *)decoder {
  self = [super initWithCoder:decoder];
  if (self) {
    [self baseInit];
  }
  
  return self;
}

/* */
- (void)deselectDate:(NSDate *)date {
  PGPXCalendarDayItem *selectedItem = nil;
  for (PGPXCalendarDayItem *item in self.items) {
    if (item.selected) {
      selectedItem = item;
      break;
    }
  }
  
  if (selectedItem) {
    selectedItem.selected = false;
  }
}

/* */
- (IBAction)itemSelected:(id)sender {
  if ([sender respondsToSelector:@selector(date)] && [sender respondsToSelector:@selector(selected)]) {
    if (![sender selected]) {
      if ([self.delegate respondsToSelector:@selector(calendarMonthLayout:didSelectDate:)]) {
        [self.delegate calendarMonthLayout:self didSelectDate:[sender date]];
      }
    }
  }
}

#pragma mark -
#pragma mark Private

/* */
- (void)baseInit {
  self.translatesAutoresizingMaskIntoConstraints = NO;
  
  NSMutableArray *mutableItems = [NSMutableArray arrayWithCapacity:PGPXCalendarMonthLayoutNumberOfColumns * PGPXCalendarMonthLayoutNumberOfRows];
  for (NSInteger i = 0; i < PGPXCalendarMonthLayoutNumberOfRows * PGPXCalendarMonthLayoutNumberOfColumns; i++) {
    PGPXCalendarDayItem *dayView = [[PGPXCalendarDayItem alloc] init];
    dayView.target = self;
    dayView.action = @selector(itemSelected:);
    dayView.translatesAutoresizingMaskIntoConstraints = NO;
    [mutableItems addObject:dayView];
  }
  
  _items = mutableItems;
  
  NSMutableArray *mutableRowViews = [NSMutableArray arrayWithCapacity:PGPXCalendarMonthLayoutNumberOfRows];
  for (NSInteger i = 0; i < PGPXCalendarMonthLayoutNumberOfRows; i++) {
    NSRange columnRange = NSMakeRange(i * PGPXCalendarMonthLayoutNumberOfColumns, PGPXCalendarMonthLayoutNumberOfColumns);
    NSStackView *rowView = [NSStackView stackViewWithViews:[mutableItems subarrayWithRange:columnRange]];
    rowView.alignment = NSLayoutAttributeLeading;
    rowView.distribution = NSStackViewDistributionFillEqually;
    rowView.orientation = NSUserInterfaceLayoutOrientationHorizontal;
    rowView.spacing = 0.f;
    rowView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [mutableRowViews addObject:rowView];
  }
  
  NSStackView *gridView = [NSStackView stackViewWithViews:mutableRowViews];
  gridView.alignment = NSLayoutAttributeTop;
  gridView.distribution = NSStackViewDistributionFillEqually;
  gridView.orientation = NSUserInterfaceLayoutOrientationVertical;
  gridView.spacing = 0.f;
  gridView.translatesAutoresizingMaskIntoConstraints = NO;
 [gridView setHuggingPriority:NSLayoutPriorityRequired forOrientation:NSLayoutConstraintOrientationVertical];
  
  [self addSubview:gridView];
  
  [gridView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
  [gridView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
  [gridView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
  [gridView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
}

@end
