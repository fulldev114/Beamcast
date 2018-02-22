//
//  FISBusinessDetailViewController.m
//  FindItSimple
//
//  Created by Jain R on 4/22/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import "FISBusinessDetailViewController.h"
#import "FISBussinessDetailCellView.h"
#import "FISDealsViewController.h"
#import "FISArticlesViewController.h"
#import "FISEventsViewController.h"

@interface FISBusinessDetailViewController ()

@end

@implementation FISBusinessDetailViewController
@synthesize nBussinessID;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    return;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = [self.info objectForKey:@"simple_title"];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showShareActionSheet)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont fontWithName:FISFONT_REGULAR size:15]}];
    
    
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

#pragma mark - UITableViewDelegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section==0) {
        return 1;
    }
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section==2) {
        return 30;
    }
    return 15;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
        return 2;
    else if (section == 1)
        return 4;
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            FISBussinessDetailCellView* cell = [tableView dequeueReusableCellWithIdentifier:@"FISBussinessDetailCellView"];
            cell.fisBusinessTitle.text = [self.info objectForKey:@"full_title"];
            [cell layoutIfNeeded];
            return cell.bounds.size.height;
        }
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 290, 0)];
        label.numberOfLines = 0;
        label.font = [UIFont fontWithName:FISFONT_REGULAR size:14];
        label.text = [self.info objectForKey:@"description"];
        [label sizeToFit];
        return label.frame.size.height+40;
    }
    
    return 44;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell;
    static NSString* cellId = @"cell";
    
    if (indexPath.section == 0) {
        if (indexPath.row != 0) {
            UITableViewCell* cell = nil;
            cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (cell==nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] autorelease];
                cell.textLabel.font = [UIFont fontWithName:FISFONT_REGULAR size:14];
                cell.textLabel.textColor = UIColorWithRGBA(117, 120, 123, 1);
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.text = [self.info objectForKey:@"description"];
            [cell layoutIfNeeded];
            return cell;
        }
        FISBussinessDetailCellView* imgCell = [tableView dequeueReusableCellWithIdentifier:@"FISBussinessDetailCellView"];
        imgCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (imgCell.fisBusinessImageView.image==nil) {
            [imgCell.fisBusinessImageView setURLWith:[self.info objectForKey:@"picture"]];
        }
        
        imgCell.fisBusinessTitle.text = [self.info objectForKey:@"full_title"];
        [imgCell layoutIfNeeded];
        
        return  imgCell;
    }
    else if (indexPath.section == 1) {
        cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell==nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] autorelease];
            cell.textLabel.font = [UIFont fontWithName:FISFONT_REGULAR size:12];
            cell.textLabel.textColor = UIColorWithRGBA(117, 120, 123, 1);
        }
        if (indexPath.row==0) {
            cell.imageView.image = [UIImage imageNamed:@"dealinfo_phone"];
            cell.textLabel.text = [self.info objectForKey:@"phone"];
        }
        else if (indexPath.row==1) {
            cell.imageView.image = [UIImage imageNamed:@"dealinfo_mail"];
            cell.textLabel.text = [self.info objectForKey:@"usermail"];
        }
        else if (indexPath.row==2) {
            cell.imageView.image = [UIImage imageNamed:@"dealinfo_address"];
            cell.textLabel.text = [self.info objectForKey:@"address"];
        }
        else if (indexPath.row==3) {
            cell.imageView.image = [UIImage imageNamed:@"dealinfo_go"];
            cell.textLabel.text = [self.info objectForKey:@"url"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else if (indexPath.section == 2)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell==nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.font = [UIFont fontWithName:FISFONT_REGULAR size:14];
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Deals";
        }
        else if (indexPath.row == 1) {
            cell.textLabel.text = @"FYI";
        }
        else if (indexPath.row == 2) {
            cell.textLabel.text = @"Happenings";
        }
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* text = nil;
    NSURL* url = nil;
    if (indexPath.section==1) {
        if (indexPath.row==0) {
            text = [self.info objectForKey:@"phone"];
            if (text.length!=0) {
                text = [[text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
                url = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", text]];
            }
        }
        else if (indexPath.row==1) {
            text = [self.info objectForKey:@"usermail"];
            if (text.length!=0) {
                url = [NSURL URLWithString:[NSString stringWithFormat:@"mailto:%@", text]];
            }
        }
        else if (indexPath.row==2) {
            text = [self.info objectForKey:@"address"];
        }
        else if (indexPath.row==3) {
            text = [self.info objectForKey:@"url"];
            if (text.length!=0) {
                text = [text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSString* prefix = [text substringToIndex:7];
                if (![prefix isEqualToString:@"http://"]) {
                    text = [NSString stringWithFormat:@"http://%@", text];
                }
                url = [NSURL URLWithString:text];
            }
        }
        if (url) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }

    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            // Deals
            UIViewController* viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FISDealsViewController-568h"];
            viewController.navigationItem.title = @"DEALS";
            [(FISDealsViewController*)viewController setListType:FISListTypeSubgroup];
            [(FISDealsViewController*)viewController setBusinessID:[NSString stringWithFormat:@"%ld", (long)nBussinessID]];
            
            [self.navigationController pushViewController:viewController animated:YES];
            
        } else if (indexPath.row == 1)
        {
            // Articles
            UIViewController* viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FISArticlesViewController-568h"];
            viewController.navigationItem.title = @"ARTICLES";
            [(FISArticlesViewController*)viewController setListType:FISListTypeSubgroup];
            [(FISArticlesViewController*)viewController setBusinessID:[NSString stringWithFormat:@"%ld", (long)nBussinessID]];
            
            [self.navigationController pushViewController:viewController animated:YES];
        } else if (indexPath.row == 2)
        {
            // Happenings
            UIViewController* viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FISEventsViewController-568h"];
            viewController.navigationItem.title = @"HAPPENINGS";
            [(FISEventsViewController*)viewController setListType:FISListTypeSubgroup];
            [(FISEventsViewController*)viewController setBusinessID:[NSString stringWithFormat:@"%ld", (long)nBussinessID]];
            
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont fontWithName:FISFONT_BOLD size:FISFONT_NAVIGATION_TITLESIZE]}];
}

- (void)dealloc {
    [_tableView release];
    self.info = nil;
    [super dealloc];
}
@end
