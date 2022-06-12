//
//  ViewController.h
//  HG
//
//  Created by zak on 13/07/16.
//  Copyright © 2016 zak. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>

@interface MBTilesMapViewController : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

- (void)resetRender;

@end
