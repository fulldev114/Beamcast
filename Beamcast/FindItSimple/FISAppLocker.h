//
//  FISAppLocker.h
//  FindItSimple
//
//  Created by Jain R on 5/4/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FISAppLocker : NSObject

+ (id)sharedLocker;

- (void)lockApp;
- (void)lockAppWith:(BOOL)showIndicator;
- (void)unlockApp;

@end
