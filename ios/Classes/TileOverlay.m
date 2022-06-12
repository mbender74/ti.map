//
//  TileMap
//
//  Created by Juan Suárez on 4/05/16.
//  Copyright © 2016 Juan Suárez. All rights reserved.
//

#import "TileOverlay.h"

@interface ImageTile (FileInternal)
- (id)initWithFrame:(MKMapRect)f path:(NSString *)p;
@end

@implementation ImageTile

@synthesize frame, imagePath;

- (id)initWithFrame:(MKMapRect)f path:(NSString *)p
{
  if (self = [super init]) {
    imagePath = [p copy];
    frame = f;
  }
  return self;
}
@end

@implementation TileOverlay

- (id)initWithTileDirectory:(NSString *)tileDirectory fileExtension:(NSString *)extension tileSize:(CGFloat)size
{
  if (self = [super init]) {
    pathToTiles = [tileDirectory copy];
    tileExtension = [extension copy];
    tileSize = size;

    NSFileManager *fileman = [NSFileManager defaultManager];
    NSDirectoryEnumerator *e = [fileman enumeratorAtPath:pathToTiles];

    NSString *path = nil;
    NSMutableSet *pathSet = [[NSMutableSet alloc] init];
    NSInteger minZ = INT_MAX;
    while (path = [e nextObject]) {

      if (NSOrderedSame == [[path pathExtension] caseInsensitiveCompare:tileExtension]) {
        NSArray *components = [[path stringByDeletingPathExtension] pathComponents];

        if ([components count] == 3) {
          NSInteger z = [[components objectAtIndex:0] integerValue];
          NSInteger x = [[components objectAtIndex:1] integerValue];
          NSInteger y = [[components objectAtIndex:2] integerValue];

          NSString *tileKey = [[NSString alloc] initWithFormat:@"%ld/%ld/%ld", (long)z, (long)x, (long)y];

          [pathSet addObject:tileKey];

          if (z < minZ)
            minZ = z;
        }
      }
    }

    if ([pathSet count] == 0) {
      NSLog(@"[WARN] Could not locate any tiles at %@", tileDirectory);
      return nil;
    }

    // find bounds of base level of tiles to determine boundingMapRect
    NSInteger minX = INT_MAX;
    NSInteger minY = INT_MAX;
    NSInteger maxX = 0;
    NSInteger maxY = 0;
    for (NSString *tileKey in pathSet) {
      NSArray *components = [tileKey pathComponents];
      NSInteger z = [[components objectAtIndex:0] integerValue];
      NSInteger x = [[components objectAtIndex:1] integerValue];
      NSInteger y = [[components objectAtIndex:2] integerValue];
      if (z == minZ) {
        minX = MIN(minX, x);
        minY = MIN(minY, y);
        maxX = MAX(maxX, x);
        maxY = MAX(maxY, y);
      }
    }

    NSInteger tilesAtZ = pow(2, minZ);
    double sizeAtZ = tilesAtZ * tileSize;
    double zoomScaleAtMinZ = sizeAtZ / MKMapSizeWorld.width;

    // gdal2tiles convention is that the 0th tile in the y direction
    // is at the bottom. MKMapPoint convention is that the 0th point
    // is in the upper left.  So need to flip y to correctly address
    // the tile path.
    // NSInteger flippedMinY = labs(minY + 1 - tilesAtZ);
    // NSInteger flippedMaxY = labs(maxY + 1 - tilesAtZ);

    double x0 = (minX * tileSize) / zoomScaleAtMinZ;
    double x1 = ((maxX + 1) * tileSize) / zoomScaleAtMinZ;
    double y0 = (minY * tileSize) / zoomScaleAtMinZ;
    double y1 = ((maxY + 1) * tileSize) / zoomScaleAtMinZ;

    boundingMapRect = MKMapRectMake(x0, y0, x1 - x0, y1 - y0);
    tilePaths = pathSet;
  }
  return self;
}

- (NSInteger)zoomScaleToZoomLevel:(MKZoomScale)scale
{
  double numTilesAt1_0 = MKMapSizeWorld.width / tileSize;
  NSInteger zoomLevelAt1_0 = log2(numTilesAt1_0); // add 1 because the convention skips a virtual level with 1 tile.
  NSInteger zoomLevel = MAX(0, zoomLevelAt1_0 + floor(log2f(scale) + 0.5));
  return zoomLevel;
}

- (CLLocationCoordinate2D)coordinate
{
  return MKCoordinateForMapPoint(MKMapPointMake(MKMapRectGetMidX(boundingMapRect),
      MKMapRectGetMidY(boundingMapRect)));
}

- (MKMapRect)boundingMapRect
{
  return boundingMapRect;
}

// Convert an MKZoomScale to a zoom level where level 0 contains 4 256px square tiles,
- (NSArray *)tilesInMapRect:(MKMapRect)rect zoomScale:(MKZoomScale)scale
{
  NSInteger z = [self zoomScaleToZoomLevel:scale];

  // Number of tiles wide or high (but not wide * high)
  // NSInteger tilesAtZ = pow(2, z);

  NSInteger minX = floor((MKMapRectGetMinX(rect) * scale) / tileSize);
  NSInteger maxX = floor((MKMapRectGetMaxX(rect) * scale) / tileSize);
  NSInteger minY = floor((MKMapRectGetMinY(rect) * scale) / tileSize);
  NSInteger maxY = floor((MKMapRectGetMaxY(rect) * scale) / tileSize);

  NSMutableArray *tiles = nil;

  for (NSInteger x = minX; x <= maxX; x++) {
    for (NSInteger y = minY; y <= maxY; y++) {
      // As in initWithTilePath, need to flip y index to match the gdal2tiles.py convention.
      // NSInteger flippedY = labs(y + 1 - tilesAtZ);

      NSString *finalPath = [NSString stringWithFormat:@"/%ld/%ld/%ld", (long)z, (long)x, (long)y];

      NSString *finalPathComplete = [[[pathToTiles stringByAppendingString:finalPath] stringByAppendingString:@"."] stringByAppendingString:tileExtension];

      NSString *tileKey = [[NSString alloc] initWithFormat:@"%ld/%ld/%ld", (long)z, (long)x, (long)y]; /* Not in use flippedY */
      if ([tilePaths containsObject:tileKey]) {
        if (!tiles) {
          tiles = [NSMutableArray array];
        }

        MKMapRect frame = MKMapRectMake((double)(x * tileSize) / scale,
            (double)(y * tileSize) / scale,
            tileSize / scale,
            tileSize / scale);

        ImageTile *tile = [[ImageTile alloc] initWithFrame:frame path:finalPathComplete];
        [tiles addObject:tile];
      }
    }
  }

  return tiles;
}

@end
