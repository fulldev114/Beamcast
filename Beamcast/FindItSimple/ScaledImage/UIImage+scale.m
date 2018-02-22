//
//  UIImage+scale.m
//  FindItSimple
//
//  Created by Jain R on 3/27/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import "UIImage+scale.h"

@implementation UIImage (scale)

+ (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage*)resizeImageWithSize:(CGSize)newSize {
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    newSize = CGSizeMake(newSize.width*screenScale, newSize.height*screenScale);
    UIGraphicsBeginImageContext( newSize );
    CGContextSetInterpolationQuality(UIGraphicsGetCurrentContext(), kCGInterpolationHigh);
    [self drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    newImage = [UIImage imageWithCGImage:newImage.CGImage scale:screenScale orientation:newImage.imageOrientation];
    return newImage;
}

@end
