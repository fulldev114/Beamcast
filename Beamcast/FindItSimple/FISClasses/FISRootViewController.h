//
//  FISRootViewController.h
//  FindItSimple
//
//  Created by Jain R on 5/4/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSDynamicsDrawerViewController.h"

@interface FISRootViewController : MSDynamicsDrawerViewController

@property (retain, nonatomic) IBOutlet UIView *lockBackgroundView;
@property (retain, nonatomic) IBOutlet UIView *lockAnimationContainerView;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *lockIndicator;
@property (retain, nonatomic) IBOutlet UILabel *lockLabel;
@end
