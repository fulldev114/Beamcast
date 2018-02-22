//
//  FISChangeRewardTableCell.h
//  FindItSimple
//
//  Created by PKS on 3/20/15.
//  Copyright (c) 2015 Alex Hong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FISChangeRewardTableCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel * fisRewardTitle;
@property (retain, nonatomic) IBOutlet UILabel * fisRewardPoint;
@property (retain, nonatomic) IBOutlet UIImageView * fisRewardImageView;

@property (copy, nonatomic) NSString* imageURL;
@end
