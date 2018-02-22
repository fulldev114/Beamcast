//
//  CLBeacon+Addition.m
//  Humana
//
//  Created by Ashish on 18/09/14.
//  Copyright (c) 2014 canopus2. All rights reserved.
//

#import "CLBeacon+Addition.h"

@implementation CLBeacon (Addition)

- (BOOL)isEqualToCLBeacon:(CLBeacon *)beacon
{
    if ([self.major isEqual: beacon.major] && [self.minor isEqual: beacon.minor])
    {
        return YES;
    }
//    if ([[self.proximityUUID UUIDString] isEqualToString:[beacon.proximityUUID UUIDString]] && [self.major isEqual: beacon.major] && [self.minor isEqual: beacon.minor])
//    {
//        return YES;
//    }

    return NO;
}

@end
