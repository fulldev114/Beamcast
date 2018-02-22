//
//  FISBeaconAnnotation.m
//  FindItSimple
//
//  Created by Jain R on 3/21/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import "FISBeaconAnnotation.h"

@implementation FISBeaconAnnotation

- (id)initWithLocation:(CLLocationCoordinate2D)coord {
    self = [super init];
    if (self) {
        _coordinate = coord;
    }
    return self;
}

// optional
//- (NSString *)subtitle
//{
//    return @"This is iBeacon location";
//}

- (void)dealloc {
    self.title = nil;
    self.image = nil;
    [super dealloc];
}

@end
