//
//  MapTile.m
//  MG
//
//  Created by zak on 22/01/16.
//  Copyright © 2016 zak. All rights reserved.
//

#import "MapTile.h"
#import <Foundation/Foundation.h>
#import <TitaniumKit/TiApp.h>
#import <TitaniumKit/TiBase.h>
#import <UIKit/UIKit.h>

@interface MBTileOverlay ()

@end

@implementation MBTileOverlay {
  UIImage *overlayImg;
}

- (id)init
{
  return [super init];
}

- (void)setOverlayImage:(UIImage *)overlayImage
{
  overlayImg = overlayImage;
}

- (NSData *)blankData
{
  CGRect rect = CGRectMake(0.0f, 0.0f, 256.0f, 256.0f);
  UIGraphicsBeginImageContext(rect.size);
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetFillColorWithColor(context, [[UIColor darkGrayColor] CGColor]);
  CGContextFillRect(context, rect);

  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();

  NSData *blank_data = UIImageJPEGRepresentation(image, 0.5);
  return blank_data;
}

- (void)loadTileAtPath:(MKTileOverlayPath)path result:(void (^)(NSData *, NSError *))result
{

  NSData *overlayData = [[NSData alloc] init];

  if (overlayImg != nil) {
    overlayData = UIImageJPEGRepresentation(overlayImg, 0.5);
  }

  result(overlayData, nil);
}

@end
