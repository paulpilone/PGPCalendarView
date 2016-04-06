//
//  PGPXCalendarView.m
//  PGPCalendarView
//
//  Created by Paul Pilone on 2/25/16.
//  Copyright © 2016 Paul Pilone. All rights reserved.
//

#import "PGPXCalendarView.h"

#import "PGPCalendarController.h"
#import "PGPXCalendarViewItem.h"
#import "PGPXScrollView.h"
#import "PGPXCalendarHeaderView.h"

@interface PGPXCalendarView () < NSCollectionViewDataSource, NSCollectionViewDelegate, NSCollectionViewDelegateFlowLayout >

@property (nonatomic) BOOL needsFirstLayoutPass;

@property (nonatomic, strong) IBOutlet NSCollectionView *collectionView;

@property (nonatomic, strong) NSDateFormatter *monthFormatter;

@property (nonatomic, strong) IBOutlet NSButton *moveBackwardButton;

@property (nonatomic, strong) IBOutlet NSButton *moveForwardButton;

@property (nonatomic, strong) IBOutlet NSView *navigationView;

@property (nonatomic, strong) IBOutlet NSTextField *monthField;

@property (nonatomic, strong) IBOutlet PGPXCalendarHeaderView *headerView;

@property (nonatomic, strong) PGPCalendarController *calendarController;

@end

@interface NSImage (PGPXCalendarViewAdditions)

- (NSImage *)pgpx_imageTintedWithColor:(NSColor *)tint;

@end

@implementation PGPXCalendarView

/* */
- (instancetype)init {
    return [self initWithFrame:NSZeroRect];
}

/* */
- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self baseInit];
    }
    
    return self;
}

/* */
- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self) {
        [self baseInit];
    }
    
    return self;
}

/* */
- (void)dealloc {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self name:NSViewBoundsDidChangeNotification object:self.collectionView.enclosingScrollView.contentView];
}

/* */
//- (void)awakeFromNib {
//    [super awakeFromNib];
//    
//    NSString *calendarBundlePath = [[NSBundle mainBundle] pathForResource:@"PGPCalendarView" ofType:@"bundle"];
//    NSBundle *calendarBundle = [NSBundle bundleWithPath:calendarBundlePath];
//    
//    NSNib *nib = [[NSNib alloc] initWithNibNamed:NSStringFromClass([PGPXCalendarViewItem class]) bundle:calendarBundle];
//    [_collectionView registerNib:nib forItemWithIdentifier:PGPXCalendarViewItemIdentifier];
//}

/* */
- (NSCalendar *)calendar {
    return self.calendarController.calendar;
}

/* */
- (CGSize)pageSize {
    return [self.collectionView.enclosingScrollView.contentView documentVisibleRect].size;
}

/* */
- (void)reloadData {
    [self.collectionView reloadData];
}

/* */
- (void)setSelectedDate:(NSDate *)selectedDate {
    if (![self.calendarController isValidDate:selectedDate]) {
        return;
    }
    
    NSDate *startOfSelectedDate = [self.calendarController.calendar startOfDayForDate:selectedDate];
    if (_selectedDate != startOfSelectedDate) {
        NSIndexPath *oldIndexPath  = [self.calendarController indexPathForDate:_selectedDate];
        if (oldIndexPath) {
            [self.collectionView deselectItemsAtIndexPaths:[NSSet setWithObject:oldIndexPath]];
        }
        
        _selectedDate = startOfSelectedDate;
        
        NSIndexPath *newIndexPath = [self.calendarController indexPathForDate:_selectedDate];
        if (newIndexPath && !self.needsFirstLayoutPass) {
            [self selectItemAtIndexPath:newIndexPath];
        }
    }
}

/* */
- (void)layout {
    [super layout];
    
    if (self.needsFirstLayoutPass) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self selectItemAtIndexPath:[self.calendarController indexPathForDate:self.selectedDate]];
            [self updateMonthLabelForStartDate:[self firstVisibleDate] endDate:[self lastVisibleDate]];
        });
        self.needsFirstLayoutPass = NO;
    }
}

#pragma mark -
#pragma mark Actions

// TODO: New to NSScrollView. Consider subclassing NSCollectionView and implementing
// NSResponder's paging methods instead of doing the calculations here.

/* */
- (IBAction)pageBackward:(id)sender {
    NSRect documentVisibleRect = [self.collectionView.enclosingScrollView.contentView documentVisibleRect];
    
    CGPoint backPoint = NSMakePoint(documentVisibleRect.origin.x,
                                    documentVisibleRect.origin.y - self.pageSize.height);
    [self.collectionView scrollRectToVisible:NSMakeRect(0.f, backPoint.y, self.pageSize.width, self.pageSize.height)];
    
    // Select the first visible date.
    self.selectedDate = [self lastVisibleDate];
//    NSIndexPath *indexPath = [self.calendarController indexPathForDate:[self lastVisibleDate]];
//    if (indexPath) {
//        [self.collectionView selectItemsAtIndexPaths:[NSSet setWithObject:indexPath] scrollPosition:NSCollectionViewScrollPositionNone];
//    }
    
    if ([self.delegate respondsToSelector:@selector(calendarView:didSelectDate:)]) {
        [self.delegate calendarView:self didSelectDate:self.selectedDate];
    }
}

/* */
- (IBAction)pageForward:(id)sender {
    NSRect documentVisibleRect = [self.collectionView.enclosingScrollView.contentView documentVisibleRect];
    
    CGPoint forwardPoint = NSMakePoint(documentVisibleRect.origin.x,
                                       documentVisibleRect.origin.y + self.pageSize.height);
    [self.collectionView scrollRectToVisible:NSMakeRect(0.f, forwardPoint.y, self.pageSize.width, self.pageSize.height)];
    
    // Select the first visible date.
    self.selectedDate = [self firstVisibleDate];
//    NSIndexPath *indexPath = [self.calendarController indexPathForDate:[self firstVisibleDate]];
//    if (indexPath) {
//        //[self.collectionView selectItemsAtIndexPaths:[NSSet setWithObject:indexPath] scrollPosition:NSCollectionViewScrollPositionNone];
//        
//    }
    
    if ([self.delegate respondsToSelector:@selector(calendarView:didSelectDate:)]) {
        [self.delegate calendarView:self didSelectDate:self.selectedDate];
    }
}

#pragma mark -
#pragma mark Notifications

/* */
- (void)collectionViewBoundsChanged:(NSNotification *)notification {
    [self updateMonthLabelForStartDate:[self firstVisibleDate] endDate:[self lastVisibleDate]];
}

#pragma mark -
#pragma mark NSCollectionViewDataSource

/* */
- (NSInteger)numberOfSectionsInCollectionView:(NSCollectionView *)collectionView {
    return 1;
}

/* */
- (NSInteger)collectionView:(NSCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.calendarController numberOfDates];
}

/* */
- (NSCollectionViewItem *)collectionView:(NSCollectionView *)collectionView itemForRepresentedObjectAtIndexPath:(NSIndexPath *)indexPath {
    PGPXCalendarViewItem *item = (PGPXCalendarViewItem *)[collectionView makeItemWithIdentifier:PGPXCalendarViewItemIdentifier forIndexPath:indexPath];

    NSDate *date = [self.calendarController dateAtIndexPath:indexPath];
    if (date) {
        NSDateComponents *dateComps = [self.calendarController.calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay)  fromDate:date];
        item.representedObject = [NSString stringWithFormat:@"%ld", [dateComps day]];
        item.selected = [date isEqual:self.selectedDate];
        item.today = [self.calendarController isToday:date];

        NSArray *markers = [self.dataSource calendarView:self markersForDate:date];
        [item setMarkers:markers];
    } else {
        item.representedObject = @"";
        item.today = NO;
        [item setMarkers:@[]];
    }
    
    return item;
}

#pragma mark -
#pragma mark NSCollectionViewDelegate

/* */
- (void)collectionView:(NSCollectionView *)collectionView didSelectItemsAtIndexPaths:(NSSet<NSIndexPath *> *)indexPaths {
    NSIndexPath *indexPath = [indexPaths anyObject];
    
    NSDate *date = [self.calendarController dateAtIndexPath:indexPath];
    if (date == nil) {
        date = self.calendarController.startDate;
    }
    
    self.selectedDate = date;
    
    if ([self.delegate respondsToSelector:@selector(calendarView:didSelectDate:)]) {
        [self.delegate calendarView:self didSelectDate:date];
    }
}

#pragma mark -
#pragma mark NSCalendarViewFlowLayoutDelegate

/* */
//- (CGSize)collectionView:(NSCollectionView *)collectionView layout:(NSCollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    return CGSizeMake(self.pageSize.width / 7.f, self.pageSize.height / 4.f);
//}

#pragma mark -
#pragma mark NSView

/* */
- (BOOL)isFlipped {
    return YES;
}

/* */
- (void)mouseDown:(NSEvent *)theEvent {
    NSPoint locationInSelf = [self convertPoint:theEvent.locationInWindow fromView:nil];
    if (NSPointInRect(locationInSelf, self.monthField.frame)) {
        NSDate *today = [NSDate date];
        self.selectedDate = today;
        
        if ([self.delegate respondsToSelector:@selector(calendarView:didSelectDate:)]) {
            [self.delegate calendarView:self didSelectDate:today];
        }
    }
}

#pragma mark -
#pragma mark Private

/* */
- (void)baseInit {
    _calendarController = [[PGPCalendarController alloc] init];
    
    _monthFormatter = [[NSDateFormatter alloc] init];
    
    _needsFirstLayoutPass = YES;
    _selectedDate = _calendarController.startDate;

    _calendarHeaderTextColor = [NSColor colorWithWhite:.4 alpha:1.f];
    _calendarTextColor = [NSColor colorWithWhite:.26 alpha:1.f];
    _navigationButtonColor = [NSColor colorWithRed:231.f/255.f green:76.f/255.f blue:60.f/255.f alpha:1.f];
    _navigationTextColor = [NSColor colorWithWhite:.4 alpha:1.f];
    
    _navigationView = [[NSView alloc] init];
    _navigationView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_navigationView];
    
    _monthField = [[NSTextField alloc] init];
    _monthField.bordered = NO;
    _monthField.drawsBackground = NO;
    _monthField.editable = NO;
    _monthField.font = [NSFont systemFontOfSize:15.f];
    _monthField.textColor = _navigationTextColor;
    _monthField.translatesAutoresizingMaskIntoConstraints = NO;
    [_navigationView addSubview:_monthField];
    
    _moveBackwardButton = [[NSButton alloc] init];
    _moveBackwardButton.bordered = NO;
    _moveBackwardButton.imagePosition = NSImageOnly;
    _moveBackwardButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_moveBackwardButton setAction:@selector(pageBackward:)];
    [_moveBackwardButton setButtonType:NSMomentaryChangeButton];
    [_moveBackwardButton setTarget:self];
    ((NSButtonCell *)_moveBackwardButton.cell).imageScaling = NSImageScaleProportionallyDown;
    
    _moveForwardButton = [[NSButton alloc] init];
    _moveForwardButton.bordered = NO;
    _moveForwardButton.imagePosition = NSImageOnly;
    _moveForwardButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_moveForwardButton setAction:@selector(pageForward:)];
    [_moveForwardButton setButtonType:NSMomentaryChangeButton];
    [_moveForwardButton setTarget:self];
    ((NSButtonCell *)_moveForwardButton.cell).imageScaling = NSImageScaleProportionallyDown;
    
    [_navigationView addSubview:_moveBackwardButton];
    [_navigationView addSubview:_moveForwardButton];
    
    _headerView = [[PGPXCalendarHeaderView alloc] initWithWeekdaySymbols:_calendarController.shortWeekdaySymbols];
    _headerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_headerView];
    
    NSCollectionViewFlowLayout *flowLayout = [[NSCollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = NSMakeSize(40.f, 42.f);
    flowLayout.minimumInteritemSpacing = 0.f;
    flowLayout.minimumLineSpacing = 0.f;
    flowLayout.sectionInset = NSEdgeInsetsMake(0.f, 0.f, 0.f, 0.f);
    flowLayout.scrollDirection = NSCollectionViewScrollDirectionVertical;
    
    _collectionView = [[NSCollectionView alloc] initWithFrame:NSZeroRect];
    _collectionView.allowsMultipleSelection = NO;
    _collectionView.autoresizingMask = NSViewHeightSizable;
    _collectionView.backgroundColors = @[[NSColor colorWithWhite:253.f/255.f alpha:1.f]];
    _collectionView.collectionViewLayout = flowLayout;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.itemPrototype = nil;
    _collectionView.postsBoundsChangedNotifications = YES;
    _collectionView.selectable = YES;
    
    NSScrollView *scrollView = [[PGPXScrollView alloc] initWithFrame:NSZeroRect];
    scrollView.documentView = _collectionView;
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:scrollView];

    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(collectionViewBoundsChanged:) name:NSViewBoundsDidChangeNotification object:scrollView.contentView];
    
    NSDictionary *views = @{ @"monthField" : _monthField,
                             @"navigationView" : _navigationView,
                             @"moveBackwardButton" : _moveBackwardButton,
                             @"moveForwardButton" : _moveForwardButton,
                             @"headerView" : _headerView,
                             @"scrollView" : scrollView,
                             @"collectionView" : _collectionView };
    
    [_navigationView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-9-[monthField]-[moveBackwardButton(18)]-12-[moveForwardButton(18)]-9-|" options:0 metrics:nil views:views]];
    //[_navigationView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[monthField]|" options:0 metrics:nil views:views]];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:_monthField attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:_navigationView attribute:NSLayoutAttributeTop multiplier:1.f constant:0.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_monthField attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationLessThanOrEqual toItem:_navigationView attribute:NSLayoutAttributeBottom multiplier:1.f constant:0.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_monthField attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_navigationView attribute:NSLayoutAttributeCenterY multiplier:1.f constant:0.f]];
    
    [_navigationView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[moveForwardButton]|" options:0 metrics:nil views:views]];
    [_navigationView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[moveBackwardButton]|" options:0 metrics:nil views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-10-[navigationView]-10-|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-10-[headerView]-10-|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-10-[scrollView]-10-|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[navigationView(32)][headerView(17)][scrollView]|" options:0 metrics:nil views:views]];

//    [scrollView.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[collectionView]" options:0 metrics:nil views:views]];
//    [scrollView.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[collectionView]" options:0 metrics:nil views:views]];
    
    NSString *calendarBundlePath = [[NSBundle mainBundle] pathForResource:@"PGPCalendarView" ofType:@"bundle"];
    NSBundle *calendarBundle = [NSBundle bundleWithPath:calendarBundlePath];

    NSString *arrowPath = [calendarBundle pathForImageResource:@"HWExpandArrow.tiff"];
    NSImage *arrowImage = [[NSImage alloc] initWithContentsOfFile:arrowPath];
    [_moveForwardButton setImage:[arrowImage pgpx_imageTintedWithColor:_navigationButtonColor]];
    
    arrowPath = [calendarBundle pathForImageResource:@"HWCollapseArrow.tiff"];
    arrowImage = [[NSImage alloc] initWithContentsOfFile:arrowPath];
    [_moveBackwardButton setImage:[arrowImage pgpx_imageTintedWithColor:_navigationButtonColor]];
    
    NSNib *nib = [[NSNib alloc] initWithNibNamed:NSStringFromClass([PGPXCalendarViewItem class]) bundle:calendarBundle];
    [_collectionView registerNib:nib forItemWithIdentifier:PGPXCalendarViewItemIdentifier];
}

/* */
- (NSInteger)currentPage {
    NSRect documentVisibleRect = [self.collectionView.enclosingScrollView.contentView documentVisibleRect];
    return documentVisibleRect.origin.y / self.pageSize.height;
}

/* */
- (NSDate *)firstVisibleDate {
    NSDate *date = nil;
    
    // !!!: BIG HACK HERE
    // This code makes assumptions about backing calendar controller and how we're
    // deriving index paths. NSCollectionView#indexPathForItemAtPath always returns nil.
    // Until we figure out why, let's use this hack.
    NSInteger item = [self numberOfItemsPerPage] * [self currentPage];
    
    //NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:documentVisibleRect.origin];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];
    if (indexPath) {
        date = [self.calendarController dateAtIndexPath:indexPath];
    }
    
    return date;
}

/* */
- (NSDate *)lastVisibleDate {
    NSDate *date = nil;
    
    NSInteger item = ([self numberOfItemsPerPage] * [self currentPage]) + ([self numberOfItemsPerPage] - 1);

    // FIXME: See the comment in `firstVisibleDate`. This is a similar hack.
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];
    if (indexPath) {
        date = [self.calendarController dateAtIndexPath:indexPath];
    }
    
    return date;
}

/* */
- (NSInteger)numberOfItemsPerPage {
    return 4 * 7;
}

/* */
- (void)selectItemAtIndexPath:(NSIndexPath *)selectedIndexPath {
    if ([[self.collectionView indexPathsForVisibleItems] containsObject:selectedIndexPath]) {
        [self.collectionView selectItemsAtIndexPaths:[NSSet setWithObject:selectedIndexPath] scrollPosition:NSCollectionViewScrollPositionNone];
        return;
    }
    
    // Determine the page for the given index path.
    NSInteger page = floor(selectedIndexPath.item / 28);

    NSRect targetScrollRect = NSMakeRect(0, page * self.pageSize.height, self.pageSize.width, self.pageSize.height);
    [self.collectionView scrollRectToVisible:targetScrollRect];
    [self.collectionView selectItemsAtIndexPaths:[NSSet setWithObject:selectedIndexPath] scrollPosition:NSCollectionViewScrollPositionNone];
}

/* */
- (void)updateMonthLabelForStartDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    if (startDate && endDate) {
        NSCalendarUnit unitFlags = (NSCalendarUnitYear | NSCalendarUnitMonth);
        NSDateComponents *startDateComps = [self.calendarController.calendar components:unitFlags fromDate:startDate];
        NSDateComponents *endDateComps = [self.calendarController.calendar components:unitFlags fromDate:endDate];
        
        if (startDateComps.year == endDateComps.year
            && startDateComps.month == endDateComps.month) {
            [self.monthFormatter setDateFormat:@"MMMM yyyy"];
            [self.monthField setStringValue:[self.monthFormatter stringFromDate:startDate]];
        } else {
            [self.monthFormatter setDateFormat:@"MMM yyyy"];
            [self.monthField setStringValue:[NSString stringWithFormat:@"%@ - %@", [self.monthFormatter stringFromDate:startDate], [self.monthFormatter stringFromDate:endDate]]];
        }
    } else if (startDate) {
        [self.monthFormatter setDateFormat:@"MMMM yyyy"];
        [self.monthField setStringValue:[self.monthFormatter stringFromDate:startDate]];
    }
}

@end

@implementation NSImage (PGPXCalendarViewAdditions)

/* */
- (NSImage *)pgpx_imageTintedWithColor:(NSColor *)tint {
    NSImage *image = [self copy];
    
    if (tint == nil) {
        return image;
    }
    
    [image lockFocus];
    
    [tint set];
    NSRect imageRect = {NSZeroPoint, [image size]};
    NSRectFillUsingOperation(imageRect, NSCompositeSourceAtop);
    
    [image unlockFocus];
    
    return image;
}

@end