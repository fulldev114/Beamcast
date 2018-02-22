//
//  FISAboutDealView.m
//  FindItSimple
//
//  Created by Jain R on 3/19/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import "FISAboutDealView.h"

@implementation FISAboutDealView

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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_fisWebView release];
    [super dealloc];
}
@end
