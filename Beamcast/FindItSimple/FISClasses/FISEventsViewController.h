//
//  FISEventsViewController.h
//  FindItSimple
//
//  Created by Jain R on 3/25/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FISBaseViewController.h"
#import "FISBaseListViewController.h"
#import "VRGCalendarView.h"
#import "FISDealInfoViewController.h"

@interface FISEventsViewController : FISBaseListViewController <VRGCalendarViewDelegate, UITableViewDataSource, UITableViewDelegate, FISDealInfoViewControllerDelegate, UIAlertViewDelegate>

@property (retain, nonatomic) VRGCalendarView* calendar;
@property (retain, nonatomic) IBOutlet UIView *toolbar;
@property(nonatomic, retain) NSString * businessID;
- (IBAction)cancelButtonClicked:(id)sender;
- (IBAction)todayButtonClicked:(id)sender;
- (IBAction)goButtonClicked:(id)sender;

@end
