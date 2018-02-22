//
//  FISEventsViewController.m
//  FindItSimple
//
//  Created by Jain R on 3/25/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import "FISEventsViewController.h"
#import "FISArticlesTableViewCell.h"
#import "FISEventInfoViewController.h"

@interface FISEventsViewController ()

@end

@implementation FISEventsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"icon_navigation_calendar"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(showCalendar:)] autorelease];

    self.rightBarButtonItem = self.navigationItem.rightBarButtonItem;

    self.calendar = [[[VRGCalendarView alloc] init] autorelease];
    self.calendar.delegate=self;
    self.calendar.frame = CGRectMake(0, -kVRGCalendarViewMaxHeight, kVRGCalendarViewWidth, self.calendar.frame.size.height);
    [self.view addSubview:self.calendar];
    self.calendar.hidden = YES;
    
    self.toolbar.backgroundColor = FISDefaultToolbarBackgroundColor();
    self.toolbar.center = CGPointMake(self.view.bounds.size.width / 2.0f, self.view.bounds.size.height + self.toolbar.frame.size.height / 2.0f);
    self.toolbar.hidden = YES;
    
    
    self.header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        
#ifdef TEST_CODE
        [self performSelector:@selector(reload:) withObject:refreshView afterDelay:2.0];
#else
        [self reload:refreshView];
#endif
        
        NSLog(@"%@----Begin Refreshing开始进入刷新状态", refreshView.class);
    };
    [self.header beginRefreshing];

    [FISAppDirectory setNeedToRefresh:NO key:@"eventsVC"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([FISAppDirectory isNeedToRefreshWith:@"eventsVC"] && self.listType!=FISListTypeSaved) {
        [self reload:nil];
    }
}

- (void)reload:(id)sender {
    [[FISAppLocker sharedLocker] lockAppWith:sender==nil];
    
    [FISAppDirectory setNeedToRefresh:NO key:@"eventsVC"];
    
    NSString* token = FISGetCurrentToken();
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    if (self.listType==FISListTypeDefault || self.listType==FISListTypeSearched || self.listType==FISListTypeSpecialCategory) {
        
        [parameters setObject:@"no" forKey:@"saved"];
        
        if (token.length!=0) {
            [parameters setObject:token forKey:@"token"];
        }
        
        if (self.listType==FISListTypeSpecialCategory)
            [parameters setObject:self.specialCategories forKey:@"categories"];
        else
            [parameters setObject:[FISAppDirectory getFavorites] forKey:@"categories"];
        
        [parameters setObject:[FISAppDirectory getCities] forKey:@"cities"];
        
        if (self.listType==FISListTypeSearched) {
            [parameters setObject:self.searchText forKey:@"search"];
        }
    }
    else if ( self.listType == FISListTypeSubgroup)
    {
        [parameters setObject:@"no" forKey:@"saved"];
        if (token.length!=0) {
            [parameters setObject:token forKey:@"token"];
        }
        if (_businessID != nil) {
            [parameters setObject:_businessID forKey:@"bus_id"];
        }
    }
    else {
        [parameters setObject:@"yes" forKey:@"saved"];
        if (token.length==0) {
#ifdef TEST_CODE
#warning you must log in
#endif
        }
        [parameters setObject:token forKey:@"token"];
    }
    
    // get deals
    [FISWebService sendAsynchronousCommand:ACTION_GET_EVENT_ALL parameters:parameters completionHandler:^(NSData *response, NSError *error) {
        NSLog(@"error:%@\n\nresponse:\n%@", error, response);
        if (error!=nil) {
            UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] autorelease];
            [alert show];
        }
        else {
            self.fisData = [NSMutableArray arrayWithArray:(NSArray*)response];
            self.originalData = self.fisData;
            [self.tableView reloadData];
        }
        [self.header endRefreshing];
        [[FISAppLocker sharedLocker] unlockApp];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSArray*)markedDates:(NSDate*)currentMonthDate {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:currentMonthDate];
    NSInteger currentYear = [components year];
    NSInteger currentMonth = [components month];
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    
    for (NSDictionary* event in self.originalData) {
        NSDate* begin = [FISAppDirectory dateWithDateString:[event objectForKey:@"begin_time"]];
        NSDate* end = [FISAppDirectory dateWithDateString:[event objectForKey:@"end_time"]];
        
        components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:begin]; // Get necessary date components
        
        NSInteger month = [components month]; //gives you month
        NSInteger day = [components day]; //gives you day
        NSInteger year = [components year]; // gives you year
        if (year==currentYear && month==currentMonth) {
            NSInteger numberOfDays = [FISAppDirectory daysBetweenDate:begin andDate:end];
            for (NSInteger d = day; d<(day+1+numberOfDays); d++) {
                [dic setValue:[NSNumber numberWithBool:YES] forKey:[NSString stringWithFormat:@"day%ld", (long)d]];
            }
        }
    }

    NSMutableArray* array = [NSMutableArray array];
    for (int i = 1; i<32; i++) {
        BOOL used = [[dic objectForKey:[NSString stringWithFormat:@"day%d", i]] boolValue];
        if (used) {
            [array addObject:[NSNumber numberWithInt:i]];
        }
    }
    
    return array;
}

#pragma mark - FISDealInfoViewControllerDelegate
- (void)saveDeal:(FISDealInfoViewController *)vc indexPath:(NSIndexPath *)indexPath saved:(BOOL)saved {
    NSMutableDictionary* deal = [NSMutableDictionary dictionaryWithDictionary:[self.fisData objectAtIndex:indexPath.section]];
    if (self.listType==FISListTypeSaved) {
        if (saved==NO) {
            [self.fisData removeObjectAtIndex:indexPath.section];
            if (self.fisData!=self.originalData) {
                NSString* dealId = [deal objectForKey:@"id"];
                for (NSDictionary* origdeal in self.originalData) {
                    NSString* origId = [origdeal objectForKey:@"id"];
                    if ([origId isEqualToString:dealId]) {
                        [self.originalData removeObject:origdeal];
                        break;
                    }
                }
            }
            if (vc)
                [vc goBack];
        }
        [FISAppDirectory setNeedToRefresh:YES key:@"eventsVC"];
    }
    else {
        [deal setObject:[vc.info objectForKey:@"own_save"] forKey:@"own_save"];
        [deal setObject:[vc.info objectForKey:@"saved_count"] forKey:@"saved_count"];
        [self.fisData replaceObjectAtIndex:indexPath.section withObject:deal];
    }
    [self.tableView reloadData];
}

#pragma mark - UIActions
- (void)showCalendar:(UIBarButtonItem*)sender {
    self.navigationItem.rightBarButtonItem.action = nil;
    
    self.tableView.userInteractionEnabled = NO;
    [self.calendar reset];
    [self todayButtonClicked:nil];
    
    [UIView animateWithDuration:0.35f animations:^{
        CGRect frame = self.calendar.frame;
        frame.origin.y = 0;
        self.calendar.frame = frame;
        self.calendar.hidden = NO;
        
        self.toolbar.center = CGPointMake(self.view.bounds.size.width / 2.0f, self.view.bounds.size.height - self.toolbar.frame.size.height / 2.0f);
        self.toolbar.hidden = NO;
        
    } completion:^(BOOL finished) {
    }];
}

- (void)hideCalendar {
    self.tableView.userInteractionEnabled = YES;
    
    self.navigationItem.rightBarButtonItem = self.rightBarButtonItem;
    [self.navigationItem.rightBarButtonItem setAction:nil];
    [UIView animateWithDuration:0.35f animations:^{
        CGRect frame = self.calendar.frame;
        frame.origin.y = -kVRGCalendarViewMaxHeight;
        self.calendar.frame = frame;
        
        self.toolbar.center = CGPointMake(self.view.bounds.size.width / 2.0f, self.view.bounds.size.height + self.toolbar.frame.size.height / 2.0f);
        
    } completion:^(BOOL finished) {
        [self.navigationItem.rightBarButtonItem setAction:@selector(showCalendar:)];
        self.calendar.hidden = YES;
        self.toolbar.hidden = YES;
    }];
    
}

- (IBAction)cancelButtonClicked:(id)sender {
    if (self.fisData!=self.originalData) {
        if ([self numberOfSectionsInTableView:self.tableView]) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
        self.fisData =self.originalData;
        self.pageIndex = 1;
        [self.tableView reloadData];
    }
    [self hideCalendar];
}

- (IBAction)todayButtonClicked:(id)sender {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
    NSInteger currentDay = [components day];
    [self.calendar selectDate:(int)currentDay];
}

- (IBAction)goButtonClicked:(id)sender {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self.calendar.selectedDate];
    NSInteger currentYear = [components year];
    NSInteger currentMonth = [components month];
    NSInteger currentDay = [components day];
    
    NSMutableArray* newData = [NSMutableArray array];
    
    for (NSDictionary* event in self.originalData) {
        NSDate* begin = [FISAppDirectory dateWithDateString:[event objectForKey:@"begin_time"]];
        NSDate* end = [FISAppDirectory dateWithDateString:[event objectForKey:@"end_time"]];
        
        components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:begin]; // Get necessary date components
        
        NSInteger month = [components month]; //gives you month
        NSInteger day = [components day]; //gives you day
        NSInteger year = [components year]; // gives you year
        if (year==currentYear && month==currentMonth) {
            NSInteger numberOfDays = [FISAppDirectory daysBetweenDate:begin andDate:end];
            if (currentDay>=day && currentDay<=(day+numberOfDays)) {
                [newData addObject:event];
            }
        }
    }
    
    if ([self numberOfSectionsInTableView:self.tableView]) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }

    self.fisData = newData;
    self.pageIndex = 1;
    
    [self.tableView reloadData];
    
    [self hideCalendar];
}

#pragma mark - UITableViewDelegate
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* cellIdentifier = [NSString stringWithFormat:@"cell%ld", (long)indexPath.section];
    
    FISArticlesTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell==nil) {
        cell = [[FISArticlesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSDictionary* event = [self.fisData objectAtIndex:indexPath.section];
    
    cell.fisTitleLabel.text = [event objectForKey:@"simple_title"];

    NSString* begin = FISAppendStringWithDate([event objectForKey:@"begin_time"]);
    NSString* end = FISAppendStringWithDate([event objectForKey:@"end_time"]);
    if ([begin isEqualToString:end]) {
        cell.fisDateLabel.text = begin;
    }
    else {
        cell.fisDateLabel.text = [begin stringByAppendingFormat:@" - \n%@", end];
        cell.fisDateLabel.font = [UIFont fontWithName:FISFONT_BOLD size:12];
        cell.fisDateLabel.numberOfLines = 2;
    }
    
    cell.fisSavedCountLabel.text = [event objectForKey:@"saved_count"];
    if (self.listType==FISListTypeDefault) {
        NSString* marktid = [event objectForKey:@"own_save"];
        NSString* dealid = [event objectForKey:@"id"];
        if ([dealid isEqualToString:marktid]) {
            cell.handPicked = YES;
        }
        else {
            cell.handPicked = NO;
        }
    }
    else if (self.listType==FISListTypeSaved) {
        BOOL delflag = [[event objectForKey:@"delflag"] boolValue];
        if (delflag) {
            cell.fisHandPickedImageView.image = [UIImage imageNamed:@"ribbon_deleted"];
            cell.handPicked = YES;
        }
        else
            cell.handPicked = NO;
    }
    else
        cell.handPicked = NO;
    
    NSString* pictureURL = [event objectForKey:@"picture"];
    
    if ([pictureURL isKindOfClass:[NSString class]]) {
        cell.imageURL = pictureURL;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[FISAppLocker sharedLocker] lockApp];

    NSDictionary* deal = [self.fisData objectAtIndex:indexPath.section];
    if (self.listType==FISListTypeSaved) {
        BOOL delflag = [[deal objectForKey:@"delflag"] boolValue];
        if (delflag) {
            UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:FISDefaultAlertTitle message:@"This event was deleted by business owner.\nDo you want to delete it from your saved list?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil] autorelease];
            alert.tag = indexPath.section;
            [[FISAppLocker sharedLocker] unlockApp];
            [alert show];
            return;
        }
    }
    NSString* dealId = [deal objectForKey:@"id"];
    
    NSString* token = FISGetCurrentToken();
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    if (token.length!=0) {
        [parameters setObject:token forKey:@"token"];
    }
    [parameters setObject:dealId forKey:@"id"];
    
    // get deal
    [FISWebService sendAsynchronousCommand:ACTION_GET_EVENT parameters:parameters completionHandler:^(NSData *response, NSError *error) {
        NSLog(@"error:%@\n\nresponse:\n%@", error, response);
        if (error!=nil) {
            NSRange range = [error.localizedDescription rangeOfString:MSG_ERR_VALUE];
            if (range.location != NSNotFound) {
                UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:@"This event might be deleted by business owner.\nPlease reload again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] autorelease];
                [alert show];
            }
            else {
                UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] autorelease];
                [alert show];
            }
        }
        else {
            FISDealInfoViewController* detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FISDealInfoViewController-568h"];
            detailViewController.info = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary*)response];
            detailViewController.type = FISInfoViewControllerTypeEvent;
            detailViewController.delegate = self;
            detailViewController.indexPath = indexPath;
            [self.navigationController pushViewController:detailViewController animated:YES];
        }
        [[FISAppLocker sharedLocker] unlockApp];
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex==1) {
        NSString* token = FISGetCurrentToken();
        if (token.length==0) {
            UIAlertView* alret = [[[UIAlertView alloc] initWithTitle:FISDefaultAlertTitle message:@"Please Sign in on Profile Page" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] autorelease];
            [alret show];
            return;
        }
        
        [[FISAppLocker sharedLocker] lockApp];
        
        NSString* marktype = nil;
        marktype = TYPE_EVENT;
        NSDictionary* deal = [self.fisData objectAtIndex:alertView.tag];
        NSString* markid = [deal objectForKey:@"id"];
        
        // remove saving
        [FISWebService sendAsynchronousCommand:ACTION_REMOVE_SAVING parameters:@{@"token": token, @"marktype": marktype, @"markid": markid} completionHandler:^(NSData *response, NSError *error) {
            NSLog(@"error:%@\n\nresponse:\n%@", error, response);
            if (error!=nil) {
                UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] autorelease];
                [alert show];
            }
            else {
                NSMutableDictionary* globalInfo = [NSMutableDictionary dictionaryWithDictionary:[FISAppDirectory getUserInfo]];
                int savedCount = 0;
                savedCount = [[globalInfo objectForKey:@"g_event_cnt"] intValue];
                savedCount--;
                [globalInfo setObject:[NSString stringWithFormat:@"%d", savedCount] forKey:@"g_event_cnt"];
                [FISAppDirectory setUserInfo:globalInfo];
                
                [self saveDeal:nil indexPath:[NSIndexPath indexPathForRow:0 inSection:alertView.tag] saved:NO];
            }
            [[FISAppLocker sharedLocker] unlockApp];
        }];
    }
}

#pragma mark - VRGCalendarViewDelegate

-(void)calendarView:(VRGCalendarView *)calendarView switchedToMonth:(int)month targetHeight:(float)targetHeight animated:(BOOL)animated {
//    NSLog(@"targetHeight %f", targetHeight);
    NSArray *dates = [self markedDates:calendarView.currentMonth];
    [calendarView markDates:dates];
//    CGRect frame = self.tableView.frame;
//    NSLog(@"table y %f", frame.origin.y);
//    frame.origin.y = targetHeight;
//    [UIView animateWithDuration:0.35f animations:^{
//        self.tableView.frame = frame;
//    }];
}

-(void)calendarView:(VRGCalendarView *)calendarView dateSelected:(NSDate *)date {
    NSLog(@"Selected date = %@",date);
}

- (void)dealloc {
    self.calendar = nil;
    [_toolbar release];
    [super dealloc];
}
@end
