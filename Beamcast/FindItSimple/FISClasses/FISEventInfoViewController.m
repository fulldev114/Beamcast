//
//  FISEventInfoViewController.m
//  FindItSimple
//
//  Created by Jain R on 3/25/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import "FISEventInfoViewController.h"
#import "FISBusinessSummaryView.h"
#import "FISArticleSummaryView.h"

@interface FISEventInfoViewController ()

@end

@implementation FISEventInfoViewController

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
    self.navigationItem.title = @"Grange Cleveland Winery";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showShareActionSheet)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont fontWithName:FISFONT_REGULAR size:15]}];
    _fisSaveButton.titleLabel.font = [UIFont fontWithName:FISFONT_SEMIBOLD size:15];
    [_fisSaveButton setTitleColor:FISDefaultForegroundColor() forState:UIControlStateNormal];
    _toolbar.backgroundColor = UIColorWithRGBA(19, 19, 19, 1);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_fisSaveButton release];
    [_toolbar release];
    [super dealloc];
}

#pragma mark - FISActionSheetDelegate

- (BOOL)actionSheet:(FISActionSheet *)actionsheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    return YES;
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section==0) {
        return 0.1;
    }
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section==1) {
        return 0.1;
    }
    return 15;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 2;
    }
    else if (section==1) {
        return 5;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            FISArticleSummaryView* cell = [tableView dequeueReusableCellWithIdentifier:@"FISArticleSummaryView"];
            [cell layoutIfNeeded];
            return cell.bounds.size.height;
        }
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 290, 0)];
        label.numberOfLines = 0;
        label.font = [UIFont fontWithName:FISFONT_REGULAR size:14];
        label.text = @"This is Article Detailhghghghghgghghghgghghghghghghghghghghgh.\nThis is Article Detail.\nThis is Article Detail.\nThis is Article Detail.\n";
        [label sizeToFit];
        return label.frame.size.height+40;
    }
    else if (indexPath.section==1) {
        if (indexPath.row==0) {
            FISBusinessSummaryView* cell = [tableView dequeueReusableCellWithIdentifier:@"FISBusinessSummaryView"];
            [cell layoutIfNeeded];
            return cell.bounds.size.height;
        }
        return 44;
    }
    
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellID = @"normalCell";
    
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            FISArticleSummaryView* cell = [tableView dequeueReusableCellWithIdentifier:@"FISArticleSummaryView"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        UITableViewCell* cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell==nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
            cell.textLabel.font = [UIFont fontWithName:FISFONT_REGULAR size:14];
            cell.textLabel.textColor = UIColorWithRGBA(117, 120, 123, 1);
        }
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.text = @"This is Article Detailhghghghghgghghghgghghghghghghghghghghgh.\nThis is Article Detail.\nThis is Article Detail.\nThis is Article Detail.\n";
        [cell layoutIfNeeded];
        return cell;
    }
    else if (indexPath.section==1) {
        if (indexPath.row==0) {
            FISBusinessSummaryView* cell = [tableView dequeueReusableCellWithIdentifier:@"FISBusinessSummaryView"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
        UITableViewCell* cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell==nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
            cell.textLabel.font = [UIFont fontWithName:FISFONT_REGULAR size:14];
            cell.textLabel.textColor = UIColorWithRGBA(117, 120, 123, 1);
            cell.textLabel.backgroundColor = [UIColor grayColor];
        }
        if (indexPath.row==1) {
            cell.imageView.image = [UIImage imageNamed:@"dealinfo_phone"];
            cell.textLabel.text = @"8513942525173";
        }
        else if (indexPath.row==2) {
            cell.imageView.image = [UIImage imageNamed:@"dealinfo_mail"];
            cell.textLabel.text = @"hialexhong@yeah.net";
        }
        else if (indexPath.row==3) {
            cell.imageView.image = [UIImage imageNamed:@"dealinfo_address"];
            cell.textLabel.text = @"No.59, Tongxing, Dandong, Liaoning, China";
        }
        else if (indexPath.row==4) {
            cell.imageView.image = [UIImage imageNamed:@"dealinfo_go"];
            cell.textLabel.text = @"www.finditsimple.com";
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return nil;
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

#pragma mark - UIAction
- (void)showShareActionSheet {
    FISActionSheet* actionsheet = [[FISActionSheet alloc] initWithFrame:CGRectZero];
    
    UIButton* button;
    UIImage* buttonImage;
    
    buttonImage = [UIImage imageNamed:@"actionsheet_mail"];
    button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height)];
    [button setImage:buttonImage forState:UIControlStateNormal];
    [actionsheet addButton:button];
    [button release];
    buttonImage = [UIImage imageNamed:@"actionsheet_facebook"];
    button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height)];
    [button setImage:buttonImage forState:UIControlStateNormal];
    [actionsheet addButton:button];
    [button release];
    buttonImage = [UIImage imageNamed:@"actionsheet_tweet"];
    button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height)];
    [button setImage:buttonImage forState:UIControlStateNormal];
    [actionsheet addButton:button];
    [button release];
    buttonImage = [UIImage imageNamed:@"actionsheet_cancel"];
    button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height)];
    [button setImage:buttonImage forState:UIControlStateNormal];
    [actionsheet addButton:button isCancelButton:YES];
    [button release];
    
    actionsheet.delegate = self;
    actionsheet.backgroundColor = UIColorWithRGBA(19, 19, 19, 1);
    [actionsheet showInView:self.view];
    [actionsheet release];
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont fontWithName:FISFONT_BOLD size:FISFONT_NAVIGATION_TITLESIZE]}];
}

- (IBAction)saveButtonClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
}

@end
