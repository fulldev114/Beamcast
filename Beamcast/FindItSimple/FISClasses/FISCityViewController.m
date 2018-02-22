//
//  FISCityViewController.m
//  FindItSimple
//
//  Created by Jain R on 4/17/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import "FISCityViewController.h"

@interface FISCityViewController ()

@end

@implementation FISCityViewController

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
    self.navigationItem.title = @"Change City";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont fontWithName:FISFONT_REGULAR size:15]}];
    
    self.citys = [FISAppDirectory cities];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.citys = nil;
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

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.citys.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellId = @"citycell";
    UITableViewCell* cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont fontWithName:FISFONT_REGULAR size:16];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.text = [self.citys objectAtIndex:indexPath.row];
    if ([cell.textLabel.text isEqualToString:[self.delegate currentCity]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[FISAppLocker sharedLocker] lockApp];
    // change city
    [FISWebService sendAsynchronousCommand:ACTION_USER_MOD parameters:@{@"token": FISGetCurrentToken(), @"city": [self.citys objectAtIndex:indexPath.row]} completionHandler:^(NSData *response, NSError *error) {
        NSLog(@"error:%@\n\nresponse:\n%@", error, response);
        if (error!=nil) {
            UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] autorelease];
            [alert show];
        }
        else {
            
            NSMutableDictionary* globalInfo = [NSMutableDictionary dictionaryWithDictionary:[FISAppDirectory getUserInfo]];
            [globalInfo setObject:[self.citys objectAtIndex:indexPath.row] forKey:@"g_city"];
            [FISAppDirectory setUserInfo:globalInfo];
            [FISAppDirectory setNeedToRefresh:YES key:@"nearbyVC"];

            if ([self.delegate respondsToSelector:@selector(cityChanged:)]) {
                [self.delegate cityChanged:[self.citys objectAtIndex:indexPath.row]];
                [self goBack];
            }
        }
        [[FISAppLocker sharedLocker] unlockApp];
    }];
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont fontWithName:FISFONT_BOLD size:FISFONT_NAVIGATION_TITLESIZE]}];
}

@end
