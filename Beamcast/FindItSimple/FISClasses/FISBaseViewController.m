//
//  FISBaseViewController.m
//  FindItSimple
//
//  Created by Jain R on 3/14/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import "FISBaseViewController.h"

@interface FISBaseViewController ()

@end

@implementation FISBaseViewController

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
    
    // set background color
    self.view.backgroundColor = UIColorWithRGBA(240, 240, 240, 1);

    // set navigation bar color
//    self.navigationController.navigationBar.translucent = NO;
//    self.navigationController.navigationBar.barTintColor = FISDefaultBackgroundColor();
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setFont:[UIFont fontWithName:FISFONT_REGULAR size:14]];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTintColor:FISDefaultBackgroundColor()];
}

//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleLightContent;
//}

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

@end
