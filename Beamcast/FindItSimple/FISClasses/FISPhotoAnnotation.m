//
//  FISPhotoAnnotation.m
//  FindItSimple
//
//  Created by Jain R on 3/21/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import "FISPhotoAnnotation.h"

@implementation FISPhotoAnnotation

- (id)initWithLocation:(CLLocationCoordinate2D)coord {
    self = [super init];
    if (self) {
        _coordinate = coord;
    }
    return self;
}

- (NSString *)title
{
    NSString* token = FISGetCurrentToken();
    
    if (token.length==0) {
        return @"Unknown";
    }
    NSDictionary* info = [FISAppDirectory getUserInfo];
    return [info objectForKey:@"g_username"];
}

// optional
- (NSString *)subtitle
{
    NSString* token = FISGetCurrentToken();
    
    if (token.length==0) {
        return @"Unknown City";
    }
    NSDictionary* info = [FISAppDirectory getUserInfo];
    return [info objectForKey:@"g_city"];
}

@end
