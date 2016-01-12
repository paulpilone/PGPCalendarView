//
//  PGPCalendarView.m
//  Pods
//
//  Created by Paul Pilone on 8/30/15.
//
//

#import "PGPCalendarView.h"

#import "NSDate+PGPCalendarViewAdditions.h"
#import "PGPCalendarController.h"
#import "PGPCalendarViewCell.h"
#import "PGPCalendarHeaderView.h"

@interface PGPCalendarView () < UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout >

@property (nonatomic) BOOL needsFirstLayoutPass;

@property (nonatomic) CGSize pageSize;

@property (nonatomic, strong) NSDate *draggingStartDate;

@property (nonatomic, strong) NSDateFormatter *monthFormatter;

@property (nonatomic, strong) PGPCalendarController *calendarController;

@property (nonatomic, strong) PGPCalendarHeaderView *headerView;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIView *borderView;

/* Navigation views */

@property (nonatomic, strong) UIButton *moveBackwardButton;

@property (nonatomic, strong) UIButton *moveForwardButton;

@property (nonatomic, readwrite) UILabel *monthLabel;

@property (nonatomic, strong) UIView *navigationView;

@end

@implementation PGPCalendarView

/* */
- (instancetype)init {
    return [self initWithFrame:CGRectZero];
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
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self baseInit];
    }
    
    return self;
}

/* */
- (NSCalendar *)calendar {
    return self.calendarController.calendar;
}

/* */
- (NSInteger)indexForDate:(NSDate *)date {
    NSIndexPath *indexPath = [self.calendarController indexPathForDate:date];
    return indexPath != nil ? indexPath.item : NSNotFound;
}

/* */
- (void)layoutSubviews {
    [super layoutSubviews];

    if (self.needsFirstLayoutPass) {
        [self selectItemAtIndexPath:[self.calendarController indexPathForDate:self.selectedDate] animated:NO];
        [self updateMonthLabelForStartDate:[self firstVisibleDate] endDate:[self lastVisibleDate]];
        self.needsFirstLayoutPass = NO;
    }
}

/* */
- (CGSize)pageSize {
    return CGSizeMake(CGRectGetWidth(self.collectionView.bounds),
                      CGRectGetHeight(self.collectionView.bounds));
}

/* */
- (void)reloadData {
    [self.collectionView reloadData];
}

/* */
- (void)reloadDate:(NSDate *)date {
    NSIndexPath *indexPath = [self.calendarController indexPathForDate:date];
    if (indexPath) {
        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    }
}

/* */
- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    
    self.collectionView.backgroundColor = backgroundColor;
    self.headerView.backgroundColor = backgroundColor;
    self.monthLabel.backgroundColor = backgroundColor;
    self.navigationView.backgroundColor = backgroundColor;
}

/* */
- (void)setBorderColor:(UIColor *)borderColor {
    self.borderView.backgroundColor = borderColor;
}

/* */
- (void)setSelectedDate:(NSDate *)selectedDate {
    [self setSelectedDate:selectedDate animated:NO];
}

/* */
- (void)setSelectedDate:(NSDate *)selectedDate animated:(BOOL)animated {
    if (![self.calendarController isValidDate:selectedDate]) {
        return;
    }
    
    NSDate *startOfSelectedDate = [self.calendarController.calendar startOfDayForDate:selectedDate];
    if (_selectedDate != startOfSelectedDate) {
        NSIndexPath *oldIndexPath  = [self.calendarController indexPathForDate:_selectedDate];
        if (oldIndexPath) {
            UICollectionViewCell *oldCell = [self.collectionView cellForItemAtIndexPath:oldIndexPath];
            oldCell.selected = NO;
        }
        
        _selectedDate = startOfSelectedDate;
        
        NSIndexPath *newIndexPath = [self.calendarController indexPathForDate:_selectedDate];
        if (newIndexPath && !self.needsFirstLayoutPass) {
            [self selectItemAtIndexPath:newIndexPath animated:animated];
        }
    }
}

/* */
- (void)setUserNavigationEnabled:(BOOL)userNavigationEnabled {
    if (_userNavigationEnabled != userNavigationEnabled) {
        _userNavigationEnabled = userNavigationEnabled;
        
        self.moveBackwardButton.hidden = !_userNavigationEnabled;
        self.moveForwardButton.hidden = !_userNavigationEnabled;
        self.collectionView.scrollEnabled = _userNavigationEnabled;
    }
}

/* */
- (void)tintColorDidChange {
    self.moveBackwardButton.tintColor = [self.tintColor colorWithAlphaComponent:0.65];
    self.moveForwardButton.tintColor = [self.tintColor colorWithAlphaComponent:0.65];
}

#pragma mark -
#pragma mark Actions

/* */
- (IBAction)moveBackward:(id)sender {
    CGPoint backPoint = CGPointMake(CGRectGetMaxX(self.collectionView.bounds) - 1,
                                    self.collectionView.contentOffset.y - 1.f);
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:backPoint];
    if (indexPath) {
        NSDate *date = [self.calendarController dateAtIndexPath:indexPath];
        if (date) {
            [self setSelectedDate:date animated:YES];
            
            if ([self.delegate respondsToSelector:@selector(calendarView:didSelectDate:)]) {
                [self.delegate calendarView:self didSelectDate:date];
            }
        }
    }
}

/* */
- (IBAction)moveForward:(id)sender {
    CGPoint forwardPoint = CGPointMake(self.collectionView.contentOffset.x,
                                       self.collectionView.contentOffset.y + self.pageSize.height);
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:forwardPoint];
    if (indexPath) {
        NSDate *date = [self.calendarController dateAtIndexPath:indexPath];
        if (date) {
            [self setSelectedDate:date animated:YES];
            
            if ([self.delegate respondsToSelector:@selector(calendarView:didSelectDate:)]) {
                [self.delegate calendarView:self didSelectDate:date];
            }
        }
    }
}

#pragma mark -
#pragma mark Private

/* */
- (void)baseInit {
    _borderColor = [UIColor colorWithWhite:0.95 alpha:1.f];
    _calendarController = [[PGPCalendarController alloc] init];
    _displayMode = PGPCalendarViewDisplayModeTwoWeeks;
    _userNavigationEnabled = YES;
    
    _monthFormatter = [[NSDateFormatter alloc] init];

    _needsFirstLayoutPass = YES;
    _selectedDate = _calendarController.startDate;
    
    _navigationView = [[UIView alloc] init];
    _navigationView.backgroundColor = self.backgroundColor;
    _navigationView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_navigationView];
    
    _moveBackwardButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _moveBackwardButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_moveBackwardButton addTarget:self action:@selector(moveBackward:) forControlEvents:UIControlEventTouchUpInside];
    [_moveBackwardButton setImage:[UIImage imageNamed:@"PGPCalendarView.bundle/HWCollapseArrow"] forState:UIControlStateNormal];
    [_navigationView addSubview:_moveBackwardButton];

    _monthLabel = [[UILabel alloc] init];
    _monthLabel.backgroundColor = self.backgroundColor;
    _monthLabel.minimumScaleFactor = 0.75;
    _monthLabel.textAlignment = NSTextAlignmentCenter;
    _monthLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_navigationView addSubview:_monthLabel];

    _moveForwardButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _moveForwardButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_moveForwardButton addTarget:self action:@selector(moveForward:) forControlEvents:UIControlEventTouchUpInside];
    [_moveForwardButton setImage:[UIImage imageNamed:@"PGPCalendarView.bundle/HWExpandArrow"] forState:UIControlStateNormal];
    [_navigationView addSubview:_moveForwardButton];
    
    CGFloat buttonWidth = 36.f;
    NSDictionary *views = NSDictionaryOfVariableBindings(_moveBackwardButton, _monthLabel, _moveForwardButton);
    [_navigationView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_moveBackwardButton(buttonWidth)]-[_monthLabel]-[_moveForwardButton(buttonWidth)]-|" options:(NSLayoutFormatAlignAllBottom | NSLayoutFormatAlignAllTop) metrics:@{ @"buttonWidth" : @(buttonWidth) } views:views]];
    [_navigationView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-2-[_monthLabel]-2-|" options:0 metrics:nil views:views]];
    [self addSubview:_navigationView];
    
    _headerView = [[PGPCalendarHeaderView alloc] initWithWeekdaySymbols:self.calendarController.shortWeekdaySymbols];
    _headerView.backgroundColor = self.backgroundColor;
    _headerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_headerView];

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 0.f;
    flowLayout.minimumLineSpacing = 0.f;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = self.backgroundColor;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_collectionView];
    
    _borderView = [[UIView alloc] init];
    _borderView.backgroundColor = _borderColor;
    _borderView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_borderView];
    
    views = NSDictionaryOfVariableBindings(_navigationView, _headerView, _collectionView, _borderView);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_navigationView]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_headerView]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_collectionView]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_borderView]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_navigationView(32)][_headerView(17)][_collectionView][_borderView(1)]|" options:0 metrics:nil views:views]];
    
    NSString *calendarBundlePath = [[NSBundle mainBundle] pathForResource:@"PGPCalendarView" ofType:@"bundle"];
    NSBundle *calendarBundle = [NSBundle bundleWithPath:calendarBundlePath];
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([PGPCalendarViewCell class]) bundle:calendarBundle];
    [_collectionView registerNib:nib forCellWithReuseIdentifier:PGPCalendarViewCellIdentifier];
}

/* */
- (NSDate *)firstVisibleDate {
    NSDate *date = nil;
    
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:self.collectionView.contentOffset];
    if (indexPath) {
        date = [self.calendarController dateAtIndexPath:indexPath];
    }
    
    return date;
}

/* */
- (NSDate *)lastVisibleDate {
    NSDate *date = nil;
    
    CGPoint lastPoint = CGPointMake(CGRectGetMaxX(self.bounds) - 1.f,
                                    self.collectionView.contentOffset.y + CGRectGetHeight(self.collectionView.bounds) - 1);
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:lastPoint];
    if (indexPath) {
        date = [self.calendarController dateAtIndexPath:indexPath];
    }
    
    return date;
}

/* */
- (CGFloat)numberOfDatesPerPageForDisplayMode:(enum PGPCalendarViewDisplayMode)mode {
    CGFloat dates;
    
    switch (self.displayMode) {
        case PGPCalendarViewDisplayModeTwoWeeks:
            dates = 14;
            break;
        case PGPCalendarViewDisplayModeOneMonth:
            dates = 28;
            break;
        default:
            dates = 7;
    }
    
    return dates;
}

/* */
- (CGFloat)numberOfRowsPerPageForDisplayMode:(enum PGPCalendarViewDisplayMode)mode {
    CGFloat rows;
    
    switch (self.displayMode) {
        case PGPCalendarViewDisplayModeTwoWeeks:
            rows = 2;
            break;
        case PGPCalendarViewDisplayModeOneMonth:
            rows = 4;
            break;
        default:
            rows = 1;
            break;
    }
    
    return rows;
}

/* */
- (void)selectItemAtIndexPath:(NSIndexPath *)selectedIndexPath animated:(BOOL)animated {
    if ([[self.collectionView indexPathsForVisibleItems] containsObject:selectedIndexPath]) {
            [self.collectionView selectItemAtIndexPath:selectedIndexPath animated:animated scrollPosition:UICollectionViewScrollPositionNone];
        return;
    }
    
    // Determine the page for the given index path.
    NSInteger page = floor(selectedIndexPath.item / [self numberOfDatesPerPageForDisplayMode:self.displayMode]);
    
    // Get the first item (top left corner) on this page. We use this item as the target scroll index path
    // so that we can always animate with a scroll position of 'top'.
    NSIndexPath *targetScrollIndexPath = [self.collectionView indexPathForItemAtPoint:CGPointMake(0.f, page * self.pageSize.height)];
    
    UICollectionViewScrollPosition selectedIndexPathScrollPosition = UICollectionViewScrollPositionCenteredHorizontally;
    if (targetScrollIndexPath) {
        [self.collectionView scrollToItemAtIndexPath:targetScrollIndexPath atScrollPosition:UICollectionViewScrollPositionTop animated:animated];
        selectedIndexPathScrollPosition = UICollectionViewScrollPositionNone;
    }

    [self.collectionView selectItemAtIndexPath:selectedIndexPath animated:animated scrollPosition:selectedIndexPathScrollPosition];
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
            self.monthLabel.text = [self.monthFormatter stringFromDate:startDate];
        } else {
            [self.monthFormatter setDateFormat:@"MMM yyyy"];
            self.monthLabel.text = [NSString stringWithFormat:@"%@ - %@", [self.monthFormatter stringFromDate:startDate], [self.monthFormatter stringFromDate:endDate]];
        }
    } else {
        [self.monthFormatter setDateFormat:@"MMMM yyyy"];
        self.monthLabel.text = [self.monthFormatter stringFromDate:startDate];
    }
}

#pragma mark -
#pragma mark UICollectionViewDataSource

/* */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.calendarController numberOfDates];
}

/* */
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PGPCalendarViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PGPCalendarViewCellIdentifier forIndexPath:indexPath];
    cell.tintColor = self.tintColor;
    cell.textColor = self.dayTextColor;
    cell.todaySelectedBackgroundColor = self.todaySelectedBackgroundColor;
    cell.todaySelectedTextColor = self.todaySelectedTextColor;
    cell.todayTextColor = self.todayTextColor;
    
    NSDate *date = [self.calendarController dateAtIndexPath:indexPath];
    if (date == nil) { // Placeholder cell.
        cell.dateLabel.text = nil;
    } else {
        cell.today = [self.calendarController isToday:date];
        cell.selected = [date isEqual:self.selectedDate];
        
        NSDateComponents *dateComps = [self.calendarController.calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay)  fromDate:date];
        cell.dateLabel.text = [NSString stringWithFormat:@"%ld", (long) [dateComps day]];
        
        cell.markers = [self.dataSource calendarView:self markersForDate:date];
    }
    
    return cell;
}

#pragma mark -
#pragma mark UICollectionViewDelegate

/* */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
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
#pragma mark UICollectionViewDelegateFlowLayout

/* */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.pageSize.width / 7.f, self.pageSize.height / [self numberOfRowsPerPageForDisplayMode:self.displayMode]);
}

#pragma mark -
#pragma mark UIScrollViewDelegate

/* */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.draggingStartDate = [self firstVisibleDate];
}

/* */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSDate *proposedSelectedDate = [self firstVisibleDate];
    if (proposedSelectedDate == nil) {
        proposedSelectedDate = self.calendarController.startDate;
    }
    
    if ([self.draggingStartDate isEqual:proposedSelectedDate]) {
        // We didn't actually change pages. Don't change the selected date.
        return;
    }
    
    if (self.draggingStartDate && [proposedSelectedDate compare:self.draggingStartDate] == NSOrderedAscending) {
        proposedSelectedDate = [self lastVisibleDate];
    }

    [self updateMonthLabelForStartDate:[self firstVisibleDate] endDate:[self lastVisibleDate]];
    
    [self setSelectedDate:proposedSelectedDate animated:NO];

    if ([self.delegate respondsToSelector:@selector(calendarView:didSelectDate:)]) {
        [self.delegate calendarView:self didSelectDate:proposedSelectedDate];
    }

    self.draggingStartDate = nil;
}

/* */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self updateMonthLabelForStartDate:[self firstVisibleDate] endDate:[self lastVisibleDate]];
}

@end
