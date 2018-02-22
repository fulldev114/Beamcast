//
//  FISWebService.h
//  FindItSimple
//
//  Created by Jain R on 3/28/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FISAPI_URL @"http://www.beamcast.me/business/api/api.php"
//#define FISAPI_URL @"http://10.70.1.28/business/api/api.php"
//#define FISAPI_URL @"http://10.70.3.43/business/api/api.php"

#define ACTION_USER_REG             @"user_reg"
#define ACTION_USER_GET             @"user_get"
#define ACTION_USER_MOD             @"user_mod"
#define ACTION_SIGN_IN              @"sign_in"

#define ACTION_GET_DEAL_ALL         @"get_deal_all"
#define ACTION_GET_ARTICLE_ALL      @"get_article_all"
#define ACTION_GET_EVENT_ALL        @"get_event_all"
#define ACTION_GET_BEACON_ALL       @"get_beacon_all"
#define ACTION_GET_BUSINESS_ALL     @"get_business_all"
#define ACTION_GET_COUPON_ALL       @"get_coupon_all"

#define ACTION_GET_DEAL             @"get_deal"
#define ACTION_GET_ARTICLE          @"get_article"
#define ACTION_GET_EVENT            @"get_event"
#define ACTION_GET_BEACON           @"get_beacon"
#define ACTION_GET_BUSINESS         @"get_business"
#define ACTION_GET_COUPON           @"get_coupon"

#define ACTION_GET_INSIDE           @"add_get_inside"
#define ACTION_GET_OUTSIDE          @"add_get_outside"

#define ACTION_ADD_SAVING           @"add_saving"
#define ACTION_REMOVE_SAVING        @"remove_saving"

#define ACTION_USE_COUPON           @"use_coupon"

#define ACTION_GET_POPUPS            @"get_popups"

#define ACTION_GET_CATEGORY_ALL     @"get_category_all"

// reward action
#define ACTION_GET_REWARDS_ALL              @"get_rewards_all"
#define ACTION_USE_POINTS_FOR_REWARD        @"use_points_for_reward"
#define ACTION_GET_BUSINESS_FOR_BEACON      @"get_business_for_beacon"
#define ACTION_GET_POINTS_FOR_BUSINESS      @"get_points_for_business"
#define ACTION_GET_BUSINESS_FOR_REWARD_ALL  @"get_business_for_reward"
#define ACTION_USER_POINTS_FOR_BUSINESS     @"get_points_for_user"

// param
#define FIS_PARAM_BEACON                @"beacon"

#define FIS_PARAM_CHARGE_METHOD         @"charge_mode"
#define FIS_PARAM_CHARGE_AUTO           @"auto"
#define FIS_PARAM_CHARGE_MANUAL         @"manual"
#define FIS_PARAM_CHARGE_QRCODE         @"qrcode"

#define FIS_PARAM_BUSINESS_NAME             @"title"
#define FIS_PARAM_BUSINESS_USER_POINTS      @"user_point"
#define FIS_PARAM_BUSINESS_PICTURE          @"picture"
#define FIS_PARAM_BUSINESS_ID               @"id"
#define FIS_PARAM_BUSINESS_REWARD_IMAGE     @"picture"
#define FIS_PARAM_BUSINESS_REWARD_COUNT     @"reward_count"
#define FIS_PARAM_BUSINESS_REWARD_POINT     @"point"
#define FIS_PARAM_BUSINESS_REWARD_TITLE     @"business_reward_title"
#define FIS_PARAM_BUSINESS_REWARD_ID        @"id"
#define FIS_PARAM_BUSINESS_REWARDS          @"business_rewards"
#define FIS_PARAM_BUSINESS_FREE_POINTS      @"auto_point"
#define FIS_PARAM_BUSINESS_RECEIPT_NUMBER   @"receipt_number"
#define FIS_PARAM_BUSINESS_CHARGE_INTERVAL  @"charge_interval"
#define FIS_PARAM_BUSINESS_LAST_CHARGE      @"last_charge"
#define FIS_PARAM_BUSINESS_LATEST           @"lastest"
#define FIS_PARAM_BUSINESS_NOW              @"now"
#define FIS_PARAM_TOKEN_ID                  @"token"


// error message
#define MSG_ERR_TOKEN               @"Missing or invalid token."
#define MSG_ERR_ACTION              @"Missing or invalid action."
#define MSG_ERR_VALUE               @"Missing or invalid value."

// mark type
#define TYPE_DEAL                   @"111"
#define TYPE_ARTICLE                @"222"
#define TYPE_EVENT                  @"333"

@interface FISWebService : NSObject

+ (void)sendAsynchronousCommand:(NSString*) command
                     parameters:(NSDictionary*) parameters
              completionHandler:(void (^)(NSData* response, NSError* error)) handler;

@end
