//
//  FISNearbyViewController.h
//  FindItSimple
//
//  Created by Jain R on 3/19/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FISBaseViewController.h"
#import "FISPopupDealsView.h"
#import "FISPhotoAnnotation.h"
#import "FISBeaconAnnotation.h"

@protocol FISNearbyViewControllerDelegate <NSObject>

- (void)photoAnnotationRightButtonClicked;

@end

@interface FISNearbyViewController : FISBaseViewController <MKMapViewDelegate,CLLocationManagerDelegate>
{
    CLLocationManager * locationManager;
    BOOL _isReloading;
    BOOL _isGotoLocationLocked;
}

@property (assign, nonatomic) CLLocationCoordinate2D myLocation;
@property (retain, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic, retain) NSMutableArray* arrBeaconData;
@property (retain, nonatomic) IBOutlet FISPopupDealsView *popupTable;

@property (nonatomic, assign) id<FISNearbyViewControllerDelegate> delegate;

@property (nonatomic, retain) FISPhotoAnnotation* photoAnnotation;
@property (nonatomic, retain) NSMutableArray* beaconAnnotations;

@property (nonatomic, retain) NSArray* specialCategories;

@end
