//
//  FISMenuViewController.h
//  FindItSimple
//
//  Created by Jain R on 3/14/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FISNavigationController.h"
#import "MSDynamicsDrawerViewController.h"
#import "FISProfileViewController.h"
#import "FISSignViewController.h"
#import "FISSearchViewController.h"
#import "FISNearbyViewController.h"
#import "FISCategoriesViewController.h"

@interface FISMenuViewController : UIViewController<UITextFieldDelegate, FISSignViewControllerDelegate, FISProfileViewControllerDelegate, FISNearbyViewControllerDelegate>

@property (nonatomic, assign) UIViewController* paneViewController;
@property (nonatomic, assign) MSDynamicsDrawerViewController *dynamicsDrawerViewController;
@property (nonatomic, retain) NSMutableArray* viewControllers;
@property (nonatomic, retain) FISProfileViewController* profileViewController;
@property (nonatomic, retain) FISSignViewController* signInViewController;
@property (nonatomic, retain) FISSearchViewController* searchViewController;

- (void)transitionToViewController:(UIViewController*)paneViewController;
- (void)dynamicsDrawerRevealLeftBarButtonItemTapped:(id)sender;
- (void)dynamicsDrawerRevealRightBarButtonItemTapped:(id)sender;

@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UIView *contentView;
@property (retain, nonatomic) IBOutlet UIImageView *searchPlaceholder;
@property (retain, nonatomic) IBOutlet UITextField *searchbox;
@property (retain, nonatomic) IBOutlet UIImageView *photoView;
@property (retain, nonatomic) IBOutlet UIButton *nameButton;
@property (retain, nonatomic) IBOutlet UIButton *cityButton;
@property (retain, nonatomic) IBOutlet UILabel *savedLabel1;
@property (retain, nonatomic) IBOutlet UILabel *savedLabel2;
@property (retain, nonatomic) IBOutlet UILabel *savedLabel3;
@property (retain, nonatomic) IBOutlet UIButton *profileButton;


- (IBAction)photoDidClicked:(UIButton *)sender;
- (IBAction)menuDidClicked:(UIButton *)sender;
- (IBAction)savedDidClicked:(UIButton *)sender;
- (IBAction)nameDidClicked:(UIButton *)sender;
- (IBAction)cityDidClicked:(UIButton *)sender;
- (IBAction)textFieldBeginEdit:(id)sender;
- (IBAction)textFieldEndEdit:(id)sender;
- (IBAction)hideKeyboard:(id)sender;
@end
