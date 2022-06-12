//
//  ViewController.m
//  HG
//
//  Created by zak on 13/07/16.
//  Copyright © 2016 zak. All rights reserved.
//

#import "MBTilesMapViewController.h"
#import "MapTile.h"
#include <sqlite3.h>

#define MBTILES_DEBUG NO

@interface TileOverlayRenderer : MKTileOverlayRenderer

@end

@implementation TileOverlayRenderer

- (void)drawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale inContext:(CGContextRef)context
{
  [super drawMapRect:mapRect zoomScale:zoomScale inContext:context];

  if (MBTILES_DEBUG) {
    CGRect rect = [self rectForMapRect:mapRect];
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:arc4random() % 255 / 255. green:arc4random() % 255 / 255. blue:arc4random() % 255 / 255. alpha:0.2].CGColor);
    CGContextFillRect(context, rect);
  }
}

@end

@interface MBTilesMapViewController ()

@end

@implementation MBTilesMapViewController {
  MKTileOverlayRenderer *render;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.

  if ([self getMbtilesPath] != nil) {
    TileOverlay *overlay = [[TileOverlay alloc] init];
    overlay.mbtilesPath = [self getMbtilesPath];
    [overlay openMbtilesData];

    overlay.canReplaceMapContent = YES;
    [self.mapView addOverlay:overlay level:MKOverlayLevelAboveLabels];
    self.mapView.delegate = self;
  }
}

- (void)resetRender
{
  [render reloadData];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id)overlay
{
  if ([overlay isKindOfClass:[MKTileOverlay class]]) {
    render = [[TileOverlayRenderer alloc] initWithTileOverlay:overlay];
    return render;
  }

  return nil;
}

- (NSString *)getMbtilesPath
{
  return @"res/map";
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
