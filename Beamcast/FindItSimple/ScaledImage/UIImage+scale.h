//
//  UIImage+scale.h
//  FindItSimple
//
//  Created by Jain R on 3/27/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (scale)

+ (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;

- (UIImage*)resizeImageWithSize:(CGSize)newSize;

@end
