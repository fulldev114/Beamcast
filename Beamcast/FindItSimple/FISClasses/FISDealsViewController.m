//
//  FISDealsViewController.m
//  FindItSimple
//
//  Created by Jain R on 3/18/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//
#import "FISAppDelegate.h"
#import "FISDealsViewController.h"
#import "FISDealsTableViewCell.h"
#import "DLRadioButton.h"
#import "BFPaperCheckbox.h"
#import "UIColor+BFPaperColors.h"
#import "DXPopover.h"


@interface FISDealsViewController ()

@property (nonatomic, retain) BFPaperCheckbox* hideUsedCheckBox;
@property (nonatomic, retain) DXPopover *popover;
@property (nonatomic, retain) UIView* sortViewContainer;
@property (nonatomic, retain) NSMutableArray* rawData;

@end

@implementation FISDealsViewController

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
    
    // Config sort view for coupon
    if (self.dealListType == FISDealsViewControllerTypeCoupon)
    {
        UIView* sortView = [[[UIView alloc] initWithFrame:CGRectMake(10, 10, 220, 150)] autorelease];
        sortView.backgroundColor = FISDefaultBackgroundColor();
        
        float x = 10;
        float y = 20;
        UIColor* titleColor = [UIColor whiteColor];
        
        DLRadioButton *firstRadioButton = [[[DLRadioButton alloc] initWithFrame:CGRectMake(x, y, 200, 30)] autorelease];
        firstRadioButton.buttonSideLength = 30;
        [firstRadioButton setTitle:@"From Newest to Oldest" forState:UIControlStateNormal];
        [firstRadioButton setTitleColor:titleColor forState:UIControlStateNormal];
        firstRadioButton.titleLabel.font = [UIFont fontWithName:FISFONT_REGULAR size:14];
        firstRadioButton.circleColor = titleColor;
        firstRadioButton.indicatorColor = titleColor;
        firstRadioButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        firstRadioButton.tag = 1001;
        firstRadioButton.selected = YES;
        [firstRadioButton addTarget:self action:@selector(sortButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        // add other buttons
        [sortView addSubview:firstRadioButton];
        
        NSMutableArray *otherButtons = [[NSMutableArray new] autorelease];

        DLRadioButton *radioButton = [[[DLRadioButton alloc] initWithFrame:CGRectMake(x, y+40, 200, 30)] autorelease];
        radioButton.buttonSideLength = 30;
        [radioButton setTitle:@"Order Expire Date" forState:UIControlStateNormal];
        [radioButton setTitleColor:titleColor forState:UIControlStateNormal];
        radioButton.titleLabel.font = [UIFont fontWithName:FISFONT_REGULAR size:14];
        radioButton.circleColor = titleColor;
        radioButton.indicatorColor = titleColor;
        radioButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        radioButton.tag = 1002;
        [radioButton addTarget:self action:@selector(sortButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [otherButtons addObject:radioButton];
        [sortView addSubview:radioButton];
        
        firstRadioButton.otherButtons = otherButtons;
        
        BFPaperCheckbox* paperCheckbox = [[[BFPaperCheckbox alloc] initWithFrame:CGRectMake(x, y+80, 30, 30)] autorelease];
//        paperCheckbox.center = CGPointMake(self.paperCheckbox.center.x, self.paperCheckbox2.frame.origin.y);
        paperCheckbox.tag = 1002;
        paperCheckbox.delegate = self;
        paperCheckbox.rippleFromTapLocation = YES;
        paperCheckbox.tapCirclePositiveColor = [[UIColor paperColorAmber] colorWithAlphaComponent:0]; // We could use [UIColor colorWithAlphaComponent] here to make a better tap-circle.
        paperCheckbox.tapCircleNegativeColor = [[UIColor paperColorRed] colorWithAlphaComponent:0];   // We could use [UIColor colorWithAlphaComponent] here to make a better tap-circle.
        paperCheckbox.checkmarkColor = titleColor;
        paperCheckbox.tintColor = titleColor;
//        [paperCheckbox checkAnimated:NO];
        [sortView addSubview:paperCheckbox];
        self.hideUsedCheckBox = paperCheckbox;
        
        // Set up second checkbox label:
        UILabel* paperCheckboxLabel = [[[UILabel alloc] initWithFrame:CGRectMake(45, 0, 200, 31)] autorelease];
        paperCheckboxLabel.text = @"Hide Used Coupons";
        paperCheckboxLabel.backgroundColor = [UIColor clearColor];
        paperCheckboxLabel.center = CGPointMake(paperCheckboxLabel.center.x, paperCheckbox.center.y);
        paperCheckboxLabel.font = [UIFont fontWithName:FISFONT_REGULAR size:14];
        paperCheckboxLabel.textColor = titleColor;
        [sortView addSubview:paperCheckboxLabel];
        
        UIButton* button = [[[UIButton alloc] initWithFrame:paperCheckboxLabel.frame] autorelease];
        button.tag = 1003;
        [button addTarget:self action:@selector(sortButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [sortView addSubview:button];

//        [self.view addSubview:sortView];

        self.popover = [[DXPopover new] autorelease];
        self.sortViewContainer = sortView;
//        sortView.hidden = YES;
        
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_navigation_sort"] style:UIBarButtonItemStylePlain target:self action:@selector(showPopover)] autorelease];
        self.rightBarButtonItem = self.navigationItem.rightBarButtonItem;
    }
    
    if (self.dealListType == FISDealsViewControllerTypeReward) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_navigation_reward"] style:UIBarButtonItemStylePlain target:self action:@selector(goGetPoints)];
    }
    
    self.header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        
#ifdef TEST_CODE
        [self performSelector:@selector(reload:) withObject:refreshView afterDelay:2.0];
#else
        [self reload:refreshView];
#endif
        
        NSLog(@"%@----Begin Refreshing开始进入刷新状态", refreshView.class);
    };
    [self.header beginRefreshing];

    [FISAppDirectory setNeedToRefresh:NO key:@"dealsVC"];
    
    // add refresh notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload:) name:FISNOTIFICATION_REFRESH_DEALSVC object:nil];
}

#pragma mark - BFPaperCheckbox Delegate
- (void)paperCheckboxChangedState:(BFPaperCheckbox *)checkbox
{
    [FISAppDirectory setHideUsed:checkbox.isChecked];
    
    [self sortOrderChanged];
}

- (void)sortButtonTapped:(UIButton*)button {
    if (button.tag == 1001) {
        [FISAppDirectory setSortOrder:FISSortOrderTypeFromNewest];
    }
    else if (button.tag == 1002) {
        [FISAppDirectory setSortOrder:FISSortOrderTypeExpireDate];
    }
    else if (button.tag == 1003) {
        [self.hideUsedCheckBox switchStatesAnimated:YES];
        return;
    }

    [self sortOrderChanged];
}

- (void)sortOrderChanged {
    [[FISAppLocker sharedLocker] lockAppWith:NO];
    
    [FISAppDirectory setNeedToRefresh:NO key:@"dealsVC"];
    
    if ([self numberOfSectionsInTableView:self.tableView]) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.originalData = [self sortCoupons:self.rawData];
        self.fisData = self.originalData;
        self.pageIndex = 1;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [[FISAppLocker sharedLocker] unlockApp];
        });
    });
}

- (void)showPopover {
    FISSortOrderType sortOrder = [FISAppDirectory sortOrder];
    UIButton* button = nil;

    if (sortOrder == FISSortOrderTypeFromNewest) {
        button = (UIButton*)[self.sortViewContainer viewWithTag:1001];
        button.selected = YES;
        button = (UIButton*)[self.sortViewContainer viewWithTag:1002];
        button.selected = NO;
    }
    else {
        button = (UIButton*)[self.sortViewContainer viewWithTag:1001];
        button.selected = NO;
        button = (UIButton*)[self.sortViewContainer viewWithTag:1002];
        button.selected = YES;
    }
    
    self.hideUsedCheckBox.delegate = nil;
    
    [self.hideUsedCheckBox switchStatesAnimated:NO];
    
    if ([FISAppDirectory isHideUsed]) {
        [self.hideUsedCheckBox checkAnimated:NO];
    }
    else {
        [self.hideUsedCheckBox uncheckAnimated:NO];
    }
    
    self.hideUsedCheckBox.delegate = self;
    
    CGPoint startPoint = CGPointMake(290, 0);
    [self.popover showAtPoint:startPoint popoverPostion:DXPopoverPositionDown withContentView:self.sortViewContainer inView:self.view];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([FISAppDirectory isNeedToRefreshWith:@"dealsVC"] && self.listType!=FISListTypeSaved) {
        [self reload:nil];
    }
}

- (NSMutableArray*)sortCoupons:(NSArray*)coupons {

    NSMutableArray* sortedArray = [NSMutableArray array];
    
    if (self.dealListType != FISDealsViewControllerTypeCoupon) {
        return sortedArray;
    }
    
    FISSortOrderType sortOrder = [FISAppDirectory sortOrder];
    BOOL hideUsed = [FISAppDirectory isHideUsed];
    
    for (NSDictionary* coupon in coupons) {
        
        if (hideUsed) {
            BOOL used = [[coupon objectForKey:@"used"] boolValue];
            if (used) {
                continue;
            }
        }
        
        int i = 0;
        BOOL isFound = NO;
        
        for (i = 0; i < sortedArray.count; i++) {

            NSDictionary* coupon2 = [sortedArray objectAtIndex:i];
            //compare two coupons
            if (sortOrder == FISSortOrderTypeFromNewest) {
                NSInteger id1 = [[coupon objectForKey:@"coupon_id"] integerValue];
                NSInteger id2 = [[coupon2 objectForKey:@"coupon_id"] integerValue];
                if (id1 >= id2) {
                    isFound = YES;
                }
            }
            else {
                NSDate* date1 = [FISAppDirectory dateWithDateString:[coupon objectForKey:@"expire_date"]];
                NSDate* date2 = [FISAppDirectory dateWithDateString:[coupon2 objectForKey:@"expire_date"]];
                NSInteger days = [FISAppDirectory daysBetweenDate:date1 andDate:date2];
                if (days >= 0) {
                    isFound = YES;
                }
            }
            
            if (isFound) {
                break;
            }
        }
        
        if (isFound) {
            [sortedArray insertObject:coupon atIndex:i];
        }
        else {
            [sortedArray addObject:coupon];
        }
        
    }
    
    return sortedArray;
}

- (void)reload:(id)sender {
    [[FISAppLocker sharedLocker] lockAppWith:sender==nil];
    
    [FISAppDirectory setNeedToRefresh:NO key:@"dealsVC"];
    
    NSString* token = FISGetCurrentToken();
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    if (self.listType==FISListTypeDefault || self.listType==FISListTypeSearched || self.listType==FISListTypeSpecialCategory) {

        if (self.dealListType != FISDealsViewControllerTypeCoupon) {
            [parameters setObject:@"no" forKey:@"saved"];
        }

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
    
    NSString* fisAction = ACTION_GET_DEAL_ALL;
    if (self.dealListType == FISDealsViewControllerTypeCoupon) {
        fisAction = ACTION_GET_COUPON_ALL;
    } else if (self.dealListType == FISDealsViewControllerTypeReward) {
        if (token.length==0) {
            FISNeedSignInAlert();
            [[FISAppLocker sharedLocker] unlockApp];
            return;
        }
        fisAction = ACTION_GET_BUSINESS_FOR_REWARD_ALL;
        if (![parameters objectForKey:@"token"]) {
            [parameters setObject:token forKey:@"token"];
        }
    }
    
    // get deals
    [FISWebService sendAsynchronousCommand:fisAction parameters:parameters completionHandler:^(NSData *response, NSError *error) {
        NSLog(@"error:%@\n\nresponse:\n%@", error, response);
        if (error!=nil) {
            UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] autorelease];
            [alert show];
        }
        else {
            self.rawData = [NSMutableArray arrayWithArray:(NSArray*)response];
            if (self.dealListType == FISDealsViewControllerTypeCoupon) {
                self.originalData = [self sortCoupons:self.rawData];
                self.fisData = self.originalData;
            }
            else {
                self.originalData = self.rawData;
                self.fisData = self.originalData;
            }
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
        [FISAppDirectory setNeedToRefresh:YES key:@"dealsVC"];
    }
    else {
        [deal setObject:[vc.info objectForKey:@"own_save"] forKey:@"own_save"];
        [deal setObject:[vc.info objectForKey:@"saved_count"] forKey:@"saved_count"];
        [self.fisData replaceObjectAtIndex:indexPath.section withObject:deal];
    }
    [self.tableView reloadData];
}

- (void)useCoupon:(FISDealInfoViewController *)vc indexPath:(NSIndexPath *)indexPath {

    NSMutableDictionary* deal = [NSMutableDictionary dictionaryWithDictionary:[self.fisData objectAtIndex:indexPath.section]];

    if (self.listType==FISListTypeSaved) {
    }
    else {
        [deal setObject:[NSNumber numberWithBool:YES] forKey:@"used"];
        [self.fisData replaceObjectAtIndex:indexPath.section withObject:deal];
    }
    [self.tableView reloadData];
    
}

#pragma mark - UITableViewDelegate

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString* cellIdentifier = [NSString stringWithFormat:@"cell%ld", (long)indexPath.section];
    
    FISDealsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (cell==nil) {
        cell = [[FISDealsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        if (self.dealListType == FISDealsViewControllerTypeCoupon) {
            cell.cellType = FISDealsTableViewCellTypeCoupon;
            
        }
    }
    
    NSDictionary* deal = [self.fisData objectAtIndex:indexPath.section];
    
    if (self.dealListType == FISDealsViewControllerTypeCoupon) {

        cell.fisTitleLabel.text = [deal objectForKey:@"coupon_title"];
        NSString* businessTitle = [deal objectForKey:@"business_simple_title"];
        if ([businessTitle isKindOfClass:[NSString class]]) {
            cell.fisBusinessLabel.text = businessTitle;
        }
        else {
            cell.fisBusinessLabel.text = @"unknown";
        }
        
        cell.fisNewPriceLabel.text = [NSString stringWithFormat:@"Save %@", FISAppendStringWithDollar([deal objectForKey:@"coupon_price"])];
        
        NSString* dateString = [deal objectForKey:@"expire_date"];
        cell.fisSavedCountLabel.text = FISAppendStringWithDate(dateString);;
        
        if (self.listType==FISListTypeSpecialCategory) {
            BOOL used = [[deal objectForKey:@"used"] boolValue];
            if (used) {
                cell.handPicked = YES;
            }
            else {
                cell.handPicked = NO;
            }
            
            NSDate* expireDate = [FISAppDirectory dateWithDateString:dateString];
            NSInteger days = [FISAppDirectory daysBetweenDate:[NSDate date] andDate:expireDate];
            if (days >= 0 && days < 1) {
                cell.expireToday = YES;
            }
            else {
                cell.expireToday = NO;
            }
            
        }
        else if (self.listType==FISListTypeSaved) {
            BOOL delflag = [[deal objectForKey:@"delflag"] boolValue];
            if (delflag) {
                cell.fisHandPickedImageView.image = [UIImage imageNamed:@"ribbon_deleted"];
                cell.handPicked = YES;
            }
            else
                cell.handPicked = NO;
        }
        else {
            cell.handPicked = NO;
            cell.expireToday = NO;
        }
        
        NSString* pictureURL = [deal objectForKey:@"coupon_picture"];
        
        if ([pictureURL isKindOfClass:[NSString class]]) {
            cell.imageURL = pictureURL;
        }
        
    }
    else if (self.dealListType == FISDealsViewControllerTypeReward) {
        cell.fisTitleLabel.text = [deal objectForKey:FIS_PARAM_BUSINESS_NAME];
        NSString* pictureURL = [deal objectForKey:FIS_PARAM_BUSINESS_PICTURE];
        
        if ([pictureURL isKindOfClass:[NSString class]]) {
            cell.imageURL = pictureURL;
        }
        
        cell.fisNewPriceLabel.text = [NSString stringWithFormat:@"%@ Points", [deal objectForKey:FIS_PARAM_BUSINESS_USER_POINTS]];
        cell.fisSavedCountLabel.text = [deal objectForKey:FIS_PARAM_BUSINESS_REWARD_COUNT];
        cell.fisSavedTitleLabel.text = @"Reward";
    }
    else {

        cell.fisTitleLabel.text = [deal objectForKey:@"simple_title"];
        NSString* businessTitle = [deal objectForKey:@"business"];
        if ([businessTitle isKindOfClass:[NSString class]]) {
            cell.fisBusinessLabel.text = businessTitle;
        }
        else {
            cell.fisBusinessLabel.text = @"unknown";
        }
        
        cell.fisOriginalPriceLabel.text  = FISAppendStringWithDollar([deal objectForKey:@"orig_price"]);
        cell.fisNewPriceLabel.text = FISAppendStringWithDollar([deal objectForKey:@"new_price"]);
        cell.fisSavedCountLabel.text = [deal objectForKey:@"saved_count"];
        
        if (self.listType==FISListTypeDefault) {
            NSString* marktid = [deal objectForKey:@"own_save"];
            NSString* dealid = [deal objectForKey:@"id"];
            if ([dealid isEqualToString:marktid]) {
                cell.handPicked = YES;
            }
            else {
                cell.handPicked = NO;
            }
        }
        else if (self.listType==FISListTypeSaved) {
            BOOL delflag = [[deal objectForKey:@"delflag"] boolValue];
            if (delflag) {
                cell.fisHandPickedImageView.image = [UIImage imageNamed:@"ribbon_deleted"];
                cell.handPicked = YES;
            }
            else
                cell.handPicked = NO;
        }
        else
            cell.handPicked = NO;
        
        NSString* pictureURL = [deal objectForKey:@"picture"];
        
        if ([pictureURL isKindOfClass:[NSString class]]) {
            cell.imageURL = pictureURL;
        }
        
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[FISAppLocker sharedLocker] lockApp];

    if (self.dealListType == FISDealsViewControllerTypeCoupon) {
        
        NSDictionary* coupon = [self.fisData objectAtIndex:indexPath.section];
        NSString* couponId = [coupon objectForKey:@"coupon_id"];
        
        NSString* token = FISGetCurrentToken();
        
        NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
        if (token.length!=0) {
            [parameters setObject:token forKey:@"token"];
        }
        [parameters setObject:couponId forKey:@"id"];
        
        // get deal
        [FISWebService sendAsynchronousCommand:ACTION_GET_COUPON parameters:parameters completionHandler:^(NSData *response, NSError *error) {
            NSLog(@"error:%@\n\nresponse:\n%@", error, response);
            if (error!=nil) {
                NSRange range = [error.localizedDescription rangeOfString:MSG_ERR_VALUE];
                if (range.location != NSNotFound) {
                    UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:@"This deal might be deleted by business owner.\nPlease reload again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] autorelease];
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
                detailViewController.type = FISInfoViewControllerTypeCoupon;
                detailViewController.delegate = self;
                detailViewController.indexPath = indexPath;
                [self.navigationController pushViewController:detailViewController animated:YES];
            }
            
            [[FISAppLocker sharedLocker] unlockApp];
        }];

        return;
    } else if (self.dealListType == FISDealsViewControllerTypeReward) {
        NSDictionary* deal = [self.fisData objectAtIndex:indexPath.section];
        NSString* business_id = [deal objectForKey:FIS_PARAM_BUSINESS_ID];
        
        NSString* token = FISGetCurrentToken();
        
        NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
        if (token.length!=0) {
            [parameters setObject:token forKey:@"token"];
        }
        NSInteger points = [[deal objectForKey:FIS_PARAM_BUSINESS_USER_POINTS] integerValue];
        if (business_id.length != 0) {
            [parameters setObject:business_id forKey:@"bus_id"];
        }
        NSString * fisAction = ACTION_GET_REWARDS_ALL;
        // get rewards all
        [FISWebService sendAsynchronousCommand:fisAction parameters:parameters completionHandler:^(NSData *response, NSError *error) {
            NSLog(@"error:%@\n\nresponse:\n%@", error, response);
            if (error!=nil) {
                NSRange range = [error.localizedDescription rangeOfString:MSG_ERR_VALUE];
                if (range.location != NSNotFound) {
                    UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:@"There is no any rewards in thie business." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] autorelease];
                    [alert show];
                }
                else {
                    UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] autorelease];
                    [alert show];
                }
            }
            else {
                FISDealInfoViewController* detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FISDealInfoViewController-568h"];
                detailViewController.rewards = [NSArray arrayWithArray:(NSArray *)response];
                if ([detailViewController.rewards count] != 0) {                                        [[FISAppLocker sharedLocker] unlockApp];
                    
                    detailViewController.info = [detailViewController.rewards firstObject];
                    detailViewController.type = FISInfoViewControllerTypeReward;
                    detailViewController.nUserPointsForBusiness = points;
                    detailViewController.businessID = business_id;
                    detailViewController.delegate = self;
                    detailViewController.indexPath = indexPath;
                    [self.navigationController pushViewController:detailViewController animated:YES];
                }
            }
            
            [[FISAppLocker sharedLocker] unlockApp];
        }];
        return;
    }
        
    
    NSDictionary* deal = [self.fisData objectAtIndex:indexPath.section];
    if (self.listType==FISListTypeSaved) {
        BOOL delflag = [[deal objectForKey:@"delflag"] boolValue];
        if (delflag) {
            UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:FISDefaultAlertTitle message:@"This deal was deleted by business owner.\nDo you want to delete it from your saved list?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil] autorelease];
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
    [FISWebService sendAsynchronousCommand:ACTION_GET_DEAL parameters:parameters completionHandler:^(NSData *response, NSError *error) {
        NSLog(@"error:%@\n\nresponse:\n%@", error, response);
        if (error!=nil) {
            NSRange range = [error.localizedDescription rangeOfString:MSG_ERR_VALUE];
            if (range.location != NSNotFound) {
                UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:@"This deal might be deleted by business owner.\nPlease reload again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] autorelease];
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
            detailViewController.type = FISInfoViewControllerTypeDeal;
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
        marktype = TYPE_DEAL;
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
                savedCount = [[globalInfo objectForKey:@"g_deal_cnt"] intValue];
                savedCount--;
                [globalInfo setObject:[NSString stringWithFormat:@"%d", savedCount] forKey:@"g_deal_cnt"];
                [FISAppDirectory setUserInfo:globalInfo];
                
                [self saveDeal:nil indexPath:[NSIndexPath indexPathForRow:0 inSection:alertView.tag] saved:NO];
            }
            [[FISAppLocker sharedLocker] unlockApp];
        }];
    }
}

#pragma get points 
-(void)goGetPoints {
    FISAppDelegate* appDelegate = (FISAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSArray * detectedBeacons = [BeaconTracker sharedBeaconTracker].detectedBeacons;
    
    if ([detectedBeacons count] < 1) {
        FISNoValidBeaconAlert()
    }
    
    NSMutableArray * beacons = [NSMutableArray array];
    
    for (CLBeacon* detectedBeacon in detectedBeacons) {
        [beacons addObject:[NSArray arrayWithObjects:[NSNumber numberWithInteger:detectedBeacon.major.integerValue], [NSNumber numberWithInteger:detectedBeacon.minor.integerValue], nil]];
    }
    [[FISAppLocker sharedLocker] lockApp];
    [appDelegate processToGetPoints:beacons from:FIS_CALL_GET_POINTS_FROM_DEAL_INFO_VC];
}

-(void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
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



@end
