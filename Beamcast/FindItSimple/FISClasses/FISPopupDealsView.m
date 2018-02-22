//
//  FISPopupDealsView.m
//  FindItSimple
//
//  Created by Jain R on 5/2/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import "FISPopupDealsView.h"
#import "FISPopupTableViewCell.h"
#import "BeaconTracker.h"

@implementation FISPopupDealsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)startMonitoring {
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(setNeedReload) userInfo:nil repeats:YES];
    [self relayoutViews];
}

- (void)stopMonitoring {
    [self.timer invalidate];
    self.timer = nil;
    [self relayoutViews];
}

- (void)relayoutViews {
    float sh = 568;
    if (!IS_4INCH()) {
        sh = 480;
    }
    
    self.beacons = [BeaconTracker sharedBeaconTracker].detectedBeacons;
    
    if (self.beacons.count==0) {
        self.frame = CGRectMake(0, sh-64-0, 320, 0);
        self.deals = nil;
        [self reloadData];
        return;
    }
    
//    [[FISAppLocker sharedLocker] lockApp];

    NSMutableArray* beacons = [NSMutableArray array];
    for (CLBeacon* beacon in self.beacons) {
        NSInteger major1 = beacon.major.integerValue;
        NSInteger minor1 = beacon.minor.integerValue;
        [beacons addObject:[NSArray arrayWithObjects:[NSNumber numberWithInteger:major1], [NSNumber numberWithInteger:minor1], nil]];
    }
    
    // refresh self.deals
    NSString* token = FISGetCurrentToken();
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters setObject:beacons forKey:@"beacons"];
    if (token.length!=0) {
        [parameters setObject:token forKey:@"token"];
    }
    [parameters setObject:[FISAppDirectory getFavorites] forKey:@"categories"];
    [parameters setObject:[FISAppDirectory getCities] forKey:@"cities"];
    
    // get popups
    [FISWebService sendAsynchronousCommand:ACTION_GET_POPUPS parameters:parameters completionHandler:^(NSData *response, NSError *error) {
        NSLog(@"error:%@\n\nresponse:\n%@", error, response);
        if (error!=nil) {
            UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] autorelease];
            [alert show];
            self.deals = nil;
        }
        else {
            self.deals = [NSMutableArray arrayWithArray:(NSArray*)response];
            float CELLHEIGHT = 61;
            float CELLCOUNT = 4;
            
            float tableH = self.deals.count*CELLHEIGHT;
            if (tableH>(CELLHEIGHT*CELLCOUNT)) {
                tableH = CELLHEIGHT*CELLCOUNT;
            }
            CGRect frame = CGRectMake(0, sh-64-tableH, 320, tableH);
            self.frame = frame;
        }
        [self reloadData];
//        [[FISAppLocker sharedLocker] unlockApp];
    }];

}

- (void)dealloc {
    self.deals = nil;
    self.beacons = nil;
    [self.timer invalidate];
    self.timer = nil;
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setNeedReload {
//    _isNeedReLoad = YES;
    [self relayoutViews];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.deals.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellid = @"FISPopupTableViewCell";
    FISPopupTableViewCell* cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:cellid];

    NSDictionary* deal = [self.deals objectAtIndex:indexPath.row];
    
    cell.fisTitleLabel.text = [deal objectForKey:@"simple_title"];
    NSString* pictureURL = [deal objectForKey:@"picture"];
    
    if ([pictureURL isKindOfClass:[NSString class]]) {
        [cell.fisImageView setURLWith:pictureURL];
    }
    
    NSString *type = [deal objectForKey:@"type"];
    if ([type isEqualToString:TYPE_DEAL])
        cell.fisBackgroundView.image = [UIImage imageNamed:@"popupcell_background1"];
    else
        cell.fisBackgroundView.image = [UIImage imageNamed:@"popupcell_background2"];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[FISAppLocker sharedLocker] lockApp];

    NSDictionary* deal = [self.deals objectAtIndex:indexPath.row];
    NSString* dealId = [deal objectForKey:@"id"];
    
    NSString* token = FISGetCurrentToken();
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    if (token.length!=0) {
        [parameters setObject:token forKey:@"token"];
    }
    [parameters setObject:dealId forKey:@"id"];
    
    NSString *dealType = [deal objectForKey:@"type"];
    NSString *action = ACTION_GET_DEAL;
    
    if ([dealType isEqualToString:TYPE_EVENT])
        action = ACTION_GET_EVENT;
        
    // get deal
    [FISWebService sendAsynchronousCommand:action parameters:parameters completionHandler:^(NSData *response, NSError *error) {
        NSLog(@"error:%@\n\nresponse:\n%@", error, response);
        if (error!=nil) {
            UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] autorelease];
            [alert show];
        }
        else {
            FISDealInfoViewController* detailViewController = [[self viewController].storyboard instantiateViewControllerWithIdentifier:@"FISDealInfoViewController-568h"];
            detailViewController.info = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary*)response];
            if ([dealType isEqualToString:TYPE_DEAL])
                detailViewController.type = FISInfoViewControllerTypeDeal;
            else
                detailViewController.type = FISInfoViewControllerTypeEvent;
            detailViewController.delegate = self;
            detailViewController.indexPath = indexPath;
            [[self viewController].navigationController pushViewController:detailViewController animated:YES];
        }
        [[FISAppLocker sharedLocker] unlockApp];
    }];
    
}

- (void)saveDeal:(FISDealInfoViewController *)vc indexPath:(NSIndexPath *)indexPath saved:(BOOL)saved {
    if (vc.type == FISInfoViewControllerTypeDeal)
        [FISAppDirectory setNeedToRefresh:YES key:@"dealsVC"];
    else
        [FISAppDirectory setNeedToRefresh:YES key:@"eventsVC"];
}

- (UIViewController*)viewController
{
    for (UIView* next = [self superview]; next; next = next.superview)
    {
        UIResponder* nextResponder = [next nextResponder];
        
        if ([nextResponder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController*)nextResponder;
        }
    }
    
    return nil;
}

@end
