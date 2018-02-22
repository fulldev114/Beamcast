//
//  FISCityViewController.h
//  FindItSimple
//
//  Created by Jain R on 4/17/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FISChangeCityViewControllerDelegate <NSObject>

- (void)cityChanged:(NSString*)newCity;
- (NSString*)currentCity;

@end

@interface FISCityViewController : FISBaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) id<FISChangeCityViewControllerDelegate> delegate;
@property (nonatomic, retain) NSArray* citys;

@end
