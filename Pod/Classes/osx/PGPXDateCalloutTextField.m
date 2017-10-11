//
//  PGPXDateCalloutTextField.m
//  Pods
//
//  Created by Paul Pilone on 3/5/16.
//
//

#import "PGPXDateCalloutTextField.h"

@implementation PGPXDateCalloutTextField

/* */
- (instancetype)initWithCoder:(NSCoder *)coder {
  self = [super initWithCoder:coder];
  if (self) {
    self.alignment = NSTextAlignmentCenter;
    self.bezeled = NO;
    self.drawsBackground = NO;
    self.editable = NO;
    
    _cornerRadius = 4.f;
    _fillColor = [NSColor blackColor];
  }
  
  return self;
}

/* */
- (instancetype)init {
  return [self initWithFrame:NSZeroRect];
}

/* */
- (instancetype)initWithFrame:(NSRect)frameRect {
  self = [super initWithFrame:frameRect];
  if (self) {
    self.alignment = NSTextAlignmentCenter;
    self.bezeled = NO;
    self.drawsBackground = NO;
    self.editable = NO;

    _cornerRadius = 4.f;
    _fillColor = [NSColor blackColor];
  }
  
  return self;
}

/* */
- (void)setFillColor:(NSColor *)fillColor {
    _fillColor = fillColor;
    
    [self setNeedsDisplay];
}

/* */
- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    CGContextRef ctx = [NSGraphicsContext currentContext].CGContext;
    CGContextSaveGState(ctx);
    
    // Drawing code here.
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:self.bounds xRadius:self.cornerRadius yRadius:self.cornerRadius];
    [self.fillColor setFill];
    [path fill];
    
    CGContextRestoreGState(ctx);
    
    [super drawRect:dirtyRect];
}

@end
