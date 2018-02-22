//
//  FISDealSummaryView.h
//  FindItSimple
//
//  Created by Jain R on 3/19/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FISMiddleLineLabel.h"
#import "ASProgressPopUpView.h"

@interface FISDealSummaryView : UITableViewCell

@property (retain, nonatomic) IBOutlet UIImageView *fisDealImageView;
@property (retain, nonatomic) IBOutlet UILabel *fisDealTitle;
@property (retain, nonatomic) IBOutlet FISMiddleLineLabel *fisOriginalPrice;
@property (retain, nonatomic) IBOutlet UILabel *fisNewPriceLabel;
@property (retain, nonatomic) IBOutlet UILabel *fisDiscountTitleLabel;
@property (retain, nonatomic) IBOutlet UILabel *fisSavedTitleLabel;
@property (retain, nonatomic) IBOutlet UILabel *fisSavedCountLabel;
@property (retain, nonatomic) IBOutlet UILabel *fisDiscountValueLabel;
@property (retain, nonatomic) IBOutlet UIView *fisButtonContainer;

@end
