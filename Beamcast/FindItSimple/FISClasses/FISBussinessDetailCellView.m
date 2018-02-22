//
//  FISBussinessDetailCellView.m
//  FindItSimple
//
//  Created by PKS on 4/29/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import "FISBussinessDetailCellView.h"

@implementation FISBussinessDetailCellView

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    _fisBusinessTitle.font = [UIFont fontWithName:FISFONT_REGULAR size:17];
    _fisBusinessTitle.textColor = FISDefaultTextForegroundColor();
    _fisBusinessImageView.contentMode = FISImageViewMode;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect rect;
    rect = _fisBusinessTitle.frame;
    
//    NSString * str = _fisBusinessTitle.text;
    rect.size.width = 300;
    _fisBusinessTitle.frame = rect;
    [_fisBusinessTitle sizeToFit];
    rect = _fisBusinessTitle.frame;
    rect.origin.x = 10;
    rect.origin.y = _fisBusinessImageView.frame.size.height + 10;
    _fisBusinessTitle.frame = rect;
    
    self.bounds = CGRectMake(0, 0, 320, rect.origin.y + rect.size.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_fisBusinessTitle release];
    [super dealloc];
}

@end
