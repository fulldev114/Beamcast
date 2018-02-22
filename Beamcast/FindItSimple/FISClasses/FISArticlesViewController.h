//
//  FISArticlesViewController.h
//  FindItSimple
//
//  Created by Jain R on 3/24/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FISBaseViewController.h"
#import "FISBaseListViewController.h"
#import "FISDealInfoViewController.h"

@interface FISArticlesViewController : FISBaseListViewController <UITableViewDataSource, UITableViewDelegate, FISDealInfoViewControllerDelegate, UIAlertViewDelegate>
@property(nonatomic, retain) NSString * businessID;
@end
