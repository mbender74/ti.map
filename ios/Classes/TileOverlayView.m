//
//  TileMap
//
//  Created by Juan Suárez on 4/05/16.
//  Copyright © 2016 Juan Suárez. All rights reserved.
//

#import "TileOverlayView.h"

@implementation TileOverlayView

@synthesize tileAlpha;

- (id)initWithOverlay:(id<MKOverlay>)overlay
{
  if (self = [super initWithOverlay:overlay]) {
    tileAlpha = 1.0;
  }
  return self;
}

- (void)setProxy:(TiProxy *)tiproxy
{
  proxy = tiproxy;
}

- (BOOL)canDrawMapRect:(MKMapRect)mapRect
             zoomScale:(MKZoomScale)zoomScale
{
  // Return YES only if there are some tiles in this mapRect and at this zoomScale.
  TileOverlay *tileOverlay = (TileOverlay *)self.overlay;
  NSArray *tilesInRect = [tileOverlay tilesInMapRect:mapRect zoomScale:zoomScale];
  return [tilesInRect count] > 0;
}

- (void)drawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale inContext:(CGContextRef)context
{
  TileOverlay *tileOverlay = (TileOverlay *)self.overlay;

  // Get the list of tile images from the model object for this mapRect.  The
  // list may be 1 or more images (but not 0 because canDrawMapRect would have
  // returned NO in that case).
  NSArray *tilesInRect = [tileOverlay tilesInMapRect:mapRect zoomScale:zoomScale];

  CGContextSetAlpha(context, tileAlpha);

  for (ImageTile *tile in tilesInRect) {
    // For each image tile, draw it in its corresponding MKMapRect frame
    CGRect rect = [self rectForMapRect:tile.frame];

    UIImage *image = [TiUtils image:tile.imagePath proxy:proxy];
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, 1 / zoomScale, 1 / zoomScale);
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1, -1);
    CGContextDrawImage(context, CGRectMake(0, 0, image.size.width, image.size.height), [image CGImage]);
    CGContextRestoreGState(context);
  }
}

@end
