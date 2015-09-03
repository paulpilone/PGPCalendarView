//
//  PGPCalendarMarkerContainerView.m
//  Pods
//
//  Created by Paul Pilone on 9/2/15.
//
//

#import "PGPCalendarMarkerContainerView.h"

@interface PGPCalendarMarkerContainerView ()
@property (nonatomic) CGSize markerSize;
@end

@implementation PGPCalendarMarkerContainerView

static CGFloat PGPCalendarMarkerPadding = 2.f;

/* */
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _markerSize = CGSizeMake(5.f, 5.f);
    }
    
    return self;
}

/* */
- (void)layoutSublayersOfLayer:(CALayer *)layer {
    NSInteger numberOfSublayers = [layer.sublayers count];
    for (NSInteger i = 0; i < numberOfSublayers; i++) {
        CALayer *sublayer = layer.sublayers[i];
        
        NSInteger markerPositionInRow = (i % 5);
        NSInteger numberOfSublayersInRow = i >= 5 ? numberOfSublayers - 5 : (numberOfSublayers > 5) ? 5 : numberOfSublayers;
        
        CGFloat totalWidthOfRow = numberOfSublayersInRow * self.markerSize.width + ((numberOfSublayersInRow - 1) * PGPCalendarMarkerPadding);
        CGFloat rowOriginX = CGRectGetMidX(layer.bounds) - (totalWidthOfRow / 2.f);
        
        CGFloat markerOriginX = rowOriginX + (markerPositionInRow * self.markerSize.width) + (markerPositionInRow * PGPCalendarMarkerPadding);
        
        // -------------------------------
        // Below this line things are good.
        
        CGFloat markerOriginY;
        if (numberOfSublayers > 5) {
            NSInteger coefficient = 5 - i > 0 ? (-1 * self.markerSize.height) - (PGPCalendarMarkerPadding / 2.f) : (PGPCalendarMarkerPadding / 2.f);
            markerOriginY = CGRectGetMidY(layer.bounds) + coefficient;
        } else {
            markerOriginY = CGRectGetMidY(layer.bounds) - (self.markerSize.height / 2.f);
        }
    
        CGRect frame = sublayer.frame;
        frame.origin.x = markerOriginX;
        frame.origin.y = markerOriginY;
        frame.size.width = self.markerSize.width;
        frame.size.height = self.markerSize.height;
        sublayer.frame = frame;
    }
    
    [super layoutSublayersOfLayer:layer];
}

/* */
- (void)removeMarkers {
    NSArray *shapeLayers = [self.layer.sublayers copy];
    for (CALayer *sublayer in shapeLayers) {
        [sublayer removeFromSuperlayer];
    }
}

/* */
- (void)setMarkers:(NSArray *)markers {
    [self removeMarkers];
    
    for (NSInteger i = 0; (i < [markers count] && i < 10); i++) {
        id marker = markers[i];
        
        // TODO: Maybe make this a class that conforms to a protocol that
        // requires a property 'color'.
        if (![marker isKindOfClass:[UIColor class]]) {
            continue;
        }
        
        UIBezierPath *ovalPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0.f, 0.f, self.markerSize.width, self.markerSize.height)];
        
        CAShapeLayer *circleLayer = [CAShapeLayer layer];
        circleLayer.fillColor = ((UIColor *)marker).CGColor;
        circleLayer.path = ovalPath.CGPath;
        [self.layer addSublayer:circleLayer];
    }
}

@end
