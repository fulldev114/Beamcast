//
//  FISRootViewController.m
//  FindItSimple
//
//  Created by Jain R on 5/4/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import "FISRootViewController.h"

@interface FISRootViewController ()

@end

@implementation FISRootViewController

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
    self.lockBackgroundView.backgroundColor = UIColorWithRGBA(0, 0, 0, 0.0f);
    self.lockAnimationContainerView.backgroundColor = UIColorWithRGBA(19, 19, 19, 1);
    self.lockLabel.textColor = UIColorWithRGBA(255, 255, 255, 1);
    self.lockLabel.font = [UIFont fontWithName:FISFONT_SEMIBOLD size:12];
    self.lockAnimationContainerView.layer.cornerRadius = 5.0f;
    self.lockAnimationContainerView.layer.masksToBounds = YES;
    
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
    [_lockBackgroundView release];
    [_lockAnimationContainerView release];
    [_lockIndicator release];
    [_lockLabel release];
    [super dealloc];
}
@end
