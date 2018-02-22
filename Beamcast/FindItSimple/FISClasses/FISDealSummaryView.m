//
//  FISDealSummaryView.m
//  FindItSimple
//
//  Created by Jain R on 3/19/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import "FISDealSummaryView.h"

@implementation FISDealSummaryView

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
    _fisDealTitle.font = [UIFont fontWithName:FISFONT_REGULAR size:17];
    _fisDealTitle.textColor = FISDefaultTextForegroundColor();
    _fisOriginalPrice.font = [UIFont fontWithName:FISFONT_REGULAR size:15];
    _fisOriginalPrice.textColor = UIColorWithRGBA(117, 120, 123, 1);
    _fisNewPriceLabel.font = [UIFont fontWithName:FISFONT_BOLD size:18];
    _fisNewPriceLabel.textColor = FISDefaultBackgroundColor();
    _fisSavedTitleLabel.font = [UIFont fontWithName:FISFONT_REGULAR size:11];
    _fisSavedTitleLabel.textColor = UIColorWithRGBA(117, 120, 123, 1);
    _fisSavedCountLabel.font = [UIFont fontWithName:FISFONT_SEMIBOLD size:11];
    _fisSavedCountLabel.textColor = FISDefaultTextForegroundColor();
    _fisDiscountTitleLabel.font = [UIFont fontWithName:FISFONT_REGULAR size:11];
    _fisDiscountTitleLabel.textColor = UIColorWithRGBA(117, 120, 123, 1);
    _fisDiscountValueLabel.font = [UIFont fontWithName:FISFONT_SEMIBOLD size:11];
    _fisDiscountValueLabel.textColor = FISDefaultTextForegroundColor();
    
    _fisDealImageView.contentMode = FISImageViewMode;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect rect;
    rect = _fisDealTitle.frame;
    rect.size.width = 300;
    _fisDealTitle.frame = rect;
    [_fisDealTitle sizeToFit];
    rect = _fisDealTitle.frame;
    rect.origin.x = 10;
    rect.origin.y = _fisDealImageView.frame.size.height + 10;
    _fisDealTitle.frame = rect;
    
    rect = _fisButtonContainer.frame;
    rect.origin.y = _fisDealTitle.frame.origin.y + _fisDealTitle.frame.size.height;
    _fisButtonContainer.frame = rect;
    
    self.bounds = CGRectMake(0, 0, 320, _fisButtonContainer.frame.origin.y + _fisButtonContainer.frame.size.height);
    
    rect = _fisOriginalPrice.frame;
    rect.size.width = 0;
    rect.origin.x -= 10;
    if (_fisOriginalPrice.hidden==NO) {
        [_fisOriginalPrice sizeToFit];
        rect.size.width = _fisOriginalPrice.frame.size.width;
        rect.origin.x += 10;
        _fisOriginalPrice.frame = rect;
    }
    
    rect.origin.x += rect.size.width + 10;
    rect.size.width = 240;
    _fisNewPriceLabel.frame = rect;
    [_fisNewPriceLabel sizeToFit];
    _fisNewPriceLabel.frame = rect;
    
    CGPoint center = _fisNewPriceLabel.center;
    center.y = _fisOriginalPrice.center.y;
    _fisNewPriceLabel.center = center;

    if ([_fisSavedTitleLabel.text isEqualToString:@"Expires"]) {
        rect = _fisSavedTitleLabel.frame;
        rect.origin.x = 143;
        rect.size.width = 150;
        _fisSavedTitleLabel.frame = rect;
        
        rect = _fisSavedCountLabel.frame;
        rect.origin.x = 143;
        rect.size.width = 150;
        _fisSavedCountLabel.frame = rect;
        
        _fisSavedTitleLabel.textAlignment = NSTextAlignmentRight;
        _fisSavedCountLabel.textAlignment = NSTextAlignmentRight;
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_fisDealImageView release];
    [_fisDealTitle release];
    [_fisOriginalPrice release];
    [_fisNewPriceLabel release];
    [_fisDiscountTitleLabel release];
    [_fisSavedTitleLabel release];
    [_fisSavedCountLabel release];
    [_fisDiscountValueLabel release];
    [_fisButtonContainer release];
    [super dealloc];
}
@end
