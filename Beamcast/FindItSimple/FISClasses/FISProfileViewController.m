//
//  FISProfileViewController.m
//  FindItSimple
//
//  Created by Jain R on 3/26/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import "FISProfileViewController.h"
#import "FISPostViewController.h"

#define SHOW_CONNECTED_ACCOUNTS 0

@interface FISProfileViewController ()

@end

@implementation FISProfileViewController

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
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(takePicture:)] autorelease];
}

- (void)viewWillAppear:(BOOL)animated {
    NSString* token = FISGetCurrentToken();
    
    if (token.length==0) {
    }
    else {
        self.info = [FISAppDirectory getUserInfo];
        [self.tableView reloadData];
    }
    
    [super viewWillAppear:animated];
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
    self.info = nil;
    [_tableView release];
    [super dealloc];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#if SHOW_CONNECTED_ACCOUNTS
    return 4;
#else
    return 3;
#endif
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = 0;
    switch (section) {
        case 0:
            numberOfRows = 3;
            break;
        case 1:
            numberOfRows = 3;
            break;
#if SHOW_CONNECTED_ACCOUNTS
        case 2:
            numberOfRows = 2;
            break;
        case 3:
            numberOfRows = 1;
            break;
#else
        case 2:
            numberOfRows = 1;
            break;
#endif
            
        default:
            break;
    }
    return numberOfRows;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString* sectionTitle = nil;
    switch (section) {
        case 0:
            sectionTitle = @"CONTACT INFORMATION";
            break;
        case 1:
            sectionTitle = @"SAVED";
            break;
#if SHOW_CONNECTED_ACCOUNTS
        case 2:
            sectionTitle = @"CONNECTED ACCOUNT";
            break;
#endif
            
        default:
            break;
    }
    return sectionTitle;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UILabel *myLabel = [[UILabel alloc] init];
    if (section==0) {
        myLabel.frame = CGRectMake(15, 28, 320, 20);
    }
    else {
        myLabel.frame = CGRectMake(15, 12, 320, 20);
    }
    myLabel.font = [UIFont fontWithName:FISFONT_REGULAR size:14];
    myLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    myLabel.textColor = [UIColor grayColor];
    
    UIView *headerView = [[UIView alloc] init];
    [headerView addSubview:myLabel];
    
    return headerView;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellId = @"profilecell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        UIImage *maskImage = [UIImage imageNamed:@"profile_icon_mask"];
        CALayer* maskLayer = [CALayer layer];
        maskLayer.frame = CGRectMake(0, 0, maskImage.size.width, maskImage.size.height);
        [maskLayer setContents:(id)[maskImage CGImage]];
        cell.imageView.layer.mask = maskLayer;
        
        cell.textLabel.font = [UIFont fontWithName:FISFONT_SEMIBOLD size:16];
        cell.detailTextLabel.font = [UIFont fontWithName:FISFONT_REGULAR size:14];
        
        if (indexPath.section!=3) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    NSString* title = nil;
    NSString* detail = nil;
    UIImage* image = nil;
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    title = [self.info objectForKey:@"g_username"];
                    detail = @"Change Name";

                    UIImage* photo = [FISAppDirectory getPhoto];
                    if (photo) {
                        image = [photo resizeImageWithSize:CGSizeMake(29, 29)];
                    }
                    else {
                        image = [[UIImage imageNamed:@"profile_icon_avatar"] resizeImageWithSize:CGSizeMake(29, 29)];
                    }
                    break;
                case 1:
                    title = [self.info objectForKey:@"g_usermail"];
                    detail = @"Password";
                    image = [UIImage imageNamed:@"profile_icon_mail"];
                    break;
                case 2:
                    title = [self.info objectForKey:@"g_city"];
                    detail = @"Change City";
                    image = [UIImage imageNamed:@"profile_icon_city"];
                    break;
                    
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    title = @"Deals";
                    detail = [self.info objectForKey:@"g_deal_cnt"];
                    image = [UIImage imageNamed:@"profile_icon_deals"];
                    break;
                case 1:
                    title = @"FYI";
                    detail = [self.info objectForKey:@"g_article_cnt"];
                    image = [UIImage imageNamed:@"profile_icon_articles"];
                    break;
                case 2:
                    title = @"Events";
                    detail = [self.info objectForKey:@"g_event_cnt"];
                    image = [UIImage imageNamed:@"profile_icon_events"];
                    break;
                    
                default:
                    break;
            }
            break;

#if SHOW_CONNECTED_ACCOUNTS
        case 2:
            switch (indexPath.row) {
                case 0:
                    title = @"Facebook";
                    detail = @"None";
                    image = [UIImage imageNamed:@"profile_icon_facebook"];
                    break;
                case 1:
                    title = @"Twitter";
                    detail = @"None";
                    image = [UIImage imageNamed:@"profile_icon_twitter"];
                    break;
                case 2:
                    title = @"Pinterest";
                    detail = @"None";
                    image = [UIImage imageNamed:@"profile_icon_twitter"];
                    break;
                    
                default:
                    break;
            }
            break;
#endif
			
#if SHOW_CONNECTED_ACCOUNTS
        case 3:
#else
        case 2:
#endif
            switch (indexPath.row) {
                case 0:
                    title = @"Sign Out";
                    image = [UIImage imageNamed:@"profile_icon_signout"];
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    break;
                    
                default:
                    break;
            }
            break;
            
        default:
            break;
    }

    cell.imageView.image = image;
    cell.textLabel.text = title;
    cell.detailTextLabel.text = detail;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FISChangeNameViewController* cnvc = nil;
    FISChangePaswwordViewController* cpvc = nil;
    FISCityViewController* ccvc = nil;
    
    FISBaseListViewController* viewController = nil;
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    cnvc = [self.storyboard instantiateViewControllerWithIdentifier:@"FISChangeNameViewController-568h"];
                    cnvc.delegate = self;
                    [self.navigationController pushViewController:cnvc animated:YES];
                    break;
                case 1:
                    cpvc = [self.storyboard instantiateViewControllerWithIdentifier:@"FISChangePaswwordViewController-568h"];
                    cpvc.delegate = self;
                    [self.navigationController pushViewController:cpvc animated:YES];
                    break;
                case 2:
                    ccvc = [self.storyboard instantiateViewControllerWithIdentifier:@"FISCityViewController-568h"];
                    ccvc.delegate = self;
                    [self.navigationController pushViewController:ccvc animated:YES];
                    break;
                    
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FISDealsViewController-568h"];
                    viewController.navigationItem.title = @"DEALS";
                    break;
                case 1:
                    viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FISArticlesViewController-568h"];
                    viewController.navigationItem.title = @"FYI";
                    break;
                case 2:
                    viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FISEventsViewController-568h"];
                    viewController.navigationItem.title = @"HAPPENINGS";
                    break;
                    
                default:
                    break;
            }
            viewController.listType = FISListTypeSaved;
            [self.navigationController pushViewController:viewController animated:YES];
            break;

#if SHOW_CONNECTED_ACCOUNTS
        case 2:
            switch (indexPath.row) {
                case 0:
                    break;
                case 1:
                    break;
                case 2:
                    break;
                    
                default:
                    break;
            }
            break;
#endif
            
#if SHOW_CONNECTED_ACCOUNTS
        case 3:
#else
        case 2:
#endif
            switch (indexPath.row) {
                case 0:
                    if ([self.delegate respondsToSelector:@selector(signOut)]) {
                        [self.delegate signOut];
                    }
                    break;
                    
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
}

#pragma mark - SCNavigationController delegate
- (void)didTakePicture:(SCNavigationController *)navigationController image:(UIImage *)image {
    FISPostViewController *con = [self.storyboard instantiateViewControllerWithIdentifier:@"FISPostViewController-568h"];
    con.photo = image;
    con.delegate = self;
    [navigationController pushViewController:con animated:YES];
}

#pragma mark - PostViewController Delegate
- (void)usePhoto:(UIViewController *)sccaptureController photo:(UIImage *)photo {
    [sccaptureController dismissViewControllerAnimated:YES completion:nil];
    [FISAppDirectory setPhoto:photo];
}

#pragma mark - change info Delegate
- (void)usernameChanged:(NSString *)username {
    if ([self.delegate respondsToSelector:@selector(userInfoChanged)]) {
        [self.delegate userInfoChanged];
    }
}

- (NSString*)currentUserName {
    return [self.info objectForKey:@"g_username"];
}

- (void)passwordChanged:(NSString *)newPassword {
    if ([self.delegate respondsToSelector:@selector(userInfoChanged)]) {
        [self.delegate userInfoChanged];
    }
}

- (NSString*)currentCity {
    return [self.info objectForKey:@"g_city"];
}

- (void)cityChanged:(NSString *)newCity {
    if ([self.delegate respondsToSelector:@selector(userInfoChanged)]) {
        [self.delegate userInfoChanged];
    }
}

- (IBAction)takePicture:(id)sender {

#if TARGET_OS_IPHONE
    SCNavigationController *nav = [[[SCNavigationController alloc] init] autorelease];
    nav.scNaigationDelegate = self;
    [nav showCameraWithParentController:self];
#endif

}

@end
