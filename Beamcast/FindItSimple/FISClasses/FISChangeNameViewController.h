//
//  FISChangeNameViewController.h
//  FindItSimple
//
//  Created by Jain R on 4/17/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FISChangeNameViewControllerDelegate <NSObject>

- (void)usernameChanged:(NSString*)username;
- (NSString*)currentUserName;

@end

@interface FISChangeNameViewController : FISBaseViewController

@property (nonatomic, assign) id<FISChangeNameViewControllerDelegate> delegate;

@property (retain, nonatomic) IBOutlet UITextField *textfield1;
@property (retain, nonatomic) IBOutlet UIView *paddingView1;
@end
