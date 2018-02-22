//
//  FISAppLocker.m
//  FindItSimple
//
//  Created by Jain R on 5/4/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import "FISAppLocker.h"
#import "FISAppDelegate.h"
#import "FISClasses/FISRootViewController.h"

@implementation FISAppLocker

+ (id)sharedLocker {
    static FISAppLocker* _sharedInstance = nil;
    if (_sharedInstance==nil) {
        _sharedInstance = [[FISAppLocker alloc] init];
    }
    return _sharedInstance;
}

- (void)lockApp {
    [self lockAppWith:YES];
}

- (void)lockAppWith:(BOOL)showIndicator {
    FISAppDelegate* appDelegate = (FISAppDelegate*)[[UIApplication sharedApplication] delegate];
    FISRootViewController* rootViewController = appDelegate.dynamicsDrawerViewController;
    [rootViewController.view bringSubviewToFront:rootViewController.lockBackgroundView];
    rootViewController.lockAnimationContainerView.hidden = !showIndicator;
}

- (void)unlockApp {
    FISAppDelegate* appDelegate = (FISAppDelegate*)[[UIApplication sharedApplication] delegate];
    FISRootViewController* rootViewController = appDelegate.dynamicsDrawerViewController;
    [rootViewController.view sendSubviewToBack:rootViewController.lockBackgroundView];
}

@end
