//
//  FISSearchViewController.m
//  FindItSimple
//
//  Created by Jain R on 4/29/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import "FISSearchViewController.h"
#import "FISBaseListViewController.h"

@interface FISSearchViewController ()

@end

@implementation FISSearchViewController

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
    CGRect frame = self.view.frame;
    frame.size.height -= 64;
    self.view.frame = frame;

    FISBaseListViewController* viewController = nil;
    NSMutableArray* viewControllers = [NSMutableArray array];
    
    viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FISDealsViewController-568h"];
    viewController.title = @"DEALS";
    viewController.listType = FISListTypeSearched;
    viewController.searchText = self.searchText;
    [viewControllers addObject:viewController];
    
    viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FISArticlesViewController-568h"];
    viewController.title = @"FYI";
    viewController.listType = FISListTypeSearched;
    viewController.searchText = self.searchText;
    [viewControllers addObject:viewController];
    
    viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FISEventsViewController-568h"];
    viewController.title = @"EVENTS";
    viewController.listType = FISListTypeSearched;
    viewController.searchText = self.searchText;
    [viewControllers addObject:viewController];
    
    [self setViewControllers:viewControllers];
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
    self.searchText = nil;
    [super dealloc];
}

@end
