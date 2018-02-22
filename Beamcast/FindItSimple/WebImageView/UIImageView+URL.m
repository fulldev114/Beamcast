//
//  UIImageView+URL.m
//  FindItSimple
//
//  Created by Jain R on 4/8/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import "UIImageView+URL.h"

@implementation UIImageView (URL)

- (void)setURLWith:(NSString *)URL {

    URL = [FISAppDirectory stringByAddingPercentEscapeUsingUTF8Encoding:URL];
    
    self.backgroundColor = [UIColor blackColor];
    
    NSURLRequest *request = [[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:URL]] autorelease];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         if (connectionError!=nil)
         {
         }
         else
         {
             self.image = [UIImage imageWithData:data];
             self.backgroundColor = [UIColor whiteColor];
         }
     }];
}

@end
