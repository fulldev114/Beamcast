//
//  FISSignViewController.h
//  FindItSimple
//
//  Created by Jain R on 3/21/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FISBaseViewController.h"

@protocol FISSignViewControllerDelegate <NSObject>

- (void)signInSuccessWith:(NSString*)token password:(NSString*)password;

@end

typedef NS_ENUM(NSInteger, FISSignViewControllerType) {
    FISSignViewControllerTypeSignIn,
    FISSignViewControllerTypeSignUp,
};

@interface FISSignViewController : FISBaseViewController <UITextFieldDelegate>

@property (nonatomic) FISSignViewControllerType type;
@property (nonatomic, getter = isKeyboardShown) BOOL keyboardShown;
@property (nonatomic, assign) id<FISSignViewControllerDelegate> delegate;

- (void)clearTextFields;

// signin
@property (retain, nonatomic) IBOutlet UITextField *emailField;
@property (retain, nonatomic) IBOutlet UITextField *passwordField;
// singup
@property (retain, nonatomic) IBOutlet UITextField *nameField;
@property (retain, nonatomic) IBOutlet UITextField *emailField2;
@property (retain, nonatomic) IBOutlet UITextField *passwordField2;

@property (retain, nonatomic) IBOutlet UIScrollView *scrollView1;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView2;
@property (retain, nonatomic) IBOutlet UIButton *checkButton;

- (IBAction)transitionPage:(UIButton *)sender;
- (IBAction)signInButtonClicked:(UIButton *)sender;
- (IBAction)signUpButtonClicked:(UIButton *)sender;
- (IBAction)signInWithFacebookButtonClicked:(UIButton *)sender;
- (IBAction)checkboxSelected:(id)sender;
- (IBAction)onTOS:(id)sender;

@end
