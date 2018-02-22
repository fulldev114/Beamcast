
//
//  FISAppDelegate.m
//  FindItSimple
//
//  Created by Jain R on 3/13/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import "FISAppDelegate.h"
#import "FISMenuViewController.h"
#import "FISNavigationController.h"
#import "FISDealsViewController.h"
#import "FISGetRewardViewController.h"

@implementation FISAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UIStoryboard* storyboard = nil;
    if (self.window.rootViewController) {
        storyboard = self.window.rootViewController.storyboard;
        self.dynamicsDrawerViewController = (FISRootViewController*)self.window.rootViewController;
    }
    else {
        // replace storyboard window with new window of Runtime DynamicsDrawerViewController
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        storyboard = [UIStoryboard storyboardWithName:@"FIS_iPhone" bundle:nil];
        self.dynamicsDrawerViewController = [FISRootViewController new];
        self.window.rootViewController = self.dynamicsDrawerViewController;
        [self.window makeKeyAndVisible];
    }
    self.window.backgroundColor = UIColorWithRGBA(116, 120, 123, 1);
    
    
//    [self.dynamicsDrawerViewController addStylersFromArray:@[[MSDynamicsDrawerScaleStyler styler], [MSDynamicsDrawerFadeStyler styler]] forDirection:MSDynamicsDrawerDirectionLeft];
    [self.dynamicsDrawerViewController addStylersFromArray:@[[MSDynamicsDrawerParallaxStyler styler]] forDirection:MSDynamicsDrawerDirectionRight];
    
    // set MenuViewController
    FISMenuViewController *menuViewController = [storyboard instantiateViewControllerWithIdentifier:@"FISMenuViewController-568h"];
    menuViewController.dynamicsDrawerViewController = self.dynamicsDrawerViewController;
    [self.dynamicsDrawerViewController setDrawerViewController:menuViewController forDirection:MSDynamicsDrawerDirectionLeft];

	self.menuViewController = menuViewController;
    
    NSMutableArray* viewControllers = [NSMutableArray array];
    
    UIViewController* viewController = [storyboard instantiateViewControllerWithIdentifier:@"FISCategoriesViewController-568h"];
    viewController.navigationItem.title = @"CATEGORIES";
    [(FISCategoriesViewController*)viewController initializeGlobalCategories];
    [viewControllers addObject:viewController];
    
    // Transition to the first view controller
    [menuViewController transitionToViewController:viewController];

    viewController = [storyboard instantiateViewControllerWithIdentifier:@"FISDealsViewController-568h"];
    viewController.navigationItem.title = @"DEALS";
    [viewControllers addObject:viewController];
    
    viewController = [storyboard instantiateViewControllerWithIdentifier:@"FISArticlesViewController-568h"];
    viewController.navigationItem.title = @"FYI";
    [viewControllers addObject:viewController];
    
//    viewController = [storyboard instantiateViewControllerWithIdentifier:@"FISDealsViewController-568h"];
//    viewController.navigationItem.title = @"REWORDS";
//    ((FISDealsViewController *)viewController).dealListType = FISDealsViewControllerTypeReward;
//    [viewControllers addObject:viewController];
    viewController = [storyboard instantiateViewControllerWithIdentifier:@"FISEventsViewController-568h"];
    viewController.navigationItem.title = @"HAPPENINGS";
    [viewControllers addObject:viewController];
    
//    viewController = [[FISBaseViewController new] autorelease];
//    viewController.navigationItem.title = @"BUSINESSES";
//    [viewControllers addObject:viewController];
    
    viewController = [storyboard instantiateViewControllerWithIdentifier:@"FISNearbyViewController-568h"];
    viewController.navigationItem.title = @"NEARBY";
    [viewControllers addObject:viewController];
    [(FISNearbyViewController*)viewController setDelegate:menuViewController];
    
//    viewController = [[FISBaseViewController new] autorelease];
//    viewController = [storyboard instantiateViewControllerWithIdentifier:@"FISProfileViewController-568h"];
//    viewController.navigationItem.title = @"SCOUT";
//    [viewControllers addObject:viewController];
    
    viewController = [storyboard instantiateViewControllerWithIdentifier:@"FISSignViewController-568h"];
    viewController.navigationItem.title = @"PROFILE";
    [viewControllers addObject:viewController];
    menuViewController.signInViewController = (FISSignViewController*)viewController;
    [(FISSignViewController*)viewController setDelegate:menuViewController];
    
    menuViewController.viewControllers = viewControllers;

    // load ProfileViewController
    viewController = [storyboard instantiateViewControllerWithIdentifier:@"FISProfileViewController-568h"];
    viewController.navigationItem.title = @"PROFILE";
    menuViewController.profileViewController = (FISProfileViewController*)viewController;
    [(FISProfileViewController*)viewController setDelegate:menuViewController];

    [self checkVersion];
    [self clearToken];
    
    // Request permission to push local notification.
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    
    BeaconTracker* mainTracker = [BeaconTracker sharedBeaconTracker];
    mainTracker.delegate = self;
    [mainTracker startBeaconTrackingWith:ESTIMOTE_PROXIMITY_UUID regionID:SAMPLE_REGION_ID];

	// Whenever a person opens the app, check for a cached session
	if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
		// If there's one, just open the session silently, without showing the user the login UI
		[FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"email", @"user_friends"]
										   allowLoginUI:NO
									  completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
										  // Handler for session state changes
										  // This method will be called EACH time the session state changes,
										  // also for intermediate states and NOT just when the session open
										  [self sessionStateChanged:session state:state error:error];
									  }];
	}
    
#ifndef TEST_CODE
//    sleep(3);
#endif
    return YES;
}

// During the Facebook login flow, your app passes control to the Facebook iOS app or Facebook in a mobile browser.
// After authentication, your app will be called back with the session information.
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
	// Note this handler block should be the exact same as the handler passed to any open calls.
	[FBSession.activeSession setStateChangeHandler:
     ^(FBSession *session, FBSessionState state, NSError *error) {
		 // Retrieve the app delegate
		 FISAppDelegate* appDelegate = (FISAppDelegate*)[[UIApplication sharedApplication] delegate];
		 // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
		 [appDelegate sessionStateChanged:session state:state error:error];
     }];
	return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}

- (void)showMessage:(NSString *)alertText withTitle:(NSString *)alertTitle
{
	UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:alertTitle message:alertText delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease];
	[alert show];
}

// This method will handle ALL the session state changes in the app
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
	// If the session was opened successfully
	if (!error && state == FBSessionStateOpen) {
		NSLog(@"Session opened");
		// Show the user the logged-in UI
		//[self userLoggedIn];
        
		// Obtain the user object.
		[FBRequestConnection startWithGraphPath:@"/me"
									 parameters:nil
									 HTTPMethod:@"GET"
							  completionHandler:
         ^(FBRequestConnection *connection, id result, NSError *error) {
             NSDictionary<FBGraphUser> *user = result;
             NSString *email = [user objectForKey:@"email"];
             NSString *name = [NSString stringWithFormat:@"%@ %@", user.first_name, user.last_name];
             
             [[FISAppLocker sharedLocker] lockApp];
             // Sign in.
             [FISWebService sendAsynchronousCommand:ACTION_SIGN_IN parameters:@{@"usermail":email, @"userpwd":@""} completionHandler:^(NSData *response, NSError *error) {
                 NSLog(@"error:%@\n\nresponse:\n%@", error, response);
                 if (error!=nil) {
                     // Sign up.
                     [FISWebService sendAsynchronousCommand:ACTION_USER_REG parameters:@{@"usermail":email, @"userpwd":@"", @"username":name, @"usertype":@"1"} completionHandler:^(NSData *response, NSError *error) {
                         NSLog(@"error:%@\n\nresponse:\n%@", error, response);
                         if (error!=nil) {
                             NSRange range = [error.localizedDescription rangeOfString:MSG_ERR_VALUE];
                             if (range.location!=NSNotFound) {
                                 UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:@"The email address is already used by another user." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] autorelease];
                                 [alert show];
                             }
                             else {
                                 UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] autorelease];
                                 [alert show];
                             }
                             [[FISAppLocker sharedLocker] unlockApp];
                         }
                         else { // success
                             [FISAppDirectory setLastUser:email];
                             NSDictionary* data = (NSDictionary*)response;
                             NSString* token = [data objectForKey:@"token"];
                             if ([self.menuViewController respondsToSelector:@selector(signInSuccessWith:password:)]) {
                                 [self.menuViewController signInSuccessWith:token password:@""];
                             }
                             else
                                 [[FISAppLocker sharedLocker] unlockApp];
                         }
                     }];
                     
                     
                     [[FISAppLocker sharedLocker] unlockApp];
                 }
                 else { // success
                     [FISAppDirectory setLastUser:email];
                     NSDictionary* data = (NSDictionary*)response;
                     NSString* token = [data objectForKey:@"token"];
                     if ([self.menuViewController respondsToSelector:@selector(signInSuccessWith:password:)]) {
                         [self.menuViewController signInSuccessWith:token password:@""];
                     }
                     else
                         [[FISAppLocker sharedLocker] unlockApp];
                 }
             }];
             
         }];
        
		return;
	}
    
	if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
		// If the session is closed
		NSLog(@"Session closed");
		// Show the user the logged-out UI
		//[self userLoggedOut];
	}
	
	// Handle errors
	if (error) {
		NSLog(@"Error");
		NSString *alertText;
		NSString *alertTitle;
        
		// If the error requires people using an app to make an action outside of the app in order to recover
		if ([FBErrorUtility shouldNotifyUserForError:error] == YES) {
			alertTitle = @"Error";
			alertText = [FBErrorUtility userMessageForError:error];
			[self showMessage:alertText withTitle:alertTitle];
		}
		else {
			// If the user cancelled login, do nothing
			if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
				NSLog(@"User cancelled login");
			}
			else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
				// Handle session closures that happen outside of the app
				alertTitle = @"Session Error";
				alertText = @"Your current session is no longer valid. Please log in again.";
				[self showMessage:alertText withTitle:alertTitle];
			}
			else {
				// Here we will handle all other errors with a generic error message.
				// We recommend you check our Handling Errors guide for more information
				// https://developers.facebook.com/docs/ios/errors/
                
				// Get more error information from the error
				NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
				
				// Show the user an error message
				alertTitle = @"Error";
				alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
				[self showMessage:alertText withTitle:alertTitle];
			}
		}
        
		// Clear this token
		[FBSession.activeSession closeAndClearTokenInformation];
        
		// Show the user the logged-out UI
		//[self userLoggedOut];
	}
}

- (void)BeaconTracker:(BeaconTracker *)beaconTracker didFoundNewBeacons:(NSArray *)beacons {
//    NSMutableArray* newBeacons = [NSMutableArray array];
//    
//    for (CLBeacon* detectedBeacon in beacons) {
//        [newBeacons addObject:[NSArray arrayWithObjects:[NSNumber numberWithInteger:detectedBeacon.major.integerValue], [NSNumber numberWithInteger:detectedBeacon.minor.integerValue], nil]];
//    }
//
    if (beacons.count == 0) {
        return;
    }
    
    [self updateBeaconData:beacons];
    
    if ([[UIApplication sharedApplication] applicationState] != UIApplicationStateActive) {
        // get popups
        NSString* token = FISGetCurrentToken();
        
        NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
        [parameters setObject:beacons forKey:@"beacons"];
        if (token.length!=0) {
            [parameters setObject:token forKey:@"token"];
        }
        [parameters setObject:[FISAppDirectory getFavorites] forKey:@"categories"];
        [parameters setObject:[FISAppDirectory getCities] forKey:@"cities"];
        
        // get deals
        [FISWebService sendAsynchronousCommand:ACTION_GET_POPUPS parameters:parameters completionHandler:^(NSData *response, NSError *error) {
            NSLog(@"error:%@\n\nresponse:\n%@", error, response);
            if (error!=nil) {
            }
            else {
                [self sendNotificationsWithPopups:(NSArray*)response];
            }
        }];
    }
    // check a status of beacon (detected or not)
    
    NSArray * beacon = [beacons firstObject];
    NSString * beaconKey = [NSString stringWithFormat:@"%@-%@",[beacon objectAtIndex:0],[beacon objectAtIndex:1]];
    
    if ([FISAppDirectory isTimeOutForDetectingBeacon:beaconKey]) {
        [self processToGetPoints:beacons from:FIS_CALL_GET_POINTS_FROM_NOTIFICATION];
    }
}

#pragma Update Beacon Data
-(void) updateBeaconData:(NSArray*) beacons
{
    [FISWebService sendAsynchronousCommand:ACTION_GET_BEACON_ALL parameters:@{@"categories": [FISAppDirectory getFavorites], @"cities":[FISAppDirectory getCities]} completionHandler:^(NSData *response, NSError *error) {
        NSLog(@"error:%@\n\nresponse:\n%@", error, response);
        if (error!=nil) {
            UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] autorelease];
            [alert show];
        }
        else {
            NSMutableArray* arrBeaconData = [NSMutableArray arrayWithArray:(NSArray*)response];
            if (arrBeaconData.count > 0) {
                [self updateBeaconGets:beacons beaconData:arrBeaconData];
            }
        }
    }];
}

-(void)updateBeaconGets:(NSArray*) beacons beaconData:(NSMutableArray*) beaconData {
    for(int i=0; i<beacons.count; i++) {
        NSArray *beacon = [beacons objectAtIndex:i];
        int major = [[beacon objectAtIndex:0] integerValue];
        int minor = [[beacon objectAtIndex:1] integerValue];
        for (int j=0; j<beaconData.count; j++) {
             NSMutableDictionary* object = [NSMutableDictionary dictionaryWithDictionary:[beaconData objectAtIndex:j]];
            int bus_id = [[object objectForKey:@"bus_id"] integerValue];
            int major1 = [[object objectForKey:@"major"] integerValue];
            int minor1 = [[object objectForKey:@"minor"] integerValue];
            int inside = [[object objectForKey:@"inside"] integerValue];
            if (major == major1 && minor == minor1) {
                if (inside == 0) {
                    NSString* token = FISGetCurrentToken();
                    
                    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
                    if (token.length!=0) {
                        [parameters setObject:token forKey:@"token"];
                    }
                    [parameters setObject:[NSString stringWithFormat:@"%d", bus_id] forKey:@"bus_id"];
                    [FISWebService sendAsynchronousCommand:ACTION_GET_OUTSIDE parameters:parameters completionHandler:^(NSData *response, NSError *error) {
                    }];
                } else if (inside == 1){
                    NSString* token = FISGetCurrentToken();
                    
                    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
                    if (token.length!=0) {
                        [parameters setObject:token forKey:@"token"];
                    }
                    [parameters setObject:[NSString stringWithFormat:@"%d", bus_id] forKey:@"bus_id"];
              
                    [FISWebService sendAsynchronousCommand:ACTION_GET_INSIDE parameters:parameters completionHandler:^(NSData *response, NSError *error) {
                    }];
                    
                }
            }
        }
    }
}

#pragma procee to get points 
-(void) processToGetPoints:(NSArray *)beacons from:(NSInteger)from {
    // get beacon info for reward charge
    NSString * fisAction = ACTION_GET_BUSINESS_FOR_BEACON;
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    
    if ([beacons firstObject] == nil) {
        if (from != FIS_CALL_GET_POINTS_FROM_NOTIFICATION) {
            [[FISAppLocker sharedLocker] unlockApp];
        }
        return;
    }
    
    [parameters setObject:[beacons firstObject] forKey:@"beacon"];
    NSString * token = FISGetCurrentToken();
    
    if (token.length != 0) {
        [parameters setObject:token forKey:@"token"];
    }
    
    [FISWebService sendAsynchronousCommand:fisAction parameters:parameters completionHandler:^(NSData *response, NSError *error) {
        NSLog(@"error:%@\n\nresponse:\n%@", error, response);
        if (error!=nil) {
            if (from == FIS_CALL_GET_POINTS_FROM_DEAL_INFO_VC) {
                [[FISAppLocker sharedLocker] unlockApp];
                FISNoValidBeaconAlert()
            }
        }
        else {
            NSDictionary * business = (NSDictionary*)response;
            
            if (business == nil) {
                if (from != FIS_CALL_GET_POINTS_FROM_NOTIFICATION) {
                    [[FISAppLocker sharedLocker] unlockApp];
                }
                return;
            }
            NSArray * beacon = [beacons firstObject];
            NSString * beaconKey = [NSString stringWithFormat:@"%@-%@",[beacon objectAtIndex:0],[beacon objectAtIndex:1]];
            [FISAppDirectory setDetectedBeaconKey:beaconKey];
            
            [FISAppDirectory setBusinessForDetectedBeacon:business];
            if (from == FIS_CALL_GET_POINTS_FROM_NOTIFICATION) {
                [self sendNotificationsWithRewards:business];
            } else {
                [[FISAppLocker sharedLocker] unlockApp];
                [self showGetPointsAlert:business from:from];
            }
        }
    }];
}

- (void)sendNotificationsWithPopups:(NSArray*)popups {

    for (NSDictionary* popup in popups) {
        NSString *message = [popup objectForKey:@"simple_title"];
        NSString *type = [popup objectForKey:@"type"];

        NSString *action;
        NSString* popupKey;
        if ([type isEqualToString:TYPE_DEAL]) {
            action = @"view this Deal";
            popupKey = [NSString stringWithFormat:@"popupKey-%@-%@", [popup objectForKey:@"id"], TYPE_DEAL];
        }
        else {
            action = @"view this Event";
            popupKey = [NSString stringWithFormat:@"popupKey-%@-%@", [popup objectForKey:@"id"], TYPE_EVENT];
        }

#ifndef TEST_CODE
        // check notification available
        NSUserDefaults* ud  = [NSUserDefaults standardUserDefaults];
        NSDictionary* history = [ud dictionaryForKey:popupKey];

        NSDate * currentTime = [NSDate date];

        if (history) {

            NSString* lastNotificationTitle = [history objectForKey:FISLastNotificationTitleKey];
            if ([lastNotificationTitle isEqualToString:message]) {
                NSDate * beforeCheckedTime = nil;
                
                beforeCheckedTime = [history objectForKey:FISLastNotificationTimeKey];
                
                // calculate days from last push notification time
                NSCalendar * calendar = [NSCalendar currentCalendar];
                NSDateComponents * components = [calendar components:NSDayCalendarUnit fromDate:beforeCheckedTime toDate:currentTime options:0];
                NSInteger days = components.day;
                
                if (days < 15) {
                    continue;
                }
            }
        }
        
        // save notification history
        history = [NSDictionary dictionaryWithObjectsAndKeys:message, FISLastNotificationTitleKey, currentTime, FISLastNotificationTimeKey, nil];
        [ud setObject:history forKey:popupKey];
        [ud synchronize];
#endif
        
        [self sendLocalNotificationWithMessage:message actioin:action userInfo:popup];
    }
}

-(void) sendNotificationsWithRewards:(NSDictionary *) business {
    NSString * business_name = [business objectForKey:FIS_PARAM_BUSINESS_NAME];
    NSString * action = FISGetPointsNotification;
    NSString * message = [NSString stringWithFormat:@"Welcome to %@!\nWould you like to claim your points?", business_name];
    
    [self sendLocalNotificationWithMessage:message actioin:action userInfo:business];
}

- (void) sendLocalNotificationWithMessage:(NSString *)message actioin:(NSString*)action userInfo:(NSDictionary*)userInfo {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertAction = action;
    notification.alertBody = message;
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.userInfo = userInfo;
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

- (void)clearToken {
    //[FISAppDirectory setToken:nil];
    
    [FISAppDirectory setNeedToRefresh:YES key:@"dealsVC"];
    [FISAppDirectory setNeedToRefresh:YES key:@"articlesVC"];
    [FISAppDirectory setNeedToRefresh:YES key:@"eventsVC"];
    [FISAppDirectory setNeedToRefresh:YES key:@"nearbyVC"];
}

- (void)checkVersion {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *currentAppVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *previousVersion = [defaults objectForKey:@"appVersion"];
    if (!previousVersion) {
        // first launch
        
        // ...
        for (int i = 0; i<FISNumberOfCategories; i++) {
            [FISAppDirectory addFavorite:i];
        }

        for (int i = 0; i<FISNumberOfCities; i++) {
            [FISAppDirectory addCity:i];
        }
        
        [defaults setObject:currentAppVersion forKey:@"appVersion"];
        [defaults setObject:[NSNumber numberWithBool:YES] forKey:FISUpdateAlertKey];
        [defaults synchronize];
    } else if ([previousVersion isEqualToString:currentAppVersion]) {
        // same version
    } else {
        // other version
        
        // ...
        
        [defaults setObject:currentAppVersion forKey:@"appVersion"];
        [defaults synchronize];
    }
    NSLog(@"version:%@->%@", previousVersion, currentAppVersion);
    
    NSInteger major = [[currentAppVersion substringToIndex:1] integerValue];
    if (major < 2) {
        NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
        BOOL isNeedAlert = [[ud objectForKey:FISUpdateAlertKey] boolValue];
        if (isNeedAlert) {
            UIAlertView* updateAlertView = [[UIAlertView alloc] initWithTitle:FISDefaultAlertTitle message:@"A new version of Beamcast is ready.\nThere are new features according to user's experience." delegate:nil cancelButtonTitle:@"Remind me later" otherButtonTitles:@"Update Now", @"Never remind me", nil];
            updateAlertView.delegate = self;
            [updateAlertView show];
        }
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"alertTitle%ld", (long)buttonIndex);
    
    if (alertView.tag == 10001) { // auto mode
        // get free points
        switch (buttonIndex) {
            case 0:
                // set beacon canceled time
                [FISAppDirectory setBeaconDetectCanceledTime:[FISAppDirectory getDetectedBeaconKey]];
                break;
            case 1:
                // charge free points to user .
                [self getFreePointsAutomatically];
                break;
        }
        return;

    } else if (alertView.tag == 10002) { // manual mode
        // get points
        switch (buttonIndex) {
            case 0:
                // set beacon canceled time
                [FISAppDirectory setBeaconDetectCanceledTime:[FISAppDirectory getDetectedBeaconKey]];
                break;
            case 1:// charge points to user .
                [self showGetPointsManualView];
                break;
        }
        return;
    } else if (alertView.tag == 10003) { // qrcode mode
        // get points
        switch (buttonIndex) {
            case 0:
                // set beacon canceled time
                [FISAppDirectory setBeaconDetectCanceledTime:[FISAppDirectory getDetectedBeaconKey]];
                break;
            case 1:// charge points to user .
                [self showQRScanView];
                break;
        }
        return;
    }
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];

    switch (buttonIndex) {
        case 0:
            [ud setObject:[NSNumber numberWithBool:YES] forKey:FISUpdateAlertKey];
            [ud synchronize];
            break;
        case 2:
            [ud setObject:[NSNumber numberWithBool:NO] forKey:FISUpdateAlertKey];
            [ud synchronize];
            break;
        case 1:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:FISUpdateAppLink]];
            break;
    }
}

- (void)saveDeal:(FISDealInfoViewController *)vc indexPath:(NSIndexPath *)indexPath saved:(BOOL)saved {
    if (vc.type == FISInfoViewControllerTypeDeal)
        [FISAppDirectory setNeedToRefresh:YES key:@"dealsVC"];
    else
        [FISAppDirectory setNeedToRefresh:YES key:@"eventsVC"];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    if (notification==nil) {
#ifdef TEST_CODE
#warning it will be called when user touched old notification again
#endif
        return;
    }
    
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive) {
        if ([notification.alertAction isEqualToString:FISGetPointsNotification]) {
            [self showGetPointsAlert:notification.userInfo from:FIS_CALL_GET_POINTS_FROM_NOTIFICATION];
        }
    } else if (state == UIApplicationStateInactive || state == UIApplicationStateBackground) {
        // Get Reward Notification
        if ([notification.alertAction isEqualToString:FISGetPointsNotification]) {
            [self showGetPointsAlert:notification.userInfo from:FIS_CALL_GET_POINTS_FROM_NOTIFICATION];
        } else {
            [[FISAppLocker sharedLocker] lockApp];
            
            NSDictionary* popup = notification.userInfo;
            NSString* dealId = [popup objectForKey:@"id"];
            
            NSString* token = FISGetCurrentToken();
            
            NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
            if (token.length!=0) {
                [parameters setObject:token forKey:@"token"];
            }
            [parameters setObject:dealId forKey:@"id"];
            
            NSString *dealType = [popup objectForKey:@"type"];
            NSString *action = ACTION_GET_DEAL;
            
            if ([dealType isEqualToString:TYPE_EVENT])
                action = ACTION_GET_EVENT;
            
            // get deal
            [FISWebService sendAsynchronousCommand:action parameters:parameters completionHandler:^(NSData *response, NSError *error) {
                NSLog(@"error:%@\n\nresponse:\n%@", error, response);
                if (error!=nil) {
                    UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] autorelease];
                    [alert show];
                }
                else {
                    UIViewController* rootViewController = self.window.rootViewController;
                    FISDealInfoViewController* detailViewController = [rootViewController.storyboard instantiateViewControllerWithIdentifier:@"FISDealInfoViewController-568h"];
                    detailViewController.info = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary*)response];
                    if ([dealType isEqualToString:TYPE_DEAL])
                        detailViewController.type = FISInfoViewControllerTypeDeal;
                    else
                        detailViewController.type = FISInfoViewControllerTypeEvent;
                    detailViewController.delegate = self;
                    
                    FISNavigationController* navigation = [[FISNavigationController alloc] initWithRootViewController:detailViewController];
                    
                    if (rootViewController.presentedViewController) {
                        [rootViewController dismissViewControllerAnimated:NO completion:nil];
                    }
                    
                    [rootViewController presentViewController:navigation animated:YES completion:^{
                        detailViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"icon_leftbarbutton_close2"] imageWithRenderingMode:UIImageRenderingModeAutomatic] style:UIBarButtonItemStyleBordered target:self action:@selector(dismissDetailInfoViewController)];
                    }];
                }
                
                [[FISAppLocker sharedLocker] unlockApp];
            }];
        }
    }
}

-(void) getFreePointsAutomatically {
    NSString * fisAction = ACTION_GET_POINTS_FOR_BUSINESS;
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    
    NSString * token = FISGetCurrentToken();
    NSDictionary * business = [FISAppDirectory getBusinessForDetectedBeacon];
    
    NSString * business_id = [business objectForKey:FIS_PARAM_BUSINESS_ID];
    if (token.length == 0) {
        FISNeedSignInAlert();
        return;
    }
    if (business_id.length == 0) {
        FISNoValidBeaconAlert();
        return;
    }
    [parameters setObject:token forKey:FIS_PARAM_TOKEN_ID];
    [parameters setObject:business_id forKey:@"bus_id"];
    [parameters setObject:FIS_PARAM_CHARGE_AUTO forKey:FIS_PARAM_CHARGE_METHOD];
//    [parameters setObject:@"2342" forKey:@"owner_code"];
//    [parameters setObject:@"30" forKey:@"point"];
//    
    [FISWebService sendAsynchronousCommand:fisAction parameters:parameters completionHandler:^(NSData *response, NSError *error) {
        NSLog(@"error:%@\n\nresponse:\n%@", error, response);
        if (error!=nil) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:FISDefaultAlertTitle message:@"Failed to get free points." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        } else {
            // point success
            NSDictionary * info = (NSDictionary *) response;
            
            NSString * business_name = [FISAppDirectory getBusinessNameForDetectedBeacon];
            
            NSString * free_points = [info objectForKey:@"charged_point"];
            NSString * message = [NSString stringWithFormat:@"You got %@ free points from %@.",free_points, business_name];
            
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:FISDefaultAlertTitle message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
            // send refresh notification
            [[NSNotificationCenter defaultCenter] postNotificationName:FISNOTIFICATION_REFRESH_DEALSVC object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:FISNOTIFICATION_REFRESH_DEALINFO object:nil];
        }
    }];
}

-(void) showQRScanView {
    if ([QRCodeReader supportsMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]]) {
        static QRCodeReaderViewController *reader = nil;
        static dispatch_once_t onceToken;
        
        dispatch_once(&onceToken, ^{
            reader                        = [QRCodeReaderViewController new];
            reader.modalPresentationStyle = UIModalPresentationFormSheet;
        });
        reader.delegate = self;
        
        [reader setCompletionWithBlock:^(NSString *resultAsString) {
            NSLog(@"Completion with result: %@", resultAsString);
        }];
        
        [self.window.rootViewController presentViewController:reader animated:YES completion:NULL];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Reader not supported by the current device" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
    }
}

#pragma mark - QRCodeReader Delegate Methods
- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
{
    // parse result
    NSData * data = [result dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * qr_info = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    NSString * qr_id = [qr_info objectForKey:@"id"];
    
    if (qr_info == nil || qr_id == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:FISDefaultAlertTitle message:@"Please scan valid QR code." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    //self.qrCodeID = [NSString stringWithFormat:@"%@",qr_id];
    //self.fisQRCodeName.text = [qr_info objectForKey:@"title"];
    // request web server to claim qrcode points
    [[FISAppLocker sharedLocker] lockApp];
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    
    NSString * token = FISGetCurrentToken();
    NSDictionary * business = [FISAppDirectory getBusinessForDetectedBeacon];
    
    NSString * business_id = [business objectForKey:FIS_PARAM_BUSINESS_ID];
    if (token.length == 0) {
        FISNeedSignInAlert();
        return;
    }
    if (business_id.length == 0) {
        FISNoValidBeaconAlert();
        return;
    }
    [parameters setObject:token forKey:@"token"];
    [parameters setObject:business_id forKey:@"bus_id"];
    [parameters setObject:[NSString stringWithFormat:@"%@",qr_id] forKey:@"owner_code"];
    
    NSString * chargeMode = @"qrcode";
    [parameters setObject:chargeMode forKey:@"charge_mode"];
    [FISWebService sendAsynchronousCommand:ACTION_GET_POINTS_FOR_BUSINESS parameters:parameters completionHandler:^(NSData *response, NSError *error) {
        NSLog(@"error:%@\n\nresponse:\n%@", error, response);
        if (error!=nil) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:FISDefaultAlertTitle message:@"Failed to get free points." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        } else {
            // point success
            NSDictionary * info = (NSDictionary *) response;
            
            NSString * business_name = [FISAppDirectory getBusinessNameForDetectedBeacon];
            NSString * points = [info objectForKey:@"charged_point"];
            NSString * message = [NSString stringWithFormat:@"You got %@ points from %@.",points,business_name];
            
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:FISDefaultAlertTitle message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
            // need to refresh
            [[NSNotificationCenter defaultCenter] postNotificationName:FISNOTIFICATION_REFRESH_DEALSVC object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:FISNOTIFICATION_REFRESH_DEALINFO object:nil];
        }
        [[FISAppLocker sharedLocker] unlockApp];
    }];
    
    [reader dismissViewControllerAnimated:YES completion:nil];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    [self.window.rootViewController dismissViewControllerAnimated:YES completion:NULL];
}

// user functions
-(void) showGetPointsManualView {
    UIViewController* rootViewController = self.window.rootViewController;
    
    FISGetRewardViewController* vc = [rootViewController.storyboard instantiateViewControllerWithIdentifier:@"FISGetRewardViewController-568h"];
    
    NSDictionary * business = [FISAppDirectory getBusinessForDetectedBeacon];
    NSString * business_id = [business objectForKey:FIS_PARAM_BUSINESS_ID];
    NSDictionary * charge_method = [business objectForKey:FIS_PARAM_CHARGE_METHOD];
    NSString * manualMethod = [charge_method objectForKey:FIS_PARAM_CHARGE_MANUAL];
    NSString * qrCodeMethod = [charge_method objectForKey:FIS_PARAM_CHARGE_QRCODE];
    NSString * receipt_number = [business objectForKey:FIS_PARAM_BUSINESS_RECEIPT_NUMBER];
    NSString * token = FISGetCurrentToken();
    
    if (token.length == 0) {
        FISNeedSignInAlert();
        return;
    }
    if (business_id.length == 0) {
        FISNoValidBeaconAlert();
        return;
    }
    
     if ([manualMethod isEqualToString:@"enable"]) {
        vc.rewardType = FISGetRewardViewControllerTypeManual;
        vc.receipt_number = receipt_number;
        if ([qrCodeMethod isEqualToString:@"enable"]) {
            vc.rewardType = FISGetRewardViewControllerTypeBoth;
        }
    } else {
        if ([qrCodeMethod isEqualToString:@"enable"]) {
            vc.rewardType = FISGetRewardViewControllerTypeQRCode;
        } else {
            FISNoValidBeaconAlert();
            return;
        }
    }
    
    vc.info = business;
    
    UIViewController * nav = (FISNavigationController *)rootViewController.presentedViewController;
    
    if (nav != nil) {
        if ([nav isKindOfClass:[FISGetRewardViewController class]]) {
            [rootViewController dismissViewControllerAnimated:NO completion:nil];
        }
        else {
            return;
        }
    }
    
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    vc.view.backgroundColor = [UIColor clearColor];
    
    [rootViewController presentViewController:vc animated:YES completion:nil];
}

-(void) showGetPointsAlert:(NSDictionary *) business from:(NSInteger)from{

    if (business == nil) {
        return;
    }

    NSString * message = nil;
    NSString * otherTitles = nil;
    NSDictionary * charge_method = [business objectForKey:FIS_PARAM_CHARGE_METHOD];
    NSString * autoMethod = [charge_method objectForKey:FIS_PARAM_CHARGE_AUTO];
    NSString * manualMethod = [charge_method objectForKey:FIS_PARAM_CHARGE_MANUAL];
    NSString * qrcodeMethod = [charge_method objectForKey:FIS_PARAM_CHARGE_QRCODE];
    
    NSString * business_name = [business objectForKey:FIS_PARAM_BUSINESS_NAME];
    NSString * free_points = [business objectForKey:FIS_PARAM_BUSINESS_FREE_POINTS];
    NSString *charge_interval = [business objectForKey:FIS_PARAM_BUSINESS_CHARGE_INTERVAL];
    NSDictionary * last_charge = [business objectForKey:FIS_PARAM_BUSINESS_LAST_CHARGE];
    NSString *latest = [[last_charge objectForKey:FIS_PARAM_CHARGE_AUTO] objectForKey:FIS_PARAM_BUSINESS_LATEST];
    NSString *now = [[last_charge objectForKey:FIS_PARAM_CHARGE_AUTO] objectForKey:FIS_PARAM_BUSINESS_NOW];

    UIAlertView * alertView = nil;
    
    message = [NSString stringWithFormat:@"Hi, %@! Welcome to %@.Would you like to get your points?", [FISAppDirectory getTokenName], business_name];
    
    if ([autoMethod isEqualToString:@"enable"]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *latest_date = [formatter dateFromString:latest];
        NSDate *now_date = [formatter dateFromString:now];
        NSTimeInterval secs = [now_date timeIntervalSinceDate:latest_date];
        if ((secs/3600) > [charge_interval intValue]) {
            otherTitles = @"Get Your Automatic Points";
            alertView = [[[UIAlertView alloc] initWithTitle:@"Get Points" message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:otherTitles, nil] autorelease];
            alertView.tag = 10001; // auto mode
        } else {
            FISLimitClaimAlert();
        }
        
    } else if ([manualMethod isEqualToString:@"enable"]) {
        otherTitles = @"Get Your Points Manually";
        alertView = [[[UIAlertView alloc] initWithTitle:@"Get Points" message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:otherTitles, nil] autorelease];
        alertView.tag = 10002; // manual mode
    }else if ([qrcodeMethod isEqualToString:@"enable"]) {
        otherTitles = @"Scan QR Code";
        alertView = [[[UIAlertView alloc] initWithTitle:@"Get Points" message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:otherTitles, nil] autorelease];
        alertView.tag = 10003; // qrcode mode
    } else {
        FISLimitClaimAlert();
        return;
    }
    [alertView show];
}

- (void)dismissDetailInfoViewController {
    [self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

	// Handle the user leaving the app while the Facebook login dialog is being shown
	// For example: when the user presses the iOS "home" button while the login dialog is active
	[FBAppCall handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
