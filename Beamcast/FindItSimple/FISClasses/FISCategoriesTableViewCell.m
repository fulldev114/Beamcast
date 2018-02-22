//
//  FISCategoriesTableViewCell.m
//  FindItSimple
//
//  Created by Jain R on 3/14/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import "FISCategoriesTableViewCell.h"

@implementation FISCategoriesTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _fisImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _fisTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _fisSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect tmpFrame = self.imageView.frame;
    tmpFrame.origin.x -= 10;
    tmpFrame.origin.y += 8;
    tmpFrame.size.width = 30;
    tmpFrame.size.height = 30;
    self.imageView.frame = tmpFrame;
    
    tmpFrame = self.textLabel.frame;
    if (self.imageView.image) {
        tmpFrame.origin.x -= 28;
        
    }
    tmpFrame.size.width += 30;
    self.textLabel.frame = tmpFrame;
    
    tmpFrame = self.accessoryView.frame;
    tmpFrame.origin.x += 10;
    self.accessoryView.frame = tmpFrame;
}

- (void)awakeFromNib
{
    _fisTitleLabel.font = [UIFont fontWithName:FISFONT_REGULAR size:16];
    _fisSwitch.onTintColor = FISDefaultBackgroundColor();
#ifdef TEST_CODE
    _fisImageView.image = [UIImage imageNamed:@"icon_favorite"];
    _fisSwitch.on = YES;
#endif
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_fisImageView release];
    [_fisSwitch release];
    [_fisTitleLabel release];
    [super dealloc];
}
@end
