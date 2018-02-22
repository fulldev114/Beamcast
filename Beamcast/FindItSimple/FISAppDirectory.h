//
//  FISAppDirectory.h
//  FindItSimple
//
//  Created by Jain R on 4/3/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, FISSortOrderType) {
    FISSortOrderTypeFromNewest = 0,
    FISSortOrderTypeExpireDate
};

@interface FISAppDirectory : NSObject

+ (NSString*)temporaryPathForDeal;
+ (BOOL)fileExistsAtPath:(NSString*)path;
+ (void)writeFileAtPath:(NSData*)data path:(NSString*)path;
+ (NSDate*)dateWithDateString:(NSString *)string;
+ (NSString*)stringWithDate:(NSDate*)date;
+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime;

+ (NSString*)getToken;
+ (void)setToken:(NSString*)token;
+ (NSString *) getTokenName;
+ (NSString*)getLastUser;
+ (void)setLastUser:(NSString*)user;
+ (NSString*)getCurrentPassword;
+ (void)setCurrentPassword:(NSString*)password;
+ (void)setUserInfo:(NSDictionary*)info;
+ (NSDictionary*)getUserInfo;
+ (void)setPhoto:(UIImage*)image;
+ (UIImage*)getPhoto;

+ (void)addFavorite:(NSInteger)categoryId;
+ (void)removeFavorite:(NSInteger)categoryId;
+ (BOOL)isFavorite:(NSInteger)categoryId;
+ (NSArray*)getFavorites;

+ (void)addCity:(NSInteger)cityId;
+ (void)removeCity:(NSInteger)cityId;
+ (BOOL)isUsedCity:(NSInteger)cityId;
+ (NSArray*)getCities;
+ (NSString *) getBusinessNameForDetectedBeacon;
+ (NSDictionary *) getBusinessForDetectedBeacon;
+ (void) setBusinessForDetectedBeacon:(NSDictionary *) business;

+ (BOOL)isNeedToRefreshWith:(NSString*)viewControllerKey;
+ (void)setNeedToRefresh:(BOOL)refresh key:(NSString*)viewControllerKey;

+ (NSString*)stringByAddingPercentEscapeUsingUTF8Encoding:(NSString*)string;

+ (NSArray*)cities;
+ (void)setDetectedBeaconKey:(NSString *) beaconKey;
+ (NSString *) getDetectedBeaconKey;
+ (void)setBeaconDetectCanceledTime:(NSString *)key;
+ (NSDate*)getBeaconDetectCanceledTime:(NSString *)key;
+ (BOOL) isTimeOutForDetectingBeacon:(NSString *)key;

// sort
+ (void)setSortOrder:(FISSortOrderType)order;
+ (FISSortOrderType)sortOrder;

+ (void)setHideUsed:(BOOL)hide;
+ (BOOL)isHideUsed;

@end
