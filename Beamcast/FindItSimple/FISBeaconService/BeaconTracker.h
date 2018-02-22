//
//  BeaconTracker.h
//  iBeaconTracker
//
//  Created by Jain R on 10/2/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;

@class BeaconTracker;

@protocol BeaconTrackerDelegate <NSObject>

- (void)BeaconTracker:(BeaconTracker*)beaconTracker didFoundNewBeacons:(NSArray*)beacons;

@end

@interface BeaconTracker : NSObject <CLLocationManagerDelegate>

@property (atomic, retain) NSArray* detectedBeacons;
@property (atomic, retain) NSArray* blackBeacons;

@property (nonatomic, assign) id<BeaconTrackerDelegate> delegate;

+ (BeaconTracker *)sharedBeaconTracker;

- (void)startBeaconTrackingWith:(NSUUID *)beaconProximityUUID regionID:(NSString *)beaconRegionID;
- (void)stopBeaconTracking;

@end
