//
//  FISBeaconAnnotation.h
//  FindItSimple
//
//  Created by Jain R on 3/21/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FISBeaconAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) UIImage* image;

@property (nonatomic, assign) NSInteger nBussID;
@property (nonatomic, assign) NSInteger nCategoryID;
@property (nonatomic, assign) NSInteger nBeaconID;

- (id)initWithLocation:(CLLocationCoordinate2D)coord;

@end
