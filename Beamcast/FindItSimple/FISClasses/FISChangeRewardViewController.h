//
//  FISChangeRewardViewController.h
//  FindItSimple
//
//  Created by PKS on 3/20/15.
//  Copyright (c) 2015 Alex Hong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FISBaseListViewController.h"
#import "BFPaperCheckbox.h"
@class FISChangeRewardViewController;

@protocol FISChangeRewardViewControllerDelegate <NSObject>
- (void) changeReward:(NSInteger)index;
@end

@interface FISChangeRewardViewController : FISBaseListViewController<UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate, UISearchDisplayDelegate, UIAlertViewDelegate >
@property(nonatomic, retain) NSArray * rewards;
@property (nonatomic, assign) id<FISChangeRewardViewControllerDelegate> delegate;
@end
