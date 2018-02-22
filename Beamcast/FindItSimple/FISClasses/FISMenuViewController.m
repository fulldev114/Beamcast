//
//  FISMenuViewController.m
//  FindItSimple
//
//  Created by Jain R on 3/14/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import "FISMenuViewController.h"
#import "FISCategoriesViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface FISMenuViewController ()

@end

@implementation FISMenuViewController

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
    _scrollView.contentSize = _contentView.bounds.size;
    if (!IS_4INCH()) {
        _scrollView.delaysContentTouches = YES;
    }
    _searchbox.font = [UIFont fontWithName:FISFONT_REGULAR size:14];
    _searchbox.textColor = UIColorWithRGBA(164, 159, 153, 1);
    _nameButton.titleLabel.font = [UIFont fontWithName:FISFONT_SEMIBOLD size:15];
    [_nameButton setTitleColor:FISDefaultForegroundColor() forState:UIControlStateNormal];
    _cityButton.titleLabel.font = [UIFont fontWithName:FISFONT_REGULAR size:12];
    [_cityButton setTitleColor:UIColorWithRGBA(164, 159, 153, 1) forState:UIControlStateNormal];
    _savedLabel1.textColor = FISDefaultForegroundColor();
    _savedLabel1.font = [UIFont fontWithName:FISFONT_REGULAR size:15];
    _savedLabel2.textColor = FISDefaultForegroundColor();
    _savedLabel2.font = [UIFont fontWithName:FISFONT_REGULAR size:15];
    _savedLabel3.textColor = FISDefaultForegroundColor();
    _savedLabel3.font = [UIFont fontWithName:FISFONT_REGULAR size:15];
    
#ifdef TEST_CODE
    _photoView.image = [UIImage imageNamed:@"menu_avatar_unknown"];
    [_nameButton setTitle:@"Unknown" forState:UIControlStateNormal];
    [_cityButton setTitle:@"Unknown City" forState:UIControlStateNormal];
    _savedLabel1.text = @"0";
    _savedLabel2.text = @"0";
    _savedLabel3.text = @"0";
#endif
}

- (void)viewWillAppear:(BOOL)animated {
    NSString* token = FISGetCurrentToken();
    
    if (token.length==0) {
        _photoView.image = [UIImage imageNamed:@"menu_avatar_unknown"];
        [_nameButton setTitle:@"Unknown" forState:UIControlStateNormal];
        [_cityButton setTitle:@"Unknown City" forState:UIControlStateNormal];
        _savedLabel1.text = @"0";
        _savedLabel2.text = @"0";
        _savedLabel3.text = @"0";
    }
    else {
        UIImage* photo = [FISAppDirectory getPhoto];
        if (photo==nil) {
            photo = [UIImage imageNamed:@"menu_avatar_unknown"];
        }
        self.photoView.image = photo;
        NSDictionary* info = [FISAppDirectory getUserInfo];
        [self.nameButton setTitle:[info objectForKey:@"g_username"] forState:UIControlStateNormal];
        [self.cityButton setTitle:[info objectForKey:@"g_city"] forState:UIControlStateNormal];
        self.savedLabel1.text = [info objectForKey:@"g_deal_cnt"];
        self.savedLabel2.text = [info objectForKey:@"g_article_cnt"];
        self.savedLabel3.text = [info objectForKey:@"g_event_cnt"];
    }
    
    [super viewWillAppear:animated];
}

- (void)reload:(BOOL)newSignIn {
    NSString* token = FISGetCurrentToken();

    if (token.length==0) {
        _photoView.image = [UIImage imageNamed:@"menu_avatar_unknown"];
        [_nameButton setTitle:@"Unknown" forState:UIControlStateNormal];
        [_cityButton setTitle:@"Unknown City" forState:UIControlStateNormal];
        _savedLabel1.text = @"0";
        _savedLabel2.text = @"0";
        _savedLabel3.text = @"0";
        return;
    }
    
    [[FISAppLocker sharedLocker] lockApp];
    // get user info
    [FISWebService sendAsynchronousCommand:ACTION_USER_GET parameters:@{@"token": token} completionHandler:^(NSData *response, NSError *error) {
        if (error!=nil) {
            UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] autorelease];
            [alert show];
            [[FISAppLocker sharedLocker] unlockApp];
        }
        else {
            // refresh menu items
            NSDictionary* data = (NSDictionary*)response;
//            NSMutableDictionary* profileInfo = [NSMutableDictionary dictionaryWithDictionary:data];

            NSString* photoData = [data objectForKey:@"photo"];
            
            if ([photoData isKindOfClass:[NSString class]]) {
                NSData* imgData = [DARBase64 dataWithBase64EncodedString:photoData];
//                self.photoView.image = [UIImage imageWithData:imgData];
//                [profileInfo setObject:self.photoView.image forKey:@"photoimage"];
                [FISAppDirectory setPhoto:[UIImage imageWithData:imgData]];
            }
            else {
//                self.photoView.image = [UIImage imageNamed:@"menu_avatar_unknown"];
//                [profileInfo setObject:nil forKey:@"photoimage"];
                [FISAppDirectory setPhoto:nil];
            }

//            [self.nameButton setTitle:[data objectForKey:@"username"] forState:UIControlStateNormal];
            
            NSString* city = [data objectForKey:@"city"];
            if ([city isKindOfClass:[NSString class]]) {
//                [self.cityButton setTitle:city forState:UIControlStateNormal];
//                [profileInfo setObject:city forKey:@"citystring"];
            }
            else {
                city = @"Unknown City";
//                [self.cityButton setTitle:@"Unknown City" forState:UIControlStateNormal];
//                [profileInfo setObject:@"Unknown" forKey:@"citystring"];
            }
            
            self.savedLabel1.text = [data objectForKey:@"deal_cnt"];
            self.savedLabel2.text = [data objectForKey:@"article_cnt"];
            self.savedLabel3.text = [data objectForKey:@"event_cnt"];
            
            NSMutableDictionary* globalInfo = [NSMutableDictionary dictionary];

            [globalInfo setObject:[data objectForKey:@"username"] forKey:@"g_username"];
            [globalInfo setObject:[data objectForKey:@"usermail"] forKey:@"g_usermail"];
            [globalInfo setObject:city forKey:@"g_city"];
            [globalInfo setObject:[data objectForKey:@"deal_cnt"] forKey:@"g_deal_cnt"];
            [globalInfo setObject:[data objectForKey:@"article_cnt"] forKey:@"g_article_cnt"];
            [globalInfo setObject:[data objectForKey:@"event_cnt"] forKey:@"g_event_cnt"];

            [FISAppDirectory setUserInfo:globalInfo];

            // refresh profile page
//            self.profileViewController.info = profileInfo;

            if (newSignIn) {
                [self.dynamicsDrawerViewController setPaneState:MSDynamicsDrawerPaneStateOpen inDirection:MSDynamicsDrawerDirectionLeft animated:YES allowUserInterruption:YES completion:^{
                    [self menuDidClicked:self.profileButton];
                    [[FISAppLocker sharedLocker] unlockApp];
                }];
            }
            else
                [[FISAppLocker sharedLocker] unlockApp];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)transitionToViewController:(UIViewController *)paneViewController {
    // Close pane if already displaying that pane view controller
    if (paneViewController == self.paneViewController) {
        [self.dynamicsDrawerViewController setPaneState:MSDynamicsDrawerPaneStateClosed animated:YES allowUserInterruption:YES completion:nil];
        return;
    }
    
    BOOL animateTransition = self.dynamicsDrawerViewController.paneViewController != nil;
    animateTransition = NO;
    
    paneViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"icon_leftbarbutton_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleBordered target:self action:@selector(dynamicsDrawerRevealLeftBarButtonItemTapped:)];
    
    FISNavigationController *paneNavigationViewController = [[FISNavigationController alloc] initWithRootViewController:paneViewController];
    [self.dynamicsDrawerViewController setPaneViewController:paneNavigationViewController animated:animateTransition completion:nil];
    self.paneViewController = paneViewController;
}

- (void)dynamicsDrawerRevealLeftBarButtonItemTapped:(id)sender
{
    [self.dynamicsDrawerViewController setPaneState:MSDynamicsDrawerPaneStateOpen inDirection:MSDynamicsDrawerDirectionLeft animated:YES allowUserInterruption:YES completion:nil];
}

- (void)dynamicsDrawerRevealRightBarButtonItemTapped:(id)sender
{
    return;
    [self.dynamicsDrawerViewController setPaneState:MSDynamicsDrawerPaneStateOpen inDirection:MSDynamicsDrawerDirectionRight animated:YES allowUserInterruption:YES completion:nil];
}

#pragma mark - SignInViewController Delegate

- (void)signInSuccessWith:(NSString *)token password:(NSString *)password {
    [FISAppDirectory setToken:token];
    [FISAppDirectory setCurrentPassword:password];
    [self reload:YES];

    [FISAppDirectory setNeedToRefresh:YES key:@"dealsVC"];
    [FISAppDirectory setNeedToRefresh:YES key:@"articlesVC"];
    [FISAppDirectory setNeedToRefresh:YES key:@"eventsVC"];
    [FISAppDirectory setNeedToRefresh:YES key:@"nearbyVC"];
}

#pragma mark - ProfileViewController Delegate

- (void)signOut {
	// If the session state is any of the two "open" states when the button is clicked
	FBSessionState sessionState = FBSession.activeSession.state;
	if (sessionState == FBSessionStateOpen || sessionState == FBSessionStateOpenTokenExtended) {
		// Close the session and remove the access token from the cache
		// The session state handler (in the app delegate) will be called automatically
		[FBSession.activeSession closeAndClearTokenInformation];
	}

    [FISAppDirectory setToken:nil];
    [self.dynamicsDrawerViewController setPaneState:MSDynamicsDrawerPaneStateOpen inDirection:MSDynamicsDrawerDirectionLeft animated:YES allowUserInterruption:YES completion:^{
        [self menuDidClicked:self.profileButton];
    }];

    [FISAppDirectory setNeedToRefresh:YES key:@"dealsVC"];
    [FISAppDirectory setNeedToRefresh:YES key:@"articlesVC"];
    [FISAppDirectory setNeedToRefresh:YES key:@"eventsVC"];
    [FISAppDirectory setNeedToRefresh:YES key:@"nearbyVC"];
}

#pragma mark - NearbyViewController Delegate

- (void)photoAnnotationRightButtonClicked {
    [self.dynamicsDrawerViewController setPaneState:MSDynamicsDrawerPaneStateOpen inDirection:MSDynamicsDrawerDirectionLeft animated:YES allowUserInterruption:YES completion:^{
        [self menuDidClicked:self.profileButton];
    }];
}

- (void)userInfoChanged {
//    [self reload:NO];
}

- (IBAction)textFieldBeginEdit:(id)sender {
    self.searchPlaceholder.hidden = YES;
}

- (IBAction)textFieldEndEdit:(id)sender {
    if ([self.searchbox.text isEqualToString:@""]) {
        self.searchPlaceholder.hidden = NO;
    }
    else {
        self.searchPlaceholder.hidden = YES;
    }
}

- (IBAction)hideKeyboard:(id)sender {
    [self.searchbox resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // search
    NSString* searchText = textField.text;
    if (searchText.length!=0) {
        if (self.searchViewController) {
            if (![self.searchViewController.searchText isEqualToString:searchText]) {
                self.searchViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FISSearchViewController-568h"];
            }
        }
        else {
            self.searchViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FISSearchViewController-568h"];
        }
        self.searchViewController.searchText = searchText;
        [self transitionToViewController:self.searchViewController];
    }
    
    [self hideKeyboard:nil];
    return YES;
}

- (IBAction)photoDidClicked:(UIButton *)sender {
    [self menuDidClicked:self.profileButton];
}

- (IBAction)menuDidClicked:(UIButton *)sender {
    [self hideKeyboard:nil];

    NSInteger menuIndex = sender.tag;
    if (menuIndex<self.viewControllers.count) {
    
        if (sender==self.profileButton) {
            NSString* token = FISGetCurrentToken();
            if (token.length==0) { // is not signed
                [self.viewControllers replaceObjectAtIndex:menuIndex withObject:self.signInViewController];
            }
            else {
                [self.viewControllers replaceObjectAtIndex:menuIndex withObject:self.profileViewController];
                [self.profileViewController.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
        }
        
        [self transitionToViewController:[self.viewControllers objectAtIndex:menuIndex]];
    }
}

- (IBAction)savedDidClicked:(UIButton *)sender {
    [self menuDidClicked:self.profileButton];
}

- (IBAction)nameDidClicked:(UIButton *)sender {
    [self menuDidClicked:self.profileButton];
}

- (IBAction)cityDidClicked:(UIButton *)sender {
    [self menuDidClicked:self.profileButton];
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
    self.viewControllers = nil;
    self.profileViewController = nil;
    self.signInViewController = nil;
    self.searchViewController = nil;
    
    [_searchPlaceholder release];
    [_searchbox release];
    [_photoView release];
    [_scrollView release];
    [_contentView release];
    [_nameButton release];
    [_cityButton release];
    [_savedLabel1 release];
    [_savedLabel2 release];
    [_savedLabel3 release];
    [_profileButton release];
    [super dealloc];
}
@end
