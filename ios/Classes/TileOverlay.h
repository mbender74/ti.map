//
//  TileMap
//
//  Created by Juan Suárez on 4/05/16.
//  Copyright © 2016 Juan Suárez. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface ImageTile : NSObject {
  NSString *imagePath;
  MKMapRect frame;
}

@property (nonatomic, readonly) MKMapRect frame;
@property (nonatomic, readonly) NSString *imagePath;

@end

@interface TileOverlay : NSObject <MKOverlay> {
  NSString *tileBase;
  MKMapRect boundingMapRect;
  NSSet *tilePaths;
  NSString *pathToTiles;
  NSString *tileExtension;
  CGFloat tileSize;
}

// Initialize the TileOverlay with a directory structure containing map tile images.
- (id)initWithTileDirectory:(NSString *)tileDirectory fileExtension:(NSString *)extension tileSize:(CGFloat)size;

// Return an array of ImageTile objects for the given MKMapRect and MKZoomScale
- (NSArray *)tilesInMapRect:(MKMapRect)rect zoomScale:(MKZoomScale)scale;

@end
