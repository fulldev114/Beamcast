//
//  FISPopupTableViewCell.m
//  FindItSimple
//
//  Created by Jain R on 5/3/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import "FISPopupTableViewCell.h"

@implementation FISPopupTableViewCell

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
    self.fisImageView.backgroundColor = [UIColor blackColor];
    self.fisTitleLabel.font = [UIFont fontWithName:FISFONT_REGULAR size:12];
    self.fisImageView.contentMode = FISImageViewMode;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_fisImageView release];
    [_fisTitleLabel release];
    [_fisBackgroundView release];
    [super dealloc];
}
@end
