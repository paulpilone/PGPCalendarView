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

@interface PGPCalendarView () < UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout >

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
}

#pragma mark -
#pragma mark Private

/* */
- (void)baseInit {
    _calendarController = [[PGPCalendarController alloc] init];
    
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
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_collectionView);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_collectionView]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_collectionView]|" options:0 metrics:nil views:views]];
    
    NSString *calendarBundlePath = [[NSBundle mainBundle] pathForResource:@"PGPCalendarView" ofType:@"bundle"];
    NSBundle *calendarBundle = [NSBundle bundleWithPath:calendarBundlePath];
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([PGPCalendarViewCell class]) bundle:calendarBundle];
    [_collectionView registerNib:nib forCellWithReuseIdentifier:PGPCalendarViewCellIdentifier];
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
    //NSLog(@"Date for indexPath %@ is %@", indexPath, date);
    
    if (date == nil) { // Placeholder cell.
        cell.textLabel.text = nil;
    } else {
        NSDateComponents *dateComps = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay)  fromDate:date];
        cell.textLabel.text = [NSString stringWithFormat:@"%ld", (long) [dateComps day]];
    }
    
    return cell;
}

#pragma mark -
#pragma mark UICollectionViewDelegate

/* */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark -
#pragma mark UICollectionViewDelegateFlowLayout

/* */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(CGRectGetWidth(self.bounds) / 7.f, CGRectGetHeight(self.bounds) / 2.f);
}

@end
