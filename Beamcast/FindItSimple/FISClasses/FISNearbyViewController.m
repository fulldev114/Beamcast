//
//  FISNearbyViewController.m
//  FindItSimple
//
//  Created by Jain R on 3/19/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import "FISNearbyViewController.h"
#import "FISPhotoAnnotation.h"
#import "FISPhotoAnnotationView.h"
#import "FISBeaconAnnotation.h"
#import "FISBeaconAnnotationView.h"
#import "FISBusinessDetailViewController.h"

@interface FISNearbyViewController ()

@end

@implementation FISNearbyViewController
@synthesize myLocation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [locationManager startUpdatingLocation];
    [self.popupTable startMonitoring];

    if ([FISAppDirectory isNeedToRefreshWith:@"nearbyVC"]) {
        [self reload];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [locationManager stopUpdatingLocation];
    [self.popupTable stopMonitoring];
}

-(void) reload
{
    if (_isReloading) {
        return;
    }
    [FISAppDirectory setNeedToRefresh:NO key:@"nearbyVC"];
    _isReloading = YES;
//    [self.mapView showsUserLocation];
    [self.mapView removeAnnotations:self.beaconAnnotations];
    [self updateBeaconData];
    [self addAnnotationsForMe:myLocation];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.specialCategories) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    }

    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_navigation_refresh"] style:UIBarButtonItemStylePlain target:self action:@selector(refresButtonClicked)] autorelease];
    _isReloading = NO;

    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [locationManager startUpdatingLocation];
    
    self.popupTable.delegate = self.popupTable;
    self.popupTable.dataSource = self.popupTable;
    
    myLocation = locationManager.location.coordinate;
    [FISAppDirectory setNeedToRefresh:NO key:@"nearbyVC"];
    
    [self reload];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterForeground) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)applicationEnterBackground {
    [self.popupTable stopMonitoring];
}

- (void)applicationEnterForeground {
    [self.popupTable startMonitoring];
}

- (void)refresButtonClicked {
    [self reload];
    _isGotoLocationLocked = NO;
    [self gotoLocation];
}

#pragma update current location
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    NSLog(@"%d %f %f", mapView.showsUserLocation, mapView.userLocation.coordinate.latitude, mapView.userLocation.coordinate.longitude);
    myLocation = mapView.userLocation.coordinate;
    [self gotoLocation];
    [self addAnnotationsForMe:myLocation];
}
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    //NSLog(error);
}

#pragma Get Meter
-(double) getDistanceMetresBetweenLocationCoordinates:                                                   (CLLocationCoordinate2D)coord1 coord2:(CLLocationCoordinate2D)coord2
{
    CLLocation* location1 = [[CLLocation alloc] initWithLatitude: coord1.latitude longitude: coord1.longitude];
    CLLocation* location2 = [[CLLocation alloc] initWithLatitude: coord2.latitude longitude: coord2.longitude];
    
    double dist = [location1 distanceFromLocation: location2];
    
    NSLog(@"Distance - %f", dist);
    
    return dist;
}


-(BOOL) isNear: (CLLocationCoordinate2D)coord1
{
#define NEAR_DISTANCE 3000.0 // 3 Km
    return YES;
    return [self getDistanceMetresBetweenLocationCoordinates:coord1 coord2:myLocation] <= NEAR_DISTANCE ? YES : NO;
}


#pragma Update Beacon Data
-(void) updateBeaconData
{
    [[FISAppLocker sharedLocker] lockApp];

    [FISWebService sendAsynchronousCommand:ACTION_GET_BEACON_ALL parameters:@{@"categories": (self.specialCategories?self.specialCategories:[FISAppDirectory getFavorites]), @"cities":[FISAppDirectory getCities]} completionHandler:^(NSData *response, NSError *error) {
        NSLog(@"error:%@\n\nresponse:\n%@", error, response);
        if (error!=nil) {
            UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] autorelease];
            [alert show];
        }
        else {
            self.arrBeaconData = [NSMutableArray arrayWithArray:(NSArray*)response];
            [self addAnnotaionsForBeacons];
        }
        _isReloading = NO;
        //[self.header endRefreshing];
        [[FISAppLocker sharedLocker] unlockApp];
    }];
}

#pragma Add My Location Annotation
-(void) addAnnotationsForMe:(CLLocationCoordinate2D) location
{
    [self.mapView removeAnnotation:self.photoAnnotation];
    self.photoAnnotation = [[[FISPhotoAnnotation alloc] initWithLocation:location] autorelease];
    [self.mapView addAnnotation:self.photoAnnotation];
}

#pragma Add Annotations
- (void) addAnnotaionsForBeacons
{
    self.beaconAnnotations = [NSMutableArray array];
        if ([self.arrBeaconData count] <= 0) {
            return;
        }
        
        for (int i = 0; i < [self.arrBeaconData count]; i ++) {
            NSMutableDictionary* beacon = [NSMutableDictionary dictionaryWithDictionary:[self.arrBeaconData objectAtIndex:i]];
            
            if (beacon) {
                CLLocationCoordinate2D theCoordinate;
                
                theCoordinate.latitude = [[beacon objectForKey:@"latitude"] doubleValue];
                theCoordinate.longitude = [[beacon objectForKey:@"longitude"] doubleValue];
                
                if (![self isNear:theCoordinate]) {
                    continue;
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    FISBeaconAnnotation* annotation;
                annotation = [[[FISBeaconAnnotation alloc] initWithLocation:theCoordinate] autorelease];
                
                NSString * title = [beacon objectForKey:@"simple_title"];
                if (title)
                    annotation.title = title;
                else
                    annotation.title = @"Unknown";
                
                NSString * path = [FISAppDirectory stringByAddingPercentEscapeUsingUTF8Encoding:[beacon objectForKey:@"picture"]];
                
                if ([path isKindOfClass:[NSString class]]) {
                    NSURL * url = [NSURL URLWithString:path];
                    NSData *data = [NSData dataWithContentsOfURL:url];
                    UIImage *img = [[[UIImage alloc] initWithData:data] autorelease];
                    annotation.image = img;
                }
                
                annotation.nBeaconID = [[beacon objectForKey:@"id"] integerValue];
                annotation.nBussID = [[beacon objectForKey:@"bus_id"] integerValue];
                annotation.nCategoryID = [[beacon objectForKey:@"cat_id"] integerValue]-1; // server starts from 1 - based
                
                [self.mapView addAnnotation:annotation];
                    [self.beaconAnnotations addObject:annotation];
                });
                
            }
        }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma MapViewController
- (void)gotoLocation
{
    if (_isGotoLocationLocked) {
        return;
    }
    _isGotoLocationLocked = YES;
    
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = myLocation.latitude;
    newRegion.center.longitude = myLocation.longitude;
    newRegion.span.latitudeDelta = 0.01;
    newRegion.span.longitudeDelta = 0.01;
    
    [self.mapView setRegion:newRegion animated:YES];
}


#pragma mark - MKMapViewDelegate
- (MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[FISPhotoAnnotation class]]) {
        FISPhotoAnnotationView* pinView = (FISPhotoAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"FISPhotoAnnotationView"];
        if (!pinView) {
            pinView = [[[FISPhotoAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"FISPhotoAnnotationView"] autorelease];
        }

        pinView.canShowCallout = YES;
        UIImage* photo = [FISAppDirectory getPhoto];
        if (photo==nil) {
            photo = [UIImage imageNamed:@"menu_avatar_unknown"];
        }
        pinView.photoView.image = photo;
        
        UIImageView* photov = [[[UIImageView alloc] initWithImage:pinView.photoView.image] autorelease];
        photov.contentMode = UIViewContentModeScaleAspectFill;
        photov.bounds = CGRectMake(0, 0, 36, 36);
        pinView.leftCalloutAccessoryView = photov;
        
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
        [rightButton addTarget:self
         action:@selector(photoAnnotationRightButtonClicked:)
         forControlEvents:UIControlEventTouchUpInside];
        pinView.rightCalloutAccessoryView = rightButton;
        pinView.annotation = annotation;
        
        return pinView;
    }
    else if ([annotation isKindOfClass:[FISBeaconAnnotation class]]) {
        FISBeaconAnnotationView* pinView = (FISBeaconAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"FISBeaconAnnotationView"];
        if (!pinView) {
            pinView = [[[FISBeaconAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"FISBeaconAnnotationView"] autorelease];
        }

        pinView.canShowCallout = YES;
        
        NSInteger categoryId = ((FISBeaconAnnotation*)annotation).nCategoryID;
        UIImage* image = nil;
        image = [UIImage imageNamed:[NSString stringWithFormat:@"map_annotationview_beacon_%ld", (long)categoryId+1-FISCategoryBaseIndex_V3_0]];
        
        if (image) {
            pinView.image = image;
        }
        pinView.frame = CGRectMake(0, 0, 46, 72);
        
        UIImageView* dealImageView = [[[UIImageView alloc] initWithImage:((FISBeaconAnnotation*)annotation).image] autorelease];
        dealImageView.contentMode = FISImageViewMode;
        dealImageView.bounds = CGRectMake(0, 0, 60, 36);
        dealImageView.clipsToBounds = YES;
        pinView.leftCalloutAccessoryView = dealImageView;
        
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
        rightButton.tag = ((FISBeaconAnnotation*)annotation).nBussID;
        [rightButton addTarget:self
                        action:@selector(annotationRightButtonClicked:)
              forControlEvents:UIControlEventTouchUpInside];
        pinView.rightCalloutAccessoryView = rightButton;
        pinView.annotation = annotation;
        
        return pinView;
    }
    
    return nil;
}

- (void)annotationRightButtonClicked:(UIButton *)sender
{
    [[FISAppLocker sharedLocker] lockApp];

    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
//    [parameters setObject:[FISAppDirectory getToken] forKey:@"token"];
    [parameters setObject:[NSString stringWithFormat:@"%ld", (long)sender.tag] forKey:@"id"];
    
    [FISWebService sendAsynchronousCommand:ACTION_GET_BUSINESS parameters:parameters completionHandler:^(NSData *response, NSError *error) {
        NSLog(@"error:%@\n\nresponse:\n%@", error, response);
        if (error!=nil) {
            UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] autorelease];
            [alert show];
        }
        else {
            FISBusinessDetailViewController* businessDetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FISBusinessDetailViewController-568h"];
            
            businessDetailViewController.info = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *) response];
            businessDetailViewController.nBussinessID = sender.tag;
            [self.navigationController pushViewController:businessDetailViewController animated:YES];
        }

        [[FISAppLocker sharedLocker] unlockApp];
    }];
}

- (void)photoAnnotationRightButtonClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(photoAnnotationRightButtonClicked)]) {
        [self.delegate photoAnnotationRightButtonClicked];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    [_mapView release];
    [_popupTable release];
    self.photoAnnotation = nil;
    self.specialCategories = nil;
    [super dealloc];
}
@end
