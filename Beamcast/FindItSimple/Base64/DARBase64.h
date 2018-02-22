//
//  DARBase64.h
//  iDAR
//
//  Created by Boal Ling on 3/20/13.
//  Copyright (c) 2013 Boal Ling. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DARBase64 : NSObject

+ (NSData*)dataWithBase64EncodedString:(NSString *)string;
+ (NSString*)base64forData:(NSData*)theData;
@end
