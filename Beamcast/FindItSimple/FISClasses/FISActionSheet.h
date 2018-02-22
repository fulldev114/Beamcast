//
//  FISActionSheet.h
//  FindItSimple
//
//  Created by Jain R on 3/20/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FISActionSheet;

@protocol FISActionSheetDelegate <NSObject,UIActionSheetDelegate>

- (BOOL)actionSheet:(FISActionSheet*)actionsheet clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface FISActionSheet : UIView

@property (nonatomic, assign) id<FISActionSheetDelegate> delegate;
@property (nonatomic, retain) NSMutableArray* buttons;
@property (nonatomic, retain) UIView* buttonContainer;
@property (nonatomic, retain) UIView* maskView;

- (void)addButton:(UIButton*)button isCancelButton:(BOOL)isCancelButton;
- (void)addButton:(UIButton*)button;
- (void)showInView:(UIView*)view;
- (void)cancel;

@end
