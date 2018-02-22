//
//  FISChangeRewardTableCell.m
//  FindItSimple
//
//  Created by PKS on 3/20/15.
//  Copyright (c) 2015 Alex Hong. All rights reserved.
//

#import "FISChangeRewardTableCell.h"

@implementation FISChangeRewardTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        
        [self awakeFromNib];
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    _fisRewardPoint.font = [UIFont fontWithName:FISFONT_REGULAR size:15];
    _fisRewardPoint.textColor = [UIColor grayColor];
    _fisRewardTitle.font = [UIFont fontWithName:FISFONT_BOLD size:18];
    _fisRewardTitle.textColor = FISDefaultBackgroundColor();
}

- (void)setImageURL:(NSString *)imageURL {
    
    imageURL = [FISAppDirectory stringByAddingPercentEscapeUsingUTF8Encoding:imageURL];
    
    if ([_imageURL isEqualToString:imageURL]) {
        return;
    }
    
    self.imageView.image = nil;
    
    [_imageURL release];
    _imageURL = [imageURL copy];
    
    // new download
    NSURLRequest *request = [[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:_imageURL]] autorelease];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         if (connectionError==nil)
         {
             self.fisRewardImageView.image = [UIImage imageWithData:data];
         }
     }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _fisRewardImageView.layer.masksToBounds = YES;
    _fisRewardImageView.layer.cornerRadius = _fisRewardImageView.layer.frame.size.width / 2;
    _fisRewardImageView.layer.borderWidth  = 2.f;
    _fisRewardImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    [_fisRewardTitle sizeToFit];
    
    [_fisRewardPoint sizeToFit];
    
//    rect.size.width = _fisRewardTitle.frame.size.width;
//    _fisRewardTitle.frame = rect;
//    
//    _fisSavedTitleLabel.frame = CGRectMake(253, 187, 50, 16);
//    _fisSavedCountLabel.frame = CGRectMake(253, 200, 50, 16);
//    
//    rect = CGRectMake(14, 157, 275, 20);
//    _fisTitleLabel.frame = rect;
//    [_fisTitleLabel sizeToFit];
//    rect = _fisTitleLabel.frame;
//    rect.origin.y = 228 - 55 - rect.size.height;
//    _fisTitleLabel.frame = rect;
}

- (void)dealloc {
    [_fisRewardTitle release];
    [_fisRewardPoint release];
    [_fisRewardImageView release];
    
    [super dealloc];
}
@end
