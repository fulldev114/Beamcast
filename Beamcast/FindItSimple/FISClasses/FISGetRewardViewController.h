//
//  FISGetRewardViewController.h
//  FindItSimple
//
//  Created by PKS on 3/20/15.
//  Copyright (c) 2015 Alex Hong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FISBaseViewController.h"
#import "QRCodeReaderViewController.h"
#import "QRCodeReader.h"

typedef NS_ENUM(NSInteger, FISGetRewardViewControllerType) {
    FISGetRewardViewControllerTypeQRCode = 1,
    FISGetRewardViewControllerTypeManual = 2,
    FISGetRewardViewControllerTypeBoth = 3,
    FISGetRewardViewControllerTypeAuto = 4
};

@class FISGetRewardViewController;

@protocol FISGetRewardViewControllerChangePointDelegate <NSObject>
- (void) changeUserPoint:(NSInteger)point;
@end

@interface FISGetRewardViewController : FISBaseViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,QRCodeReaderDelegate, UIAlertViewDelegate>


// lock view
@property (retain, nonatomic) IBOutlet UIView *lockBackgroundView;
@property (retain, nonatomic) IBOutlet UIView *lockAnimationContainerView;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *lockIndicator;
@property (retain, nonatomic) IBOutlet UILabel *lockLabel;
@property (retain, nonatomic) IBOutlet UIButton * btnGetPoints;
@property (retain, nonatomic) IBOutlet UIButton * btnCancel;
@property (retain, nonatomic) IBOutlet UILabel * lblTitle;
@property (retain, nonatomic) IBOutlet UIView * bodyView;
// member variable
@property (retain, nonatomic) UISwitch * fisRewardTypeSwitch;

@property (retain, nonatomic) UIButton * fisBtnGetPoints;
@property (retain, nonatomic) UITextField * fisQRCodeName;
@property (retain, nonatomic) UITextField * fisReceiptNumber2;

@property (retain, nonatomic) UITextField * fisProductName;
@property (retain, nonatomic) UITextField * fisAmount;
@property (retain, nonatomic) UITextField * fisPoint;
@property (retain, nonatomic) UITextField * fisReceiptNumber1;
@property (retain, nonatomic) UIView * fisScanTapView;

@property (retain, nonatomic) NSDictionary * info;

@property (assign, nonatomic) FISGetRewardViewControllerType rewardType;
@property (retain, nonatomic) IBOutlet UITableView * tableView;
@property (retain, nonatomic) NSString * qrCodeID;
@property (assign, nonatomic) NSString * receipt_number;

@property (nonatomic, assign) id<FISGetRewardViewControllerChangePointDelegate> delegate;

@end
