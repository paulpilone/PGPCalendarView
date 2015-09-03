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
        
        CGFloat xOffset = CGRectGetMidX(layer.bounds) - (self.markerSize.width * (i - 1));
        if (numberOfSublayers % 2 == 1) {
            xOffset = xOffset - (.5  * self.markerSize.width);
        }

        CGRect frame = sublayer.frame;
        frame.origin.x = xOffset - (((i - (numberOfSublayers - (i + 1))) * .5) * PGPCalendarMarkerPadding);
        frame.origin.y = CGRectGetMidY(layer.bounds) - (self.markerSize.height / 2.f);
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
    
    for (id marker in markers) {
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
