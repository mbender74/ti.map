//
//  MapTile.h
//  MG
//
//  Created by zak on 22/01/16.
//  Copyright © 2016 zak. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>

//==============================================================================================================
// tiles
//==============================================================================================================
@interface MBTileOverlay : MKTileOverlay
- (void)setOverlayImage:(UIImage *)overlayImage;
@end
