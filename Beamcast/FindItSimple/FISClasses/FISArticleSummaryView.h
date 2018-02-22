//
//  FISArticleSummaryView.h
//  FindItSimple
//
//  Created by Jain R on 3/24/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FISArticleSummaryView : UITableViewCell

@property (retain, nonatomic) IBOutlet UIImageView *fisArticleImageView;
@property (retain, nonatomic) IBOutlet UILabel *fisArticleTitle;
@property (retain, nonatomic) IBOutlet UILabel *fisDateLabel;
@property (retain, nonatomic) IBOutlet UILabel *fisSavedTitleLabel;
@property (retain, nonatomic) IBOutlet UILabel *fisSavedCountLabel;
@property (retain, nonatomic) IBOutlet UIView *fisButtonContainer;

@end
