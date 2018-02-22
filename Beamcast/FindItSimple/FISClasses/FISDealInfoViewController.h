//
//  FISDealInfoViewController.h
//  FindItSimple
//
//  Created by Jain R on 3/19/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FISBaseViewController.h"
#import "FISChangeRewardViewController.h"
#import "FISDealSummaryView.h"

typedef NS_ENUM(NSInteger, FISInfoViewControllerType) {
    FISInfoViewControllerTypeDeal = 0,
    FISInfoViewControllerTypeArticle,
    FISInfoViewControllerTypeEvent,
    FISInfoViewControllerTypeCoupon,
    FISInfoViewControllerTypeReward
};

@class FISDealInfoViewController;

@protocol FISDealInfoViewControllerDelegate <NSObject>

- (void)saveDeal:(FISDealInfoViewController*)vc indexPath:(NSIndexPath*)indexPath saved:(BOOL)saved;
@optional
- (void)useCoupon:(FISDealInfoViewController*)vc indexPath:(NSIndexPath*)indexPath;

@end

@interface FISDealInfoViewController : FISBaseViewController<UIWebViewDelegate, UITableViewDataSource, UITableViewDelegate, FISActionSheetDelegate, MKMapViewDelegate, UIAlertViewDelegate,FISChangeRewardViewControllerDelegate,ASProgressPopUpViewDataSource>

@property (nonatomic, assign) id<FISDealInfoViewControllerDelegate> delegate;
@property (nonatomic, assign) FISInfoViewControllerType type;

@property (nonatomic, retain) NSIndexPath* indexPath;
@property (nonatomic, retain) NSMutableDictionary* info;
@property (nonatomic, assign) NSInteger   nUserPointsForBusiness;
@property (nonatomic, retain) NSString *  businessID;
@property (nonatomic, retain) NSArray  *  rewards;
@property (nonatomic, retain) UIImage * fisTableCellImage;

@property (retain, nonatomic) IBOutlet UIButton *fisSaveButton;
@property (retain, nonatomic) IBOutlet UIView *toolbar;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UIButton *fisUseButton;
@property (retain, nonatomic) IBOutlet UILabel *fisUseLabel;

@property (retain, nonatomic) IBOutlet UIButton *fisRewardButton;
@property (retain, nonatomic) IBOutlet ASProgressPopUpView * fisRewardProgress;

- (void)goBack;

- (IBAction)saveButtonClicked:(UIButton *)sender;
- (IBAction)useButtonClicked:(UIButton *)sender;
- (IBAction)rewardButtonClicked:(id)sender;

@end
