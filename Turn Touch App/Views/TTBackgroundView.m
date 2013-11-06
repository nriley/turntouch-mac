//
//  TTBackgroundView.m
//  Turn Touch App
//
//  Created by Samuel Clay on 8/20/13.
//  Copyright (c) 2013 Turn Touch. All rights reserved.
//

#import "TTBackgroundView.h"

#define FILL_OPACITY 1.0f
#define STROKE_OPACITY .5f

#define LINE_THICKNESS 1.0f
#define CORNER_RADIUS 8.0f

#define SEARCH_INSET 10.0f

#pragma mark -

@implementation TTBackgroundView

@synthesize arrowX = _arrowX;
@synthesize modeMenu = _modeMenu;
@synthesize diamondView = _diamondView;

#pragma mark -

- (void)awakeFromNib {
    CGRect modeMenuFrame = self.frame;
    modeMenuFrame.size.height = 36;
    modeMenuFrame.origin.y += ARROW_HEIGHT;
    _modeMenu = [[TTModeMenuViewport alloc] initWithFrame:modeMenuFrame];
    _modeMenu.autoresizingMask = NSViewWidthSizable | NSViewMinXMargin | NSViewMaxXMargin;
    [self addSubview:_modeMenu];
    
    CGRect diamondRect = NSInsetRect(self.frame, 2.0f, 4.0f);
    _diamondView = [[TTDiamondView alloc] initWithFrame:diamondRect];
//    [self addSubview:_diamondView];
}

- (BOOL)isFlipped {
    return YES;
}

- (void)drawRect:(NSRect)dirtyRect {
    NSRect contentRect = NSInsetRect([self bounds], LINE_THICKNESS, LINE_THICKNESS);
    
    [_modeMenu invalidateIntrinsicContentSize];
    NSBezierPath *path = [NSBezierPath bezierPath];
    
    [path moveToPoint:NSMakePoint(_arrowX, NSMinY(contentRect))];
    [path lineToPoint:NSMakePoint(_arrowX + ARROW_WIDTH / 2, NSMinY(contentRect) + ARROW_HEIGHT)];
    [path lineToPoint:NSMakePoint(NSMaxX(contentRect) - CORNER_RADIUS, NSMinY(contentRect) + ARROW_HEIGHT)];
    
    NSPoint topRightCorner = NSMakePoint(NSMaxX(contentRect), NSMinY(contentRect) + ARROW_HEIGHT);
    [path curveToPoint:NSMakePoint(NSMaxX(contentRect), NSMinY(contentRect) + ARROW_HEIGHT + CORNER_RADIUS)
         controlPoint1:topRightCorner controlPoint2:topRightCorner];
    
    [path lineToPoint:NSMakePoint(NSMaxX(contentRect), NSMaxY(contentRect) - CORNER_RADIUS)];
    
    NSPoint bottomRightCorner = NSMakePoint(NSMaxX(contentRect), NSMaxY(contentRect));
    [path curveToPoint:NSMakePoint(NSMaxX(contentRect) - CORNER_RADIUS, NSMaxY(contentRect))
         controlPoint1:bottomRightCorner controlPoint2:bottomRightCorner];
    
    [path lineToPoint:NSMakePoint(NSMinX(contentRect) + CORNER_RADIUS, NSMaxY(contentRect))];
    
    NSPoint bottomLeftCorner = NSMakePoint(NSMinX(contentRect), NSMaxY(contentRect));
    [path curveToPoint:NSMakePoint(NSMinX(contentRect), NSMaxY(contentRect) - CORNER_RADIUS)
         controlPoint1:bottomLeftCorner controlPoint2:bottomLeftCorner];
    
    [path lineToPoint:NSMakePoint(NSMinX(contentRect), NSMinY(contentRect) + ARROW_HEIGHT + CORNER_RADIUS)];
    
    NSPoint topLeftCorner = NSMakePoint(NSMinX(contentRect), NSMinY(contentRect) + ARROW_HEIGHT);
    [path curveToPoint:NSMakePoint(NSMinX(contentRect) + CORNER_RADIUS, NSMinY(contentRect) + ARROW_HEIGHT)
         controlPoint1:topLeftCorner controlPoint2:topLeftCorner];
    
    [path lineToPoint:NSMakePoint(_arrowX - ARROW_WIDTH / 2, NSMinY(contentRect) + ARROW_HEIGHT)];

    [path closePath];
    
    [[NSColor colorWithDeviceWhite:1 alpha:FILL_OPACITY] setFill];
    [path fill];
    
    [NSGraphicsContext saveGraphicsState];
    
    NSBezierPath *clip = [NSBezierPath bezierPathWithRect:[self bounds]];
    [clip appendBezierPath:path];
    [clip addClip];
    
    [path setLineWidth:LINE_THICKNESS * 2];
    [[NSColor whiteColor] setStroke];
    [path stroke];
    
    [NSGraphicsContext restoreGraphicsState];
    
}

#pragma mark -
#pragma mark Public accessors

- (void)setArrowX:(NSInteger)value {
    _arrowX = value;
    [self setNeedsDisplay:YES];
}

@end
