//
//  FISDefine.h
//  FindItSimple
//
//  Created by Jain R on 3/14/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#ifndef FindItSimple_FISDefine_h
#define FindItSimple_FISDefine_h

// Test
//#define TEST_CODE

// Color
#define UIColorWithRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define IS_4INCH() (([[UIScreen mainScreen] bounds].size.height)==568.0f?YES:NO)
#define IS_RETINA() ([[UIScreen mainScreen] scale]==2.0)

#define FISDefaultBackgroundColor() UIColorWithRGBA(110, 100, 90, 1)
//#define FISDefaultBackgroundColor() UIColorWithRGBA(129, 183, 64, 1)
//#define FISDefaultBackgroundColor() UIColorWithRGBA(8, 180, 223, 1)

#define FISDefaultForegroundColor() UIColorWithRGBA(255, 255, 255, 1)
#define FISDefaultTextForegroundColor() UIColorWithRGBA(51, 51, 51, 1)
#define FISDefaultToolbarBackgroundColor() UIColorWithRGBA(0, 0, 0, 0.75)

// Font
#define FISFONT_REGULAR         @"OpenSans"
#define FISFONT_BOLD            @"OpenSans-Bold"
#define FISFONT_LIGHT           @"OpenSans-Light"
#define FISFONT_SEMIBOLD        @"OpenSans-Semibold"
#define FISFONT_EXTRABOLD       @"OpenSans-Extrabold"
#define FISFONT_SEMIBOLDITALIC  @"OpenSans-SemiboldItalic"
#define FISFONT_NAVIGATION_TITLESIZE    20.0f

// Default Notification Name
#define FISNOTIFICATION_REFRESH_DEALSVC     @"RefreshNotificationForDealsVC"
#define FISNOTIFICATION_REFRESH_DEALINFO    @"RefreshNotificationForDealInfo"

// Image mode
#define FISImageViewMode        UIViewContentModeScaleToFill

// List
#define NUMBEROFROWSINAPAGE     20

// String
#define FISAppendStringWithDollar(string) [@"$" stringByAppendingString:string]
#define FISAppendStringWithPercent(string) [NSString stringWithFormat:@"%d%%", [string intValue] ]
#define FISAppendStringWithDate(string) [FISAppDirectory stringWithDate:[FISAppDirectory dateWithDateString:string]]

// ALERT
#define FISDefaultAlertTitle @"Beamcast"

// Category
#define FISNumberOfCategories   12
#define FISAllCategoryTitle     @"All"
#define FISCategoryBaseIndex_V3_0 200

// City
#define FISNumberOfCities       29

// Token
#define FISGetCurrentToken() [FISAppDirectory getToken]

// list type
typedef NS_ENUM(NSInteger, FISListType) {
    FISListTypeDefault = 0,
    FISListTypeSaved,
    FISListTypeSearched,
    FISListTypeSubgroup,
    FISListTypeSpecialCategory
};

// App Settings
#define FISLastNotificationTitleKey @"notification_title"
#define FISLastNotificationTimeKey  @"notification_time"
#define FISUpdateAlertKey           @"alert_update"
#define FISGetPointsNotification    @"Get Points Notification"

// Alert
#define FISNeedSignInAlert() UIAlertView* alret = [[[UIAlertView alloc] initWithTitle:FISDefaultAlertTitle message:@"Please Sign in on Profile Page." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] autorelease]; \
    [alret show];

#define FISNoValidBeaconAlert() UIAlertView* alret = [[[UIAlertView alloc] initWithTitle:FISDefaultAlertTitle message:@"Uh oh, your phone is not detecting the beacon, try getting a little closer." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] autorelease]; \
[alret show];

#define FISLimitClaimAlert() UIAlertView* alret = [[[UIAlertView alloc] initWithTitle:FISDefaultAlertTitle message:@"Oops, you have already claimed your points today." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] autorelease]; \
[alret show];

#define FIS_CALL_GET_POINTS_FROM_NOTIFICATION 0
#define FIS_CALL_GET_POINTS_FROM_DEAL_INFO_VC 1
// Point Charge Method
#define FIS_POINT_CHARGE_NONE        @"0"
#define FIS_POINT_CHARGE_AUTOMATIC   @"1"
#define FIS_POINT_CHARGE_MANUAL      @"2"
#define FIS_POINT_CHARGE_QRCODE      @"3"

// Update
#define FISUpdateAppLink            @"https://itunes.apple.com/us/app/beamcast/id904782609?mt=8"

// Beacon
#define ESTIMOTE_PROXIMITY_UUID             [[NSUUID alloc] initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"]
#define ESTIMOTE_MACBEACON_PROXIMITY_UUID   [[NSUUID alloc] initWithUUIDString:@"08D4A950-80F0-4D42-A14B-D53E063516E6"]
#define ESTIMOTE_IOSBEACON_PROXIMITY_UUID   [[NSUUID alloc] initWithUUIDString:@"8492E75F-4FD6-469D-B132-043FE94921D8"]
#define SAMPLE_REGION_ID @"EstimoteSampleRegion"

#endif
