//  FISWebService.m
//  FindItSimple
//
//  Created by Jain R on 3/28/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import "FISWebService.h"

@implementation FISWebService

+ (void)sendAsynchronousCommand:(NSString*) command
                     parameters:(NSDictionary*) parameters
              completionHandler:(void (^)(NSData* response, NSError* error)) handler {
    
    NSError* error = nil;

    NSMutableDictionary* requestData = [NSMutableDictionary dictionary];
    [requestData setObject:command forKey:@"action"];
    [requestData addEntriesFromDictionary:parameters];
    
    //NSLog(@"request data: %@", requestData);

    NSData* requestJSON = [NSJSONSerialization dataWithJSONObject:requestData options:0 error:&error];
    if (error!=nil) {
        handler(nil, error);
    }
    
    //NSLog(@"request json: %@", requestJSON);
    
    NSMutableURLRequest* request;
    NSURL* url = [NSURL URLWithString:FISAPI_URL];
    request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[requestJSON length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:requestJSON];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
#ifdef TEST_CODE
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
#endif
             
//         NSLog(@"response json: %@", data);

         if (connectionError!=nil)
         {
             handler(nil, connectionError);
         }
         else
         {
             NSError* jsonError = nil;
             NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
             if (jsonError!=nil) {
                 handler(nil, jsonError);
             }
             else {
                 
                 @try {
                     NSLog(@"response data: %@", responseData);
                     NSString* msg = [responseData objectForKey:@"msg"];
                     
                     NSRange range = [msg rangeOfString:@"ERROR"];
                     if (range.location!=NSNotFound) {
                         handler(nil, [NSError errorWithDomain:@"Beamcast" code:1 userInfo:@{NSLocalizedDescriptionKey: [msg substringFromIndex:6]}]);
                     }
                     else {
                         handler([responseData objectForKey:@"data"], nil);
                     }
                     
                 }
                 @catch (NSException *exception) {
                     handler(nil, nil);
                 }

             }
         }

#ifdef TEST_CODE
         });
#endif
     }];
    [request release];
}

- (NSString*)encodedString:(NSString*)string {
    NSString* encodedString = (NSString*)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)string, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
    return encodedString;
}

@end
