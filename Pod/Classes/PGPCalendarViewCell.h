//
//  PGPCalendarViewCell.h
//  Pods
//
//  Created by Paul Pilone on 8/30/15.
//
//

#import <UIKit/UIKit.h>

static NSString * const PGPCalendarViewCellIdentifier = @"PGPCalendarViewCellIdentifier";

@interface PGPCalendarViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end
