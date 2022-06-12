//
//  TileMap
//
//  Created by Juan Suárez on 4/05/16.
//  Copyright © 2016 Juan Suárez. All rights reserved.
//

#import "TileOverlay.h"
#import <MapKit/MapKit.h>
#import <TitaniumKit/TiApp.h>
#import <TitaniumKit/TiBase.h>

@interface TileOverlayView : MKOverlayRenderer {
  CGFloat tileAlpha;
  TiProxy *proxy;
}

@property (nonatomic, assign) CGFloat tileAlpha;

- (void)setProxy:(TiProxy *)tiproxy;
- (id)initWithOverlay:(id<MKOverlay>)overlay;

@end
