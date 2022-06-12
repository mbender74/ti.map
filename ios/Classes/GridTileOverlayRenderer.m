//
//  OfflineTileOverlayRenderer.m
//  CustomMap
//
//  Created by Carlo Vigiani on 19/Jan/14.
//  Copyright (c) 2014 viggiosoft. All rights reserved.
//

#import "GridTileOverlayRenderer.h"

@interface GridTileOverlayRenderer ()

@end

@implementation GridTileOverlayRenderer

- (id)initWithOverlay:(GridTileOverlay *)overlay
{
  if (self = [super initWithOverlay:overlay]) {
  }
  return self;
}

- (BOOL)canDrawMapRect:(MKMapRect)mapRect
             zoomScale:(MKZoomScale)zoomScale
{
  // Return YES only if there are some tiles in this mapRect and at this zoomScale.
  GridTileOverlay *tileOverlay = (GridTileOverlay *)self.overlay;
  NSArray *tilesInRect = [tileOverlay tilesInMapRect:mapRect zoomScale:zoomScale];

  NSLog(@"[tilesInRect count] %lu", (unsigned long)[tilesInRect count]);

  return [tilesInRect count] > 0;
}

- (void)drawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale inContext:(CGContextRef)context
{

  GridTileOverlay *tileOverlay = (GridTileOverlay *)self.overlay;

  NSArray *tilesInRect = [tileOverlay tilesInMapRect:mapRect zoomScale:zoomScale];

  // Get the list of tile images from the model object for this mapRect.  The
  // list may be 1 or more images (but not 0 because canDrawMapRect would have
  // returned NO in that case).

  CGContextSetAlpha(context, 1.0);

  for (ImageTile *tile in tilesInRect) {

    NSLog(@"ImageTile %@", tile);
    NSLog(@"ImageTile.imagePath %@", tile.imagePath);

    // For each image tile, draw it in its corresponding MKMapRect frame
    CGRect rect = [self rectForMapRect:tile.frame];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:tile.imagePath];
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, 1 / zoomScale, 1 / zoomScale);
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1, -1);
    CGContextDrawImage(context, CGRectMake(0, 0, image.size.width, image.size.height), [image CGImage]);
    CGContextRestoreGState(context);
  }

  //    NSLog(@"Rendering at (x,y):(%f,%f) with size (w,h):(%f,%f) zoom %f",mapRect.origin.x,mapRect.origin.y,mapRect.size.width,mapRect.size.height,zoomScale);
  //    CGRect rect = [self rectForMapRect:mapRect];
  //    NSLog(@"CGRect: %@",NSStringFromCGRect(rect));
  //
  //    MKTileOverlayPath path;
  //
  //    path.x = mapRect.origin.x*zoomScale/tileOverlay.tileSize.width;
  //    path.y = mapRect.origin.y*zoomScale/tileOverlay.tileSize.width;
  //    path.z = log2(zoomScale)+20;
  //
  //    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
  //    CGContextSetLineWidth(context, 1.0/zoomScale);
  //    CGContextStrokeRect(context, rect);
  //
  //    UIGraphicsPushContext(context);
  //
  //    NSString *finalPath = [NSString stringWithFormat:@"/%ld/%ld/%ld",(long)zoomScale,(long)path.x,(long)path.y];
  //
  //    NSString *finalPathComplete = [[[tileOverlay pathToTiles] stringByAppendingString:finalPath] stringByAppendingString:@".png"];
  //
  //    UIImage *image = [[UIImage alloc] initWithContentsOfFile:finalPathComplete];
  //    [image drawInRect:rect];
  //
  ////    NSString *text = [NSString stringWithFormat:@"X=%ld\nY=%ld\nZ=%ld",(long)path.x,(long)path.y,(long)path.z];
  ////    [text drawInRect:rect withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20.0/zoomScale],
  ////                                           NSForegroundColorAttributeName:[UIColor blackColor]}];
  ////    printf("\n UODATE ");
  //
  //    UIGraphicsPopContext();
}

@end
