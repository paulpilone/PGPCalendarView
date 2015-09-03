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

@property (nonatomic, strong) PGPCalendarController *calendarController;

@property (nonatomic, strong) UICollectionView *collectionView;

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
- (void)layoutSubviews {
    [super layoutSubviews];

    [self.collectionView reloadData];
    
    if (self.needsFirstLayoutPass) {
        [self selectDateAtIndexPath:[self.calendarController indexPathForDate:self.selectedDate] animated:NO];
        self.needsFirstLayoutPass = NO;
    }
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
    
    if (_selectedDate != selectedDate) {
        _selectedDate = selectedDate;
        
        NSIndexPath *indexPath = [self.calendarController indexPathForDate:_selectedDate];
        if (indexPath && !self.needsFirstLayoutPass) {
            [self selectDateAtIndexPath:indexPath animated:animated];
        }
    }
}

#pragma mark -
#pragma mark Private

/* */
- (void)baseInit {
    _calendarController = [[PGPCalendarController alloc] init];
    _needsFirstLayoutPass = YES;
    _selectedDate = _calendarController.startDate;
    
    PGPCalendarHeaderView *headerView = [[PGPCalendarHeaderView alloc] initWithWeekdaySymbols:self.calendarController.shortWeekdaySymbols];
    headerView.backgroundColor = self.backgroundColor;
    headerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:headerView];

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
    
    NSDictionary *views = NSDictionaryOfVariableBindings(headerView, _collectionView);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[headerView]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_collectionView]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[headerView(18)][_collectionView]|" options:0 metrics:nil views:views]];
    
    NSString *calendarBundlePath = [[NSBundle mainBundle] pathForResource:@"PGPCalendarView" ofType:@"bundle"];
    NSBundle *calendarBundle = [NSBundle bundleWithPath:calendarBundlePath];
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([PGPCalendarViewCell class]) bundle:calendarBundle];
    [_collectionView registerNib:nib forCellWithReuseIdentifier:PGPCalendarViewCellIdentifier];
}

/* */
- (void)selectDateAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated {
    // If paging is enabled, we have to be careful about where we tell the collection view to scroll
    // to. If the cell is in the second displayed week, we have to scroll it to the bottom. Otherwise the
    // next tap on the collection view will scroll the cell out of view.
    UICollectionViewScrollPosition scrollPosition = UICollectionViewScrollPositionTop;
    if (self.collectionView.pagingEnabled && indexPath.row % 14 > 6) {
        // Determining the scroll position here works because we know we're showing 14 cells (2 x 7 grid).
        scrollPosition = UICollectionViewScrollPositionBottom;
    }
    
    [self.collectionView selectItemAtIndexPath:indexPath animated:animated scrollPosition:scrollPosition];
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
    
    NSDate *date = [self.calendarController dateAtIndexPath:indexPath];
    if (date == nil) { // Placeholder cell.
        cell.dateLabel.text = nil;
    } else {
        cell.today = [self.calendarController isToday:date];
        
        NSDateComponents *dateComps = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay)  fromDate:date];
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
    
    if ([self.delegate respondsToSelector:@selector(calendarView:didSelectDate:)]) {
        [self.delegate calendarView:self didSelectDate:date];
    }
}

#pragma mark -
#pragma mark UICollectionViewDelegateFlowLayout

/* */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(CGRectGetWidth(collectionView.bounds) / 7.f, CGRectGetHeight(collectionView.bounds) / 2.f);
}

#pragma mark -
#pragma mark UIScrollViewDelegate

/* */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:self.collectionView.contentOffset];
    if (indexPath) {
        NSDate *date = [self.calendarController dateAtIndexPath:indexPath];
        if (date == nil) {
            date = self.calendarController.startDate;
        }
        
        [self setSelectedDate:date animated:NO];
        
        if ([self.delegate respondsToSelector:@selector(calendarView:didSelectDate:)]) {
            [self.delegate calendarView:self didSelectDate:date];
        }
    }
}

@end
