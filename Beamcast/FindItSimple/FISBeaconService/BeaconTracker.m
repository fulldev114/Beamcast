//
//  BeaconTracker.m
//  iBeaconTracker
//
//  Created by Jain R on 10/2/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import "BeaconTracker.h"
#import "CLBeacon+Addition.h"
#import "BackgroundTaskManager.h"

@interface BeaconTracker ()

@property (nonatomic, retain) NSTimer* checkTimer;

@end

@implementation BeaconTracker {
    CLLocationManager*  _locationManager;
    CLBeaconRegion*     _beaconRegion;
}

+ (BeaconTracker *)sharedBeaconTracker {
	static BeaconTracker *_beaconTracker;
	
	@synchronized(self) {
		if (_beaconTracker == nil) {
			_beaconTracker = [[BeaconTracker alloc] init];
		}
	}
	return _beaconTracker;
}

- (id)init {
	if (self==[super init]) {

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];

	}
	return self;
}

- (void)dealloc {
    if (_locationManager) {
        [_locationManager release];
        _locationManager = nil;
    }
    
    if (_beaconRegion) {
        [_beaconRegion release];
        _beaconRegion = nil;
    }
    
    self.detectedBeacons = nil;

    self.blackBeacons = nil;
    
    if (self.checkTimer) {
        [self.checkTimer invalidate];
        self.checkTimer = nil;
    }
    
    [super dealloc];
}

- (void)startBeaconTrackingWith:(NSUUID *)beaconProximityUUID regionID:(NSString *)beaconRegionID {
    _locationManager = [[CLLocationManager alloc] init];

    // request permission to get location for iOS 8
    if([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [_locationManager requestAlwaysAuthorization];
    }

    _locationManager.delegate = self;
    _locationManager.pausesLocationUpdatesAutomatically = NO;
    _beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:beaconProximityUUID identifier:beaconRegionID];
    _beaconRegion.notifyEntryStateOnDisplay = YES;
    [_locationManager startMonitoringForRegion:_beaconRegion];
    [_locationManager requestStateForRegion:_beaconRegion];
//    [self startBeaconRanging];
}

- (void)stopBeaconTracking {
    [self stopBeaconTracking];
    [_locationManager stopMonitoringForRegion:_beaconRegion];
    [_locationManager release];
    _locationManager = nil;
    [_beaconRegion release];
    _beaconRegion = nil;
}

- (void)startBeaconRanging {
    [_locationManager startRangingBeaconsInRegion:_beaconRegion];
    [_locationManager startUpdatingLocation];
    
    if (self.checkTimer) {
        [self.checkTimer invalidate];
        self.checkTimer = nil;
    }
    self.checkTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(checkNewBeacons) userInfo:nil repeats:YES];
}

- (void)stopBeaconRanging {
    [_locationManager stopRangingBeaconsInRegion:_beaconRegion];
    [_locationManager stopUpdatingLocation];
    if (self.checkTimer) {
        [self.checkTimer invalidate];
        self.checkTimer = nil;
    }
}

-(void)applicationEnterBackground{
    BackgroundTaskManager* bgTaskMgr = [BackgroundTaskManager sharedBackgroundTaskManager];
    [bgTaskMgr beginNewBackgroundTask];
}

- (void)checkNewBeacons {
    
    NSLog(@"didCheckBeacons");
    
    if (self.isForegroundMode == NO) {
        BackgroundTaskManager* bgTaskMgr = [BackgroundTaskManager sharedBackgroundTaskManager];
        [bgTaskMgr beginNewBackgroundTask];
    }

    NSMutableArray* newBeacons = [NSMutableArray array];
    
    for (CLBeacon* detectedBeacon in self.detectedBeacons) {
        
        BOOL isFound = NO;
        for (CLBeacon* blackBeacon in self.blackBeacons) {
            if ([detectedBeacon isEqualToCLBeacon:blackBeacon]) {
                isFound = YES;
                break;
            }
        }
        if (isFound==NO) {
            [newBeacons addObject:[NSArray arrayWithObjects:[NSNumber numberWithInteger:detectedBeacon.major.integerValue], [NSNumber numberWithInteger:detectedBeacon.minor.integerValue], nil]];
        }
    }
    
    self.blackBeacons = self.detectedBeacons;
    
    if ([self.delegate respondsToSelector:@selector(BeaconTracker:didFoundNewBeacons:)]) {
        [self.delegate BeaconTracker:self didFoundNewBeacons:newBeacons];
    }
}

- (BOOL)isForegroundMode {

    UIApplicationState state = [[UIApplication sharedApplication] applicationState];
    return state == UIApplicationStateActive;

}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    UIAlertView* alertView = nil;
    if (![CLLocationManager locationServicesEnabled]) {
        alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Location services are not enabled. Please turn on Location Service in Settings app." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    }
    //    else if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized) {
    //        alertView = [[UIAlertView alloc] initWithTitle:FISDefaultAlertTitle message:@"This app is now allowed to use Location services. Please allow app in Settins app." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    //    }
    
    if (alertView != nil) {
        [alertView show];
        [alertView release];
    }
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    if ([region isEqual:_beaconRegion]) {
        NSLog(@"Entered Region");
//        [self startBeaconRanging];
    }
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    if ([region isEqual:_beaconRegion]) {
        NSLog(@"Exited Region");
//        [self stopBeaconRanging];
    }
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    if (beacons.count && [region isEqual:_beaconRegion]) {

        NSMutableArray* newBeacons = [NSMutableArray array];
        
        for (CLBeacon* beacon in beacons) {
            NSInteger proximity = beacon.proximity;
            if (proximity!=CLProximityUnknown) {
                BOOL found = NO;
                for (CLBeacon* prevBeacon in self.detectedBeacons) {
                    if ([beacon isEqualToCLBeacon:prevBeacon]) {
                        [newBeacons addObject:beacon];
                        found = YES;
                        break;
                    }
                }
                if (found==NO) {
                    [newBeacons addObject:beacon];
                }
            }
            
        }
        self.detectedBeacons = newBeacons;
    }
}

- (void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error {
    NSLog(@"Beacon ranging failed with error: %@", [error localizedDescription]);
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region {
    if ([region.identifier isEqual:_beaconRegion.identifier]) {
        switch (state) {
            case CLRegionStateInside:
                NSLog(@"Inside State");
                [self startBeaconRanging];
                break;
            case CLRegionStateOutside:
                NSLog(@"Outside State");
                [self stopBeaconRanging];
                break;
            case CLRegionStateUnknown:
                NSLog(@"Unknown State");
                break;
            default:
                break;
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    NSLog(@"Region monitoring failed with error: %@", [error localizedDescription]);
}

@end
