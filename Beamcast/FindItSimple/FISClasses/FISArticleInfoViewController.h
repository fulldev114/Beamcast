//
//  FISArticleInfoViewController.h
//  FindItSimple
//
//  Created by Jain R on 3/24/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FISBaseViewController.h"

@interface FISArticleInfoViewController : FISBaseViewController<UITableViewDataSource, UITableViewDelegate, FISActionSheetDelegate>

@property (retain, nonatomic) IBOutlet UIButton *fisSaveButton;
@property (retain, nonatomic) IBOutlet UIView *toolbar;

- (IBAction)saveButtonClicked:(UIButton *)sender;

@end
