//
//  FISChangePaswwordViewController.h
//  FindItSimple
//
//  Created by Jain R on 4/17/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FISchangePasswordViewControllerDelegate <NSObject>

- (void)passwordChanged:(NSString*)newPassword;

@end

@interface FISChangePaswwordViewController : FISBaseViewController

@property (nonatomic, assign) id<FISchangePasswordViewControllerDelegate> delegate;

@property (retain, nonatomic) IBOutlet UITextField *textfield1;
@property (retain, nonatomic) IBOutlet UITextField *textfield2;
@property (retain, nonatomic) IBOutlet UITextField *textfield3;
@end
