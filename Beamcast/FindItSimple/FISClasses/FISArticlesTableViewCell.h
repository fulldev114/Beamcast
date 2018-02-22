//
//  FISArticlesTableViewCell.h
//  FindItSimple
//
//  Created by Jain R on 3/24/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FISArticlesTableViewCell : UITableViewCell <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (retain, nonatomic) IBOutlet UILabel *fisTitleLabel;
@property (retain, nonatomic) IBOutlet UILabel *fisDateLabel;
@property (retain, nonatomic) IBOutlet UILabel *fisSavedTitleLabel;
@property (retain, nonatomic) IBOutlet UILabel *fisSavedCountLabel;
@property (retain, nonatomic) IBOutlet UIImageView *fisImageView;
@property (retain, nonatomic) IBOutlet UIImageView *fisHandPickedImageView;

@property (assign, nonatomic, getter = isHandPicked) BOOL handPicked;
@property (copy, nonatomic) NSString* imageURL;

@end
