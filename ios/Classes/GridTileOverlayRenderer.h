//
//  OfflineTileOverlayRenderer.h
//  CustomMap
//
//  Created by Carlo Vigiani on 19/Jan/14.
//  Copyright (c) 2014 viggiosoft. All rights reserved.
//

#import "GridTileOverlay.h"
#import <MapKit/MapKit.h>

@interface GridTileOverlayRenderer : MKTileOverlayRenderer {
}
- (id)initWithOverlay:(GridTileOverlay *)overlay;

@end
