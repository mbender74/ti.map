/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-Present by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "GeoJSONSerialization.h"
#import "MapTile.h"
#import "NSMutableArray+TrimWhiteSpace.h"
#import "NSString+Tokenize.h"
#import "RegionBBoxConverter.h"
#import "TiMKOverlayPathUniversal.h"
#import "TiMapCameraProxy.h"
#import "TileOverlayView.h"
#import "WildcardGestureRecognizer.h"
#import "mkgeometry_additions.h"
#import <MapKit/MapKit.h>
#import <TitaniumKit/TiBase.h>
#import <TitaniumKit/TiUIView.h>

@class TiMapAnnotationProxy;

@protocol TiMapAnnotation
@required
- (NSString *)lastHitName;
@end

@interface TiMapView : TiUIView <MKMapViewDelegate, CLLocationManagerDelegate> {
  MKMapView *map;
  BOOL regionFits;
  BOOL animate;
  BOOL loaded;
  BOOL ignoreClicks;
  BOOL ignoreRegionChanged;
  BOOL forceRender;
  MKCoordinateRegion region;
  NSMutableArray *geoJSONProxies;
  NSMutableArray *polygonProxies;
  NSMutableArray *circleProxies;
  NSMutableArray *polylineProxies;
  NSMutableArray *imageOverlayProxies;
  NSMutableDictionary *clusterAnnotations;
  MKMapRect lastGoodMapRect;
  BOOL manuallyChangingMapRect;
  BOOL maxBoundsSet;
  MKMapRect paddedBoundingMapRect;
  CGFloat zoom;
  CGFloat maxLong;
  CGFloat minLong;
  CGFloat maxLat;
  CGFloat minLat;
  TileOverlay *tileOverlay;
  MKMapCameraZoomRange *zoomRange;
  MKTileOverlayRenderer *tileRender;
  //selected annotation
  MKAnnotationView<TiMapAnnotation> *selectedAnnotation;

  // dictionary for object tracking and association
  CFMutableDictionaryRef mapObjects2View; // MKOverlay Object -> MKOverlay Object's renderer

  // Location manager needed for iOS 8 permissions
  CLLocationManager *locationManager;
  KrollCallback *cameraAnimationCallback;
}

@property (nonatomic, readonly) CLLocationDegrees longitudeDelta;
@property (nonatomic, readonly) CLLocationDegrees latitudeDelta;
@property (nonatomic, readonly) NSArray *customAnnotations;
@property (assign, nonatomic) BOOL isMaxed;
@property (assign, nonatomic) MKCoordinateSpan lastDelta;
@property (assign, nonatomic) UIColor *mapColor;
@property (nonatomic, assign) BOOL constraintMap;

#pragma mark Private APIs

- (TiMapAnnotationProxy *)annotationFromArg:(id)arg;
- (NSArray *)annotationsFromArgs:(id)value;
- (NSArray *)annotationsFromGeoJSON:(id)value;
- (MKMapView *)map;
- (TiMapCameraProxy *)camera;
- (void)resetRender;
- (void)setZoomLevel:(id)args animated:(BOOL)animated;

#pragma mark Public APIs

- (void)animateCamera:(id)args;
- (void)showAnnotations:(id)args;
- (void)showAllAnnotations:(id)value;
- (void)addAnnotation:(id)args;
- (void)addAnnotations:(id)args;
- (void)setAnnotations_:(id)value;
- (void)removeAnnotation:(id)args;
- (void)removeAnnotations:(id)args;
- (void)removeAllAnnotations:(id)args;
- (void)selectAnnotation:(id)args;
- (void)deselectAnnotation:(id)args;
- (void)zoom:(id)args;
- (void)addRoute:(id)args;
- (void)removeRoute:(id)args;
- (void)addPolygon:(id)args;
- (void)addPolygons:(id)args;
- (void)removePolygon:(id)args;
- (void)removePolygon:(id)args remove:(BOOL)r;
- (void)removeAllPolygons;
- (void)addCircle:(id)args;
- (void)addCircles:(id)args;
- (void)removeCircle:(id)args;
- (void)removeCircle:(id)args remove:(BOOL)r;
- (void)removeAllCircles;
- (void)addPolyline:(id)args;
- (void)addPolylines:(id)args;
- (void)removePolyline:(id)args;
- (void)removePolyline:(id)args remove:(BOOL)r;
- (void)removeAllPolylines;
- (void)addImageOverlay:(id)arg;
- (void)addImageOverlays:(id)args;
- (void)removeImageOverlay:(id)arg;
- (void)removeAllImageOverlays;
- (NSInteger)zoomLevel;
- (void)firePinChangeDragState:(MKAnnotationView *)pinview newState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState;
- (void)setClusterAnnotation:(TiMapAnnotationProxy *)annotation forMembers:(NSArray<TiMapAnnotationProxy *> *)members;
- (void)animateAnnotation:(TiMapAnnotationProxy *)newAnnotation withLocation:(CLLocationCoordinate2D)newLocation;
- (void)setLocation:(id)location;
- (NSNumber *)containsCoordinate:(id)args;
- (CLLocationCoordinate2D)regionCenter;

#pragma mark Utils
- (void)addOverlay:(MKPolyline *)polyline level:(MKOverlayLevel)level;

#pragma mark Framework
- (void)refreshAnnotation:(TiMapAnnotationProxy *)proxy readd:(BOOL)yn;
- (void)fireClickEvent:(MKAnnotationView *)pinview source:(NSString *)source deselected:(BOOL)deselected;
- (void)refreshCoordinateChanges:(TiMapAnnotationProxy *)proxy afterRemove:(void (^)(void))callBack;

@end
