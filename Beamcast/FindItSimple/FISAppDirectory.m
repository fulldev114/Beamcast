//
//  FISAppDirectory.m
//  FindItSimple
//
//  Created by Jain R on 4/3/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import "FISAppDirectory.h"

static UIImage* photo = nil;

@implementation FISAppDirectory

+ (NSString*)temporaryPathForDeal {
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"deal"];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error = nil;
    if (![fm fileExistsAtPath:cachePath]) {
        BOOL success = [fm createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:&error];
        if (!success || error) {
            return nil;
        }
    }
    return cachePath;
}

+ (BOOL)fileExistsAtPath:(NSString*)path {
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:path]) {
        return NO;
    }
    return YES;
}

+ (void)writeFileAtPath:(NSData*)data path:(NSString*)path {
    [data writeToFile:path atomically:YES];
}

+ (NSDate*)dateWithDateString:(NSString *)string {
    NSDateComponents* comp = [[NSDateComponents alloc] init];
    NSString* substr = [string substringWithRange:NSMakeRange(0, 4)];
    [comp setYear:[substr integerValue]];
    substr = [string substringWithRange:NSMakeRange(5, 2)];
    [comp setMonth:[substr integerValue]];
    substr = [string substringWithRange:NSMakeRange(8, 2)];
    [comp setDay:[substr integerValue]];
    substr = [string substringWithRange:NSMakeRange(11, 2)];
    [comp setHour:[substr integerValue]];
    substr = [string substringWithRange:NSMakeRange(14, 2)];
    [comp setMinute:[substr integerValue]];
    substr = [string substringWithRange:NSMakeRange(17, 2)];
    [comp setSecond:[substr integerValue]];
    
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDate* date = [cal dateFromComponents:comp];
    [comp release];
    return date;
}

+ (NSString*)stringWithDate:(NSDate*)date {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy"];
    NSString* year = [dateFormat stringFromDate:date];
    NSString* currentYear = [dateFormat stringFromDate:[NSDate date]];
    if ([year isEqualToString:currentYear]) {
        dateFormat.dateFormat = @"d MMMM, h:mm:a";
    }
    else {
        dateFormat.dateFormat = @"d MMMM, yyyy";
    }
    
    NSString* string = [dateFormat stringFromDate:date];
    [dateFormat release];
    return string;
}

+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSDayCalendarUnit
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}

+ (NSString*)getToken {
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    return [ud stringForKey:@"usertoken"];
}

+(NSString *) getTokenName {
    NSDictionary * info = [FISAppDirectory getUserInfo];
    return [info objectForKey:@"g_username"];
}

+ (void)setToken:(NSString*)token {
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:token forKey:@"usertoken"];
}

+ (NSString*)getLastUser {
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    return [ud stringForKey:@"lastuser"];
}

+ (void)setLastUser:(NSString*)user {
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:user forKey:@"lastuser"];
}

+ (NSString*)getCurrentPassword {
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    return [ud stringForKey:@"CP"];
}

+ (void)setCurrentPassword:(NSString*)password {
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:password forKey:@"CP"];
}

+ (void)setUserInfo:(NSDictionary*)info {
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:info forKey:@"userinfo"];
}

+ (NSDictionary*)getUserInfo {
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    return [ud objectForKey:@"userinfo"];
}

+ (void)setPhoto:(UIImage*)image {
    [photo release];
    photo = [image retain];
}

+ (UIImage*)getPhoto {
    return photo;
}

+ (NSDictionary *) getBusinessForDetectedBeacon {
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    return [ud objectForKey:@"busines_for_detected_beacon"];
}

+ (void) setBusinessForDetectedBeacon:(NSDictionary *)business {
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:business forKey:@"busines_for_detected_beacon"];
}

+ (void)setDetectedBeaconKey:(NSString *) beaconKey {
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:beaconKey forKey:@"key_for_detected_beacon"];
}

+ (NSString *) getDetectedBeaconKey {
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    return [ud objectForKey:@"key_for_detected_beacon"];
}

+ (NSString *) getBusinessNameForDetectedBeacon {
    NSDictionary * business = [FISAppDirectory getBusinessForDetectedBeacon];
    return [business objectForKey:@"title"];
}

+ (void)addFavorite:(NSInteger)categoryId {
    NSString* categoryKey = [NSString stringWithFormat:@"category%ld", (long)categoryId];
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:YES forKey:categoryKey];
    [ud synchronize];
}

+ (void)removeFavorite:(NSInteger)categoryId {
    NSString* categoryKey = [NSString stringWithFormat:@"category%ld", (long)categoryId];
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:NO forKey:categoryKey];
    [ud synchronize];
}

+ (BOOL)isFavorite:(NSInteger)categoryId {
    NSString* categoryKey = [NSString stringWithFormat:@"category%ld", (long)categoryId];
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    [ud registerDefaults:@{categoryKey: [NSNumber numberWithBool:YES]}];
    [ud synchronize];
    return [ud boolForKey:categoryKey];
}

+ (NSArray*)getFavorites {
    NSMutableArray* array = [NSMutableArray array];
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    for (int i = 0; i<FISNumberOfCategories; i++) {
        NSString* categoryKey = [NSString stringWithFormat:@"category%d", i];
        if ([ud boolForKey:categoryKey]) {
            [array addObject:[NSNumber numberWithInteger:i+1+FISCategoryBaseIndex_V3_0]];
        }
    }
    return array;
}

+ (void)addCity:(NSInteger)cityId {
    NSString* cityKey = [NSString stringWithFormat:@"city%ld", (long)cityId];
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:YES forKey:cityKey];
    [ud synchronize];
}

+ (void)removeCity:(NSInteger)cityId {
    NSString* cityKey = [NSString stringWithFormat:@"city%ld", (long)cityId];
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:NO forKey:cityKey];
    [ud synchronize];
}

+ (BOOL)isUsedCity:(NSInteger)cityId {
    NSString* cityKey = [NSString stringWithFormat:@"city%ld", (long)cityId];
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    [ud registerDefaults:@{cityKey: [NSNumber numberWithBool:YES]}];
    [ud synchronize];
    return [ud boolForKey:cityKey];
}

+ (NSArray*)getCities {
    NSMutableArray* array = [NSMutableArray array];
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    for (int i = 0; i<FISNumberOfCities; i++) {
        NSString* cityKey = [NSString stringWithFormat:@"city%d", i];
        if ([ud boolForKey:cityKey]) {
            [array addObject:[NSNumber numberWithInteger:i+1]];
        }
    }
    return array;
}

+ (BOOL)isNeedToRefreshWith:(NSString*)viewControllerKey {
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    [ud registerDefaults:@{viewControllerKey: [NSNumber numberWithBool:YES]}];
    [ud synchronize];
    return [ud boolForKey:viewControllerKey];
}

+ (void)setNeedToRefresh:(BOOL)refresh key:(NSString*)viewControllerKey {
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:refresh forKey:viewControllerKey];
    [ud synchronize];
}

+ (NSString*)stringByAddingPercentEscapeUsingUTF8Encoding:(NSString*)string {
    NSString* encodedString = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return encodedString;
}

+ (void)setBeaconDetectCanceledTime:(NSString *)key {
    if (key == nil) {
        return;
    }
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:[NSDate date] forKey:key];
    [ud synchronize];
}

+ (NSDate*)getBeaconDetectCanceledTime:(NSString *)key {
    if (key == nil) {
        return nil;
    }
    
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    return [ud objectForKey:key];
}

+ (BOOL) isTimeOutForDetectingBeacon:(NSString *) key {
    if (key == nil) {
        return YES;
    }
    NSDate * previousDate = [FISAppDirectory getBeaconDetectCanceledTime:key];
    NSDate * currentDate = [NSDate date];
    
    if (previousDate != nil) {
        NSUInteger unitFlags = NSHourCalendarUnit;
        NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents * components = [calendar components:unitFlags fromDate:previousDate toDate:currentDate options:0];
        
        if ([components hour] < 2) {
            return NO;
        }
    }
    
    return YES;
}

+ (NSArray*)cities {
    static NSArray* cities = nil;
    if (cities == nil) {
        cities = [[NSArray alloc] initWithObjects:@"Beaver", @"Brigham City", @"Castle Dale", @"Coalville", @"Duchesne", @"Farmington", @"Fillmore", @"Heber City", @"Junction", @"Kanab", @"Loa", @"Logan", @"Manila", @"Manti", @"Moab", @"Monticello", @"Morgan", @"Nephi", @"Ogden", @"Panguich", @"Parowan", @"Price", @"Provo", @"Randolph", @"Richfield", @"St. George", @"Salt Lake City", @"Tooele", @"Vernal", nil];
    }
    return cities;
}

+ (void)setSortOrder:(FISSortOrderType)order {
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    [ud setInteger:order forKey:@"sort_order"];
    [ud synchronize];
}

+ (FISSortOrderType)sortOrder {
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    return [ud integerForKey:@"sort_order"];
}

+ (void)setHideUsed:(BOOL)hide {
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:hide forKey:@"hide_used"];
    [ud synchronize];
}

+ (BOOL)isHideUsed {
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    return [ud boolForKey:@"hide_used"];
}


@end
