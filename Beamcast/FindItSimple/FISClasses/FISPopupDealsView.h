//
//  FISPopupDealsView.h
//  FindItSimple
//
//  Created by Jain R on 5/2/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FISDealInfoViewController.h"

@interface FISPopupDealsView : UITableView <UITableViewDataSource, UITableViewDelegate, FISDealInfoViewControllerDelegate> {
}

@property (nonatomic, retain) NSArray* deals;
@property (nonatomic, retain) NSArray* beacons;
@property (nonatomic, retain) NSTimer* timer;

- (void)startMonitoring;
- (void)stopMonitoring;
    
@end
