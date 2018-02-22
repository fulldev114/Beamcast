//
//  FISDealsTableViewCell.h
//  FindItSimple
//
//  Created by Jain R on 3/18/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FISDealsTableViewCellType) {
    FISDealsTableViewCellTypeDeal = 0,
    FISDealsTableViewCellTypeCoupon,
    FISDealsTableViewCellTypeReward
};

@interface FISDealsTableViewCell : UITableViewCell <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (retain, nonatomic) IBOutlet UILabel *fisTitleLabel;
@property (retain, nonatomic) IBOutlet UILabel *fisBusinessLabel;
@property (retain, nonatomic) IBOutlet UILabel *fisOriginalPriceLabel;
@property (retain, nonatomic) IBOutlet UILabel *fisNewPriceLabel;
@property (retain, nonatomic) IBOutlet UILabel *fisSavedTitleLabel;
@property (retain, nonatomic) IBOutlet UILabel *fisSavedCountLabel;
@property (retain, nonatomic) IBOutlet UIImageView *fisImageView;
@property (retain, nonatomic) IBOutlet UIImageView *fisHandPickedImageView;
@property (retain, nonatomic) IBOutlet UIImageView* fisExpireTodayImageView;

@property (assign, nonatomic, getter = isHandPicked) BOOL handPicked;
@property (nonatomic, assign, getter=isExpireToday) BOOL expireToday;
@property (copy, nonatomic) NSString* imageURL;

@property (nonatomic, assign) NSInteger cellType;

@end
