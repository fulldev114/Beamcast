//
//  FISChangePaswwordViewController.m
//  FindItSimple
//
//  Created by Jain R on 4/17/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import "FISChangePaswwordViewController.h"

@interface FISChangePaswwordViewController ()

@end

@implementation FISChangePaswwordViewController

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
    self.navigationItem.title = @"Change Password";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont fontWithName:FISFONT_REGULAR size:15]}];

    self.textfield1.font = [UIFont fontWithName:FISFONT_REGULAR size:16];
    self.textfield1.tintColor = FISDefaultBackgroundColor();
    self.textfield1.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Current Password" attributes:@{NSForegroundColorAttributeName: UIColorWithRGBA(180, 180, 180, 1)}];
    
    self.textfield2.font = [UIFont fontWithName:FISFONT_REGULAR size:16];
    self.textfield2.tintColor = FISDefaultBackgroundColor();
    self.textfield2.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"New Password" attributes:@{NSForegroundColorAttributeName: UIColorWithRGBA(180, 180, 180, 1)}];
    
    self.textfield3.font = [UIFont fontWithName:FISFONT_REGULAR size:16];
    self.textfield3.tintColor = FISDefaultBackgroundColor();
    self.textfield3.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Confirm Password" attributes:@{NSForegroundColorAttributeName: UIColorWithRGBA(180, 180, 180, 1)}];
    
    [self.textfield1 becomeFirstResponder];
}

- (BOOL)isTextFieldsValidated {
    UIAlertView* alertView = nil;
    if(self.textfield1.text.length==0 || self.textfield2.text.length==0 || self.textfield3.text.length==0)
    {
        alertView = [[[UIAlertView alloc] initWithTitle:FISDefaultAlertTitle message:@"Please fill all fields." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] autorelease];
        [alertView show];
        return NO;
    }

    if (![self.textfield1.text isEqualToString:[FISAppDirectory getCurrentPassword]]) {
        alertView = [[[UIAlertView alloc] initWithTitle:FISDefaultAlertTitle message:@"Current Password is not correct." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] autorelease];
        [alertView show];

        self.textfield1.text = nil;
        self.textfield2.text = nil;
        self.textfield3.text = nil;
        
        return NO;
    }
    if (![self.textfield2.text isEqualToString:self.textfield3.text]) {
        alertView = [[[UIAlertView alloc] initWithTitle:FISDefaultAlertTitle message:@"Please enter match password." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] autorelease];
        [alertView show];
        self.textfield2.text = nil;
        self.textfield3.text = nil;
        return NO;
    }
    return YES;
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

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField==self.textfield1) {
        [self.textfield2 becomeFirstResponder];
    }
    else if (textField==self.textfield2) {
        [self.textfield3 becomeFirstResponder];
    }
    else if (textField==self.textfield3) {
        if ([self isTextFieldsValidated]) {
            if ([self.textfield2.text isEqualToString:[FISAppDirectory getCurrentPassword]]) {
                if ([self.delegate respondsToSelector:@selector(passwordChanged:)]) {
                    [self.delegate passwordChanged:self.textfield2.text];
                    [self goBack];
                }
                return YES;
            }
            [[FISAppLocker sharedLocker] lockApp];
            // change password
            [FISWebService sendAsynchronousCommand:ACTION_USER_MOD parameters:@{@"token": FISGetCurrentToken(), @"userpwd": self.textfield2.text} completionHandler:^(NSData *response, NSError *error) {
                NSLog(@"error:%@\n\nresponse:\n%@", error, response);
                if (error!=nil) {
                    UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] autorelease];
                    [alert show];
                }
                else {
                    [FISAppDirectory setCurrentPassword:self.textfield2.text];
                    if ([self.delegate respondsToSelector:@selector(passwordChanged:)]) {
                        [self.delegate passwordChanged:self.textfield2.text];
                        [self goBack];
                    }
                }
                [[FISAppLocker sharedLocker] unlockApp];
            }];
        }
        else
            return NO;
    }
    else {
    }
    
    return YES;
}

- (void)dealloc {
    [_textfield1 release];
    [_textfield2 release];
    [_textfield3 release];
    [super dealloc];
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont fontWithName:FISFONT_BOLD size:FISFONT_NAVIGATION_TITLESIZE]}];
}

@end
