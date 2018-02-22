//
//  FISDealsViewController.h
//  FindItSimple
//
//  Created by Jain R on 3/18/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FISBaseListViewController.h"
#import "FISDealInfoViewController.h"
#import "BFPaperCheckbox.h"

typedef NS_ENUM(NSInteger, FISDealsViewControllerType) {
    FISDealsViewControllerTypeDeal = 0,
    FISDealsViewControllerTypeCoupon,
    FISDealsViewControllerTypeReward
};

@interface FISDealsViewController : FISBaseListViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, FISDealInfoViewControllerDelegate, UIAlertViewDelegate, BFPaperCheckboxDelegate>

@property(nonatomic, retain) NSString * businessID;
@property(nonatomic, assign) NSInteger dealListType;

@end
