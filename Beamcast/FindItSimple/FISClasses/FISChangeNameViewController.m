//
//  FISChangeNameViewController.m
//  FindItSimple
//
//  Created by Jain R on 4/17/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import "FISChangeNameViewController.h"

@interface FISChangeNameViewController ()

@end

@implementation FISChangeNameViewController

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
    self.navigationItem.title = @"Change Name";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont fontWithName:FISFONT_REGULAR size:15]}];
    
    self.textfield1.font = [UIFont fontWithName:FISFONT_REGULAR size:16];
    self.textfield1.tintColor = FISDefaultBackgroundColor();
    self.textfield1.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Full Name" attributes:@{NSForegroundColorAttributeName: UIColorWithRGBA(180, 180, 180, 1)}];
    self.paddingView1.backgroundColor = self.view.backgroundColor;

    if ([self.delegate respondsToSelector:@selector(currentUserName)]) {
        self.textfield1.text = [self.delegate currentUserName];
    }
    [self.textfield1 becomeFirstResponder];
}

- (BOOL)isTextFieldsValidated {
    UIAlertView* alertView = nil;
    if(self.textfield1.text.length==0)
    {
        alertView = [[[UIAlertView alloc] initWithTitle:FISDefaultAlertTitle message:@"Please fill all fields." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] autorelease];
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
    if ([self isTextFieldsValidated]) {
        if ([self.textfield1.text isEqualToString:[self.delegate currentUserName]]) {
            if ([self.delegate respondsToSelector:@selector(usernameChanged:)]) {
                [self.delegate usernameChanged:self.textfield1.text];
                [self goBack];
            }
            return YES;
        }
        [[FISAppLocker sharedLocker] lockApp];
        // change name
        [FISWebService sendAsynchronousCommand:ACTION_USER_MOD parameters:@{@"token": FISGetCurrentToken(), @"username": self.textfield1.text} completionHandler:^(NSData *response, NSError *error) {
            NSLog(@"error:%@\n\nresponse:\n%@", error, response);
            if (error!=nil) {
                UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] autorelease];
                [alert show];
            }
            else {
                NSMutableDictionary* globalInfo = [NSMutableDictionary dictionaryWithDictionary:[FISAppDirectory getUserInfo]];
                [globalInfo setObject:self.textfield1.text forKey:@"g_username"];
                [FISAppDirectory setUserInfo:globalInfo];
                [FISAppDirectory setNeedToRefresh:YES key:@"nearbyVC"];

                if ([self.delegate respondsToSelector:@selector(usernameChanged:)]) {
                    [self.delegate usernameChanged:self.textfield1.text];
                    [self goBack];
                }
            }
            [[FISAppLocker sharedLocker] unlockApp];
        }];
    }
    else {
        return NO;
    }
    
    return YES;
}

- (void)dealloc {
    [_textfield1 release];
    [_paddingView1 release];
    [super dealloc];
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont fontWithName:FISFONT_BOLD size:FISFONT_NAVIGATION_TITLESIZE]}];
}

@end
