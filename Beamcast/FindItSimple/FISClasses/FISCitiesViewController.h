//
//  FISCitiesViewController.h
//  FindItSimple
//
//  Created by Jain R on 10/27/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import "FISBaseViewController.h"

@interface FISCitiesViewController : FISBaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSArray* citys;

@property (retain, nonatomic) IBOutlet UITableView *tableView;

@end
