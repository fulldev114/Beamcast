//
//  FISBusinessSummaryView.m
//  FindItSimple
//
//  Created by Jain R on 3/19/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import "FISBusinessSummaryView.h"

@implementation FISDefaultAnnotation
- (CLLocationCoordinate2D) coordinate
{
	return _currentLocation;
}

@end

@implementation FISBusinessSummaryView

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
    _fisBusinessTitleLabel.font = [UIFont fontWithName:FISFONT_REGULAR size:17];
    _fisBusinessTitleLabel.textColor = FISDefaultTextForegroundColor();
    
#ifdef TEST_CODE
    _fisBusinessTitleLabel.text = @"Grange Cleveland Winery";
#endif
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect rect;
    rect = _fisBusinessTitleLabel.frame;
    rect.size.width = 300;
    _fisBusinessTitleLabel.frame = rect;
    [_fisBusinessTitleLabel sizeToFit];
    rect = _fisBusinessTitleLabel.frame;
    rect.origin.x = 10;
    rect.origin.y = 10;
    _fisBusinessTitleLabel.frame = rect;
    
    rect = _fisBusinessMapView.frame;
    rect.origin.y = _fisBusinessTitleLabel.frame.origin.y + _fisBusinessTitleLabel.frame.size.height + 10;
    _fisBusinessMapView.frame = rect;
    
    self.bounds = CGRectMake(0, 0, 320, _fisBusinessMapView.frame.origin.y + _fisBusinessMapView.frame.size.height);

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_fisBusinessTitleLabel release];
    [_fisBusinessMapView release];
    [super dealloc];
}

@end
