//
//  FISBusinessDetailViewController.h
//  FindItSimple
//
//  Created by Jain R on 4/22/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FISBaseViewController.h"

@interface FISBusinessDetailViewController : FISBaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (assign, nonatomic) NSInteger nBussinessID;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSMutableDictionary* info;
@end
