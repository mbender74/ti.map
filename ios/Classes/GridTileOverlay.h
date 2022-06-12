//
//  OfflineTileOverlay.h
//  CustomMap
//
//  Created by Carlo Vigiani on 19/Jan/14.
//  Copyright (c) 2014 viggiosoft. All rights reserved.
//
#import <TitaniumKit/TiUtils.h>

#import <MapKit/MapKit.h>
@interface ImageTile : NSObject {
  NSString *imagePath;
  MKMapRect frame;
}

@property (nonatomic, readonly) MKMapRect frame;
@property (nonatomic, readonly) NSString *imagePath;

@end

@interface GridTileOverlay : MKTileOverlay
- (NSArray *)tilesInMapRect:(MKMapRect)rect zoomScale:(MKZoomScale)scale;
- (void)tileDirectory:(NSString *)tileDirectory fileExtension:(NSString *)extension;
- (NSInteger)zoomScaleToZoomLevel:(MKZoomScale)scale;
- (NSString *)pathToTiles;
- (NSString *)tilesExtension;
- (void)setMinimumZ:(NSInteger)minimumZ;
- (void)setMaximumZ:(NSInteger)maximumZ;
@end
