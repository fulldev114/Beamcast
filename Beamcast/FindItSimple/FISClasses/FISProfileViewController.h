//
//  FISProfileViewController.h
//  FindItSimple
//
//  Created by Jain R on 3/26/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FISBaseViewController.h"
#import "SCNavigationController.h"
#import "FISPostViewController.h"
#import "FISChangeNameViewController.h"
#import "FISChangePaswwordViewController.h"
#import "FISCityViewController.h"
#import "FISBaseListViewController.h"

@protocol FISProfileViewControllerDelegate <NSObject>

- (void)userInfoChanged;
- (void)signOut;

@end

@interface FISProfileViewController : FISBaseViewController <UITableViewDelegate, UITableViewDataSource, SCNavigationControllerDelegate, FISPostViewControllerDelegate, FISChangeNameViewControllerDelegate, FISchangePasswordViewControllerDelegate, FISChangeCityViewControllerDelegate>

@property (nonatomic, assign) id<FISProfileViewControllerDelegate> delegate;
@property (nonatomic, retain) NSDictionary* info;

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@end
