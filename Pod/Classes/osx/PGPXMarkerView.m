//
//  PGPXMarkerView.m
//  Pods
//
//  Created by Paul Pilone on 3/6/16.
//
//

#import "PGPXMarkerView.h"

@interface PGPXMarkerView ()

@property (nonatomic, strong) NSArray<NSColor *> *markers;

@property (nonatomic) CGSize markerSize;

@end

@implementation PGPXMarkerView

static CGFloat PGPXCalendarMarkerPadding = 2.f;

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _markerSize = CGSizeMake(5.f, 5.f);
    }
    
    return self;
}

- (instancetype)init {
  return [self initWithFrame:NSZeroRect];
}

- (instancetype)initWithFrame:(NSRect)frameRect {
  self = [super initWithFrame:frameRect];
  if (self) {
    _markerSize = CGSizeMake(5.f, 5.f);
  }
  
  return self;
}

/* */
- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    NSInteger numberOfMarkers = MIN([self.markers count], 10);
    for (NSInteger i = 0; i < numberOfMarkers; i++) {
        //CALayer *sublayer = layer.sublayers[i];
        NSColor *marker = self.markers[i];
        
        NSInteger markerPositionInRow = (i % 5);
        NSInteger numberOfSublayersInRow = i >= 5 ? numberOfMarkers - 5 : (numberOfMarkers > 5) ? 5 : numberOfMarkers;
        
        CGFloat totalWidthOfRow = numberOfSublayersInRow * self.markerSize.width + ((numberOfSublayersInRow - 1) * PGPXCalendarMarkerPadding);
        CGFloat rowOriginX = CGRectGetMidX(self.bounds) - (totalWidthOfRow / 2.f);
        
        CGFloat markerOriginX = rowOriginX + (markerPositionInRow * self.markerSize.width) + (markerPositionInRow * PGPXCalendarMarkerPadding);
        
        // -------------------------------
        // Below this line things are good.
        
        CGFloat markerOriginY;
        if (numberOfMarkers > 5) {
            NSInteger coefficient = 5 - i > 0 ? (-1 * self.markerSize.height) - (PGPXCalendarMarkerPadding / 2.f) : (PGPXCalendarMarkerPadding / 2.f);
            markerOriginY = CGRectGetMidY(self.bounds) + coefficient;
        } else {
            markerOriginY = CGRectGetMidY(self.bounds) - (self.markerSize.height / 2.f);
        }
        
//        CGRect frame = sublayer.frame;
//        frame.origin.x = markerOriginX;
//        frame.origin.y = markerOriginY;
//        frame.size.width = self.markerSize.width;
//        frame.size.height = self.markerSize.height;
//        sublayer.frame = frame;
        NSBezierPath *markerPath = [NSBezierPath bezierPathWithOvalInRect:NSMakeRect(markerOriginX, markerOriginY, self.markerSize.width, self.markerSize.height)];
        [marker setFill];
        [markerPath fill];
    }

}

/* */
- (void)setMarkers:(NSArray *)markers {    
    _markers = markers;
    
    [self setNeedsDisplay:YES];
}

@end
