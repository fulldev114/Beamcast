//
//  FISAppDelegate.h
//  FindItSimple
//
//  Created by Jain R on 3/13/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

#import "FISRootViewController.h"
#import "FISMenuViewController.h"

#import "FISDealInfoViewController.h"
#import "BeaconTracker.h"
#import "QRCodeReaderViewController.h"
#import "QRCodeReader.h"


@interface FISAppDelegate : UIResponder <UIApplicationDelegate, BeaconTrackerDelegate, FISDealInfoViewControllerDelegate,QRCodeReaderDelegate>

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, assign) FISRootViewController *dynamicsDrawerViewController;

@property (nonatomic, assign) FISMenuViewController *menuViewController;

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error;
// process to get points
- (void) processToGetPoints:(NSArray *)beacon from:(NSInteger)from;
@end
