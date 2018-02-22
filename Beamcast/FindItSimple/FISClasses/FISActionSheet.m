//
//  FISActionSheet.m
//  FindItSimple
//
//  Created by Jain R on 3/20/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import "FISActionSheet.h"

@implementation FISActionSheet

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.buttonContainer = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
        self.maskView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
        self.maskView.backgroundColor = [UIColor blackColor];
        self.maskView.alpha = 0.3f;
        [self addSubview:self.maskView];
        [self addSubview:self.buttonContainer];
    }
    return self;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    self.buttonContainer.backgroundColor = backgroundColor;
}

- (void)addButton:(UIButton *)button {
    [self addButton:button isCancelButton:NO];
}

- (void)addButton:(UIButton *)button isCancelButton:(BOOL)isCancelButton {
    if (self.buttons==nil) {
        self.buttons = [NSMutableArray array];
    }
    if (isCancelButton) {
        [button addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    else {
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.buttons addObject:button];
}

- (void)buttonClicked:(UIButton*)button {
    for (int i = 0; i<self.buttons.count; i++) {
        if ([[self.buttons objectAtIndex:i] isEqual:button]) {
            if ([self.delegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)]) {
                if ([self.delegate actionSheet:self clickedButtonAtIndex:i]) {
                    [self cancel];
                }
                return;
            }
        }
    }
}

- (void)cancelButtonClicked:(UIButton*)button {
    for (int i = 0; i<self.buttons.count; i++) {
        if ([[self.buttons objectAtIndex:i] isEqual:button]) {
            if ([self.delegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)]) {
                if ([self.delegate actionSheet:self clickedButtonAtIndex:i]) {
                    [self cancel];
                }
                return;
            }
        }
    }
}

- (void)cancel {
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.5 animations:^{
        self.buttonContainer.frame = CGRectMake(0, self.maskView.frame.size.height, self.maskView.frame.size.width, self.buttonContainer.frame.size.height);
    } completion:^(BOOL finished) {
        self.userInteractionEnabled = YES;
        [self removeFromSuperview];
    }];
}

- (void)showInView:(UIView *)view {
    if (self.buttons.count == 0) {
        return;
    }
    for (UIView* subview in view.subviews) {
        if ([subview isKindOfClass:[FISActionSheet class]]) {
            return;
        }
    }
    self.userInteractionEnabled = NO;
    self.frame = view.bounds;
    self.maskView.frame = self.bounds;
    self.buttonContainer.frame = CGRectMake(0, self.maskView.frame.size.height, self.maskView.frame.size.width, 0);
    
    float spacing = 10;
    float refY = spacing;
    for (UIButton* button in self.buttons) {
        refY += button.frame.size.height / 2.0f;
        button.center = CGPointMake(self.buttonContainer.frame.size.width/2.0f, refY);
        refY += button.frame.size.height / 2.0f + spacing;
        [button removeFromSuperview];
        [self.buttonContainer addSubview:button];
    }
    self.buttonContainer.frame = CGRectMake(0, self.maskView.frame.size.height, self.maskView.frame.size.width, refY);

    [view addSubview:self];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.buttonContainer.frame = CGRectMake(0, self.maskView.frame.size.height - refY, self.maskView.frame.size.width, refY);
    } completion:^(BOOL finished) {
        self.userInteractionEnabled = YES;
    }];
}

- (void)dealloc {
    self.buttons = nil;
    self.buttonContainer = nil;
    self.maskView = nil;
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
