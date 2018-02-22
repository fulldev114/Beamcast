//
//  FISPostViewController.h
//  FindItSimple
//
//  Created by Jain R on 4/12/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FISPostViewControllerDelegate <NSObject>

- (void)usePhoto:(UIViewController*)sccaptureController photo:(UIImage*)photo;

@end

@interface FISPostViewController : UIViewController

@property (nonatomic, assign) id<FISPostViewControllerDelegate> delegate;
@property (nonatomic, retain) UIImage* photo;

@property (retain, nonatomic) IBOutlet UIImageView *photoView;
- (IBAction)retake:(id)sender;
- (IBAction)use:(id)sender;
@end
