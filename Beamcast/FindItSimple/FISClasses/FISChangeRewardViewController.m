//
//  FISChangeRewardViewController.m
//  FindItSimple
//
//  Created by PKS on 3/20/15.
//  Copyright (c) 2015 Alex Hong. All rights reserved.
//

#import "FISChangeRewardViewController.h"
#import "FISChangeRewardTableCell.h"

@interface FISChangeRewardViewController ()

@end

@implementation FISChangeRewardViewController
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
    self.navigationItem.title = @"Change Reward";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    
    self.header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        [self reload:refreshView];
    };
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([FISAppDirectory isNeedToRefreshWith:@"eventsVC"] && self.listType!=FISListTypeSaved) {
        [self reload:nil];
    }
}

- (void)reload:(id)sender {
    [self.tableView reloadData];
    [self.header endRefreshing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.rewards count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* cellIdentifier = @"RewardCell";
    
    FISChangeRewardTableCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell==nil) {
        cell = [[FISChangeRewardTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSDictionary * reward = [self.rewards objectAtIndex:indexPath.section];
    
    cell.fisRewardTitle.text = [reward objectForKey:@"title"];
    cell.fisRewardPoint.text = [NSString stringWithFormat:@"%@ Points", [reward objectForKey:FIS_PARAM_BUSINESS_REWARD_POINT]];
    
    NSString* pictureURL = [reward objectForKey:@"picture"];
    
    if ([pictureURL isKindOfClass:[NSString class]]) {
        cell.imageURL = pictureURL;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate changeReward:indexPath.section];
    [self goBack];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont fontWithName:FISFONT_REGULAR size:15]}];
}

- (void)dealloc {
    [super dealloc];
}


@end
