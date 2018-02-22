//
//  FISArticleSummaryView.m
//  FindItSimple
//
//  Created by Jain R on 3/24/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import "FISArticleSummaryView.h"

@implementation FISArticleSummaryView

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
    _fisArticleTitle.font = [UIFont fontWithName:FISFONT_REGULAR size:17];
    _fisArticleTitle.textColor = FISDefaultTextForegroundColor();
    _fisDateLabel.font = [UIFont fontWithName:FISFONT_BOLD size:18];
    _fisDateLabel.textColor = FISDefaultBackgroundColor();
    _fisSavedTitleLabel.font = [UIFont fontWithName:FISFONT_REGULAR size:11];
    _fisSavedTitleLabel.textColor = UIColorWithRGBA(117, 120, 123, 1);
    _fisSavedCountLabel.font = [UIFont fontWithName:FISFONT_SEMIBOLD size:11];
    _fisSavedCountLabel.textColor = FISDefaultTextForegroundColor();
#ifdef TEST_CODE
    _fisArticleTitle.text = @"$99 Classic 3/4 UGG Boots Available in a Range of Colours and Sizes, includes Nationwide Delivery($239 Value)";
#endif
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect rect;
    rect = _fisArticleTitle.frame;
    rect.size.width = 300;
    _fisArticleTitle.frame = rect;
    [_fisArticleTitle sizeToFit];
    rect = _fisArticleTitle.frame;
    rect.origin.x = 10;
    rect.origin.y = _fisArticleImageView.frame.size.height + 10;
    _fisArticleTitle.frame = rect;
    
    rect = _fisButtonContainer.frame;
    rect.origin.y = _fisArticleTitle.frame.origin.y + _fisArticleTitle.frame.size.height + 10;
    _fisButtonContainer.frame = rect;
    
    self.bounds = CGRectMake(0, 0, 320, _fisButtonContainer.frame.origin.y + _fisButtonContainer.frame.size.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)dealloc {
    [_fisArticleImageView release];
    [_fisArticleTitle release];
    [_fisDateLabel release];
    [_fisSavedTitleLabel release];
    [_fisSavedCountLabel release];
    [_fisButtonContainer release];
    [super dealloc];
}

@end
