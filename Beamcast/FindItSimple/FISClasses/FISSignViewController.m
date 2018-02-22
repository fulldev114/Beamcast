//
//  FISSignViewController.m
//  FindItSimple
//
//  Created by Jain R on 3/21/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import "FISSignViewController.h"
#import "FISAppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>

@interface FISSignViewController () {
    BOOL checkBoxSelected;
}

@end

@implementation FISSignViewController

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
    if (!IS_4INCH()) {
        _scrollView1.contentSize = CGSizeMake(320, 480);
        _scrollView2.contentSize = CGSizeMake(320, 568);
        _scrollView1.delaysContentTouches = YES;
        _scrollView2.delaysContentTouches = YES;
    }
    
    self.emailField.font = [UIFont fontWithName:FISFONT_REGULAR size:16];
    self.emailField.tintColor = FISDefaultBackgroundColor();
    self.emailField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email Address" attributes:@{NSForegroundColorAttributeName: UIColorWithRGBA(180, 180, 180, 1)}];
    self.passwordField.font = [UIFont fontWithName:FISFONT_REGULAR size:16];
    self.passwordField.tintColor = FISDefaultBackgroundColor();
    self.passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: UIColorWithRGBA(180, 180, 180, 1)}];

    self.nameField.font = [UIFont fontWithName:FISFONT_REGULAR size:16];
    self.nameField.tintColor = FISDefaultBackgroundColor();
    self.nameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Full Name" attributes:@{NSForegroundColorAttributeName: UIColorWithRGBA(180, 180, 180, 1)}];
    self.emailField2.font = [UIFont fontWithName:FISFONT_REGULAR size:16];
    self.emailField2.tintColor = FISDefaultBackgroundColor();
    self.emailField2.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email Address" attributes:@{NSForegroundColorAttributeName: UIColorWithRGBA(180, 180, 180, 1)}];
    self.passwordField2.font = [UIFont fontWithName:FISFONT_REGULAR size:16];
    self.passwordField2.tintColor = FISDefaultBackgroundColor();
    self.passwordField2.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: UIColorWithRGBA(180, 180, 180, 1)}];
    [self.checkButton setBackgroundImage:[UIImage imageNamed:@"popup_check.png"] forState:UIControlStateNormal];
    [self.checkButton setBackgroundImage:[UIImage imageNamed:@"popup_checked.png"] forState:UIControlStateSelected];
    [self.checkButton setBackgroundImage:[UIImage imageNamed:@"popup_checked.png"] forState:UIControlStateHighlighted];
    [self.scrollView2 removeFromSuperview];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self clearTextFields];
}

- (BOOL)validateEmail: (NSString *) candidate
{
#ifdef TEST_CODE
//    return YES;
#endif
    
	NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
	
	return [emailTest evaluateWithObject:candidate];
}

- (BOOL)isTextFieldsValidated {
    UIAlertView* alertView = nil;
    if (self.type==FISSignViewControllerTypeSignIn) {
        if(self.emailField.text.length==0 || self.passwordField.text.length==0)
        {
            alertView = [[[UIAlertView alloc] initWithTitle:FISDefaultAlertTitle message:@"Please fill all fields." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] autorelease];
            [alertView show];
            return NO;
        }
        
        if (![self validateEmail:self.emailField.text]) {
            alertView = [[[UIAlertView alloc] initWithTitle:FISDefaultAlertTitle message:@"Please enter valid email address." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] autorelease];
            [alertView show];
            return NO;
        }
    }
    else {
        if(self.emailField2.text.length==0 || self.passwordField2.text.length==0 || self.nameField.text.length==0)
        {
            alertView = [[[UIAlertView alloc] initWithTitle:FISDefaultAlertTitle message:@"Please fill all fields." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] autorelease];
            [alertView show];
            return NO;
        }
        
        if (![self validateEmail:self.emailField2.text]) {
            alertView = [[[UIAlertView alloc] initWithTitle:FISDefaultAlertTitle message:@"Please enter valid email address." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] autorelease];
            [alertView show];
            return NO;
        }
    }
    
    if (!checkBoxSelected) {
        alertView = [[[UIAlertView alloc] initWithTitle:FISDefaultAlertTitle message:@"Please agree to the terms of service." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] autorelease];
        [alertView show];
        return NO;
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField==self.nameField) {
        [self.emailField2 becomeFirstResponder];
    }
    else if (textField==self.emailField2) {
        [self.passwordField2 becomeFirstResponder];
    }
    else if (textField==self.emailField) {
        [self.passwordField becomeFirstResponder];
    }
    else {
        [self hideKeyboard:nil];
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (!self.isKeyboardShown) {
        UIView* overlayview = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
        overlayview.backgroundColor = self.view.backgroundColor;
        [overlayview addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)] autorelease]];
        overlayview.tag = 3000;
        
        UILabel* label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 20, 320, 40)] autorelease];
        label.text = @"Tap here to hide keyboard";
        label.font = [UIFont fontWithName:FISFONT_SEMIBOLD size:14];
        label.textColor = [UIColor lightGrayColor];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        [overlayview addSubview:label];

        if (self.type==FISSignViewControllerTypeSignIn) {
            overlayview.frame = CGRectMake(0, 260, 320, 500);
            [self.scrollView1 addSubview:overlayview];
            [self.scrollView1 setContentOffset:CGPointMake(0, 130) animated:YES];
            self.scrollView1.scrollEnabled = NO;
        }
        else {
            overlayview.frame = CGRectMake(0, 320, 320, 500);
            [self.scrollView2 addSubview:overlayview];
            [self.scrollView2 setContentOffset:CGPointMake(0, 130) animated:YES];
            self.scrollView2.scrollEnabled = NO;
        }
        self.KeyboardShown = YES;
    }
}

- (IBAction)hideKeyboard:(id)sender {
    [self.emailField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    [self.nameField resignFirstResponder];
    [self.emailField2 resignFirstResponder];
    [self.passwordField2 resignFirstResponder];
    
    if (self.isKeyboardShown) {
        if (self.type==FISSignViewControllerTypeSignIn) {
            [self.scrollView1 setContentOffset:CGPointMake(0, 0) animated:YES];
            UIView* overlayview = [self.scrollView1 viewWithTag:3000];
            [overlayview removeFromSuperview];
            self.scrollView1.scrollEnabled = YES;
        }
        else {
            [self.scrollView2 setContentOffset:CGPointMake(0, 0) animated:YES];
            UIView* overlayview = [self.scrollView2 viewWithTag:3000];
            [overlayview removeFromSuperview];
            self.scrollView2.scrollEnabled = YES;
        }

        self.keyboardShown = NO;
    }
}

- (void)clearTextFields {
    [self hideKeyboard:nil];
    self.emailField.text = [FISAppDirectory getLastUser];
    self.passwordField.text = nil;
    self.emailField2.text = nil;
    self.passwordField2.text = nil;
    self.nameField.text = nil;
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
    [_emailField release];
    [_passwordField release];
    [_nameField release];
    [_emailField2 release];
    [_passwordField2 release];
    [_scrollView1 release];
    [_scrollView2 release];
    [_checkButton release];
    [super dealloc];
}

#pragma mark - UIActions

- (IBAction)transitionPage:(UIButton *)sender {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];

    if (sender.tag==0) {
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
    
        [self.scrollView1 removeFromSuperview];
        [self.view addSubview:self.scrollView2];
        self.type = FISSignViewControllerTypeSignUp;
    }
    else {
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
        
        [self.scrollView2 removeFromSuperview];
        [self.view addSubview:self.scrollView1];
        self.type = FISSignViewControllerTypeSignIn;
    }
    
    [UIView commitAnimations];
}

- (IBAction)signInButtonClicked:(UIButton *)sender {
    if ([self isTextFieldsValidated]) {
        [[FISAppLocker sharedLocker] lockApp];
        // sign in
        [FISWebService sendAsynchronousCommand:ACTION_SIGN_IN parameters:@{@"usermail":self.emailField.text, @"userpwd":self.passwordField.text} completionHandler:^(NSData *response, NSError *error) {
            NSLog(@"error:%@\n\nresponse:\n%@", error, response);
            if (error!=nil) {
                NSRange range = [error.localizedDescription rangeOfString:MSG_ERR_VALUE];
                if (range.location != NSNotFound) {
                    UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:@"SignIn failed. Please enter correct email and password." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] autorelease];
                    [alert show];
                }
                else {
                    UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] autorelease];
                    [alert show];
                }
                [[FISAppLocker sharedLocker] unlockApp];
            }
            else { // success
                [FISAppDirectory setLastUser:self.emailField.text];
                NSDictionary* data = (NSDictionary*)response;
                NSString* token = [data objectForKey:@"token"];
                if ([self.delegate respondsToSelector:@selector(signInSuccessWith:password:)]) {
                    [self.delegate signInSuccessWith:token password:self.passwordField.text];
                }
                else
                    [[FISAppLocker sharedLocker] unlockApp];
            }
        }];
    }
}

- (IBAction)signUpButtonClicked:(UIButton *)sender {
    
    if ([self isTextFieldsValidated]) {
        [[FISAppLocker sharedLocker] lockApp];
        // add user
        [FISWebService sendAsynchronousCommand:ACTION_USER_REG parameters:@{@"usermail":self.emailField2.text, @"userpwd":self.passwordField2.text, @"username":self.nameField.text, @"usertype":@"1"} completionHandler:^(NSData *response, NSError *error) {
            NSLog(@"error:%@\n\nresponse:\n%@", error, response);
            if (error!=nil) {
                NSRange range = [error.localizedDescription rangeOfString:MSG_ERR_VALUE];
                if (range.location!=NSNotFound) {
                    UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:@"The email address is already used by another user." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] autorelease];
                    [alert show];
                }
                else {
                    UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] autorelease];
                    [alert show];
                }
                [[FISAppLocker sharedLocker] unlockApp];
            }
            else { // success
                [FISAppDirectory setLastUser:self.emailField2.text];
                NSDictionary* data = (NSDictionary*)response;
                NSString* token = [data objectForKey:@"token"];
                if ([self.delegate respondsToSelector:@selector(signInSuccessWith:password:)]) {
                    [self.delegate signInSuccessWith:token password:self.passwordField2.text];
                }
                else
                    [[FISAppLocker sharedLocker] unlockApp];
            }
        }];
    }
    
}

- (IBAction)signInWithFacebookButtonClicked:(UIButton *)sender {
	// If the session state is not in any of the two "open" states when the button is clicked
	FBSessionState sessionState = FBSession.activeSession.state;
	if (sessionState != FBSessionStateOpen && sessionState != FBSessionStateOpenTokenExtended) {
		// Open a session showing the user the login UI
		// You must ALWAYS ask for public_profile permissions when opening a session
		[FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"email", @"user_friends"]
										   allowLoginUI:YES
									  completionHandler:
		 ^(FBSession *session, FBSessionState state, NSError *error) {
			 // Retrieve the app delegate
			 FISAppDelegate* appDelegate = (FISAppDelegate*)[UIApplication sharedApplication].delegate;
			 // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
			 [appDelegate sessionStateChanged:session state:state error:error];
		 }];
	}
}

- (IBAction)checkboxSelected:(id)sender {
    checkBoxSelected = !checkBoxSelected;
    [self.checkButton setSelected:checkBoxSelected];
}

- (IBAction)onTOS:(id)sender {
    NSURL *url = [NSURL URLWithString:@"http://finditsimple.com/termsofservice/"];
    if (![[UIApplication sharedApplication] openURL:url]) {
        NSLog(@"%@%@", @"Failed to open url:", [url description]);
    }
}
@end
