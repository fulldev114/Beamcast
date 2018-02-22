//
//  FISPhotoAnnotation.h
//  FindItSimple
//
//  Created by Jain R on 3/21/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FISPhotoAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithLocation:(CLLocationCoordinate2D)coord;

@end
