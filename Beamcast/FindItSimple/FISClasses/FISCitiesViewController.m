//
//  FISCitiesViewController.m
//  FindItSimple
//
//  Created by Jain R on 10/27/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import "FISCitiesViewController.h"

@interface FISCitiesViewController ()

@end

@implementation FISCitiesViewController

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
    self.navigationItem.title = @"Select City";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont fontWithName:FISFONT_REGULAR size:15]}];
    
    self.citys = [FISAppDirectory cities];
    
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont fontWithName:FISFONT_BOLD size:FISFONT_NAVIGATION_TITLESIZE]}];
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

- (void)dealloc {
    [_tableView release];
    self.citys = nil;
    [super dealloc];
}

#pragma mark - UITableViewControllerDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.citys.count + 1;
    
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellId = @"CityCell";
    UITableViewCell* cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont fontWithName:FISFONT_REGULAR size:16];
    }
    
    UISwitch* fisSwitch = [[[UISwitch alloc] init] autorelease];
    NSInteger index = 0;

    if (indexPath.row == 0) {
        cell.textLabel.text = @"All";
        for (int i = 0; i < self.citys.count; i++) {
            if ([FISAppDirectory isUsedCity:i]) {
                fisSwitch.on = YES;
                break;
            }
        }
        index = 1000;
    }
    else {
        index = indexPath.row - 1;
        cell.textLabel.text = [self.citys objectAtIndex:index];
        fisSwitch.on = [FISAppDirectory isUsedCity:index];
    }
    
    [fisSwitch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    fisSwitch.tag = index;
    fisSwitch.onTintColor = FISDefaultBackgroundColor();
    cell.accessoryView = fisSwitch;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark - UIAction
- (IBAction)switchValueChanged:(UISwitch*)sender {
    if (sender.tag >= 1000) {
        for (int i = 0; i < self.citys.count; i++) {
            if (sender.on)
                [FISAppDirectory addCity:i];
            else
                [FISAppDirectory removeCity:i];
        }
    }
    else {
        if (sender.on)
            [FISAppDirectory addCity:sender.tag];
        else
            [FISAppDirectory removeCity:sender.tag];
    }
    
    [FISAppDirectory setNeedToRefresh:YES key:@"dealsVC"];
    [FISAppDirectory setNeedToRefresh:YES key:@"articlesVC"];
    [FISAppDirectory setNeedToRefresh:YES key:@"eventsVC"];
    [FISAppDirectory setNeedToRefresh:YES key:@"nearbyVC"];
    
    [self.tableView reloadData];
}

@end
