//
//  FISDealsTableViewCell.m
//  FindItSimple
//
//  Created by Jain R on 3/18/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import "FISDealsTableViewCell.h"

@implementation FISDealsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        float x = 8, w = 303, h = 228;
        UIView* view = [[[UIView alloc] initWithFrame:CGRectMake(x, 0, w, h)] autorelease];
        view.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:view];
        
        UIImageView* imageView = nil;
        CGRect frame = CGRectMake(0, 0, w, h);
        imageView = [[[UIImageView alloc] initWithFrame:frame] autorelease];
        imageView.image = [UIImage imageNamed:@"deal_background"];
        [view addSubview:imageView];
        
        imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, w, 182)] autorelease];
        imageView.contentMode = FISImageViewMode;
        self.fisImageView = imageView;
        [view addSubview:imageView];

        imageView = [[[UIImageView alloc] initWithFrame:frame] autorelease];
        imageView.image = [UIImage imageNamed:@"deal_graygradient"];
        [view addSubview:imageView];
        
        imageView = [[[UIImageView alloc] initWithFrame:frame] autorelease];
        imageView.image = [UIImage imageNamed:@"deal_infobar"];
        [view addSubview:imageView];

        imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 30, 98, 26)] autorelease];
        imageView.image = [UIImage imageNamed:@"hand-picked"];
        self.fisHandPickedImageView = imageView;
        [view addSubview:imageView];
        
        imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 30, 98, 26)] autorelease];
        imageView.image = [UIImage imageNamed:@"icon_ribbon_expire"];
        self.fisExpireTodayImageView = imageView;
        [view addSubview:imageView];
        
        UILabel* label = nil;

        label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        label.numberOfLines = 0;
        label.shadowOffset = CGSizeMake(0, 1.5);
        label.shadowColor = [UIColor blackColor];
        self.fisTitleLabel = label;
        [view addSubview:label];
        
        label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        label.numberOfLines = 0;
//        label.shadowOffset = CGSizeMake(0, 2);
//        label.shadowColor = [UIColor blackColor];
        self.fisBusinessLabel = label;
        [view addSubview:label];
        
        label = [[[FISMiddleLineLabel alloc] initWithFrame:CGRectZero] autorelease];
        self.fisOriginalPriceLabel = label;
        [view addSubview:label];
        
        label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        self.fisNewPriceLabel = label;
        [view addSubview:label];
        
        label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        label.text = @"Saved";
        self.fisSavedTitleLabel = label;
        [view addSubview:label];
        
        label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        self.fisSavedCountLabel = label;
        [view addSubview:label];
        
        [self awakeFromNib];

    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    _fisTitleLabel.font = [UIFont fontWithName:FISFONT_BOLD size:15];
    _fisTitleLabel.textColor = FISDefaultForegroundColor();
    _fisBusinessLabel.font = [UIFont fontWithName:FISFONT_BOLD size:11];
    _fisBusinessLabel.textColor = UIColorWithRGBA(187, 187, 187, 1);
    _fisOriginalPriceLabel.font = [UIFont fontWithName:FISFONT_REGULAR size:15];
    _fisOriginalPriceLabel.textColor = UIColorWithRGBA(117, 120, 123, 1);
    _fisNewPriceLabel.font = [UIFont fontWithName:FISFONT_BOLD size:18];
    _fisNewPriceLabel.textColor = FISDefaultBackgroundColor();
    _fisSavedTitleLabel.font = [UIFont fontWithName:FISFONT_REGULAR size:11];
    _fisSavedTitleLabel.textColor = UIColorWithRGBA(117, 120, 123, 1);
    _fisSavedCountLabel.font = [UIFont fontWithName:FISFONT_SEMIBOLD size:11];
    _fisSavedCountLabel.textColor = UIColorWithRGBA(51, 51, 51, 1);
    
    // set mask
    UIImage *maskImage = [UIImage imageNamed:@"deal_mask"];
    CALayer* maskLayer = [CALayer layer];
    maskLayer.frame = _fisImageView.bounds;
    [maskLayer setContents:(id)[maskImage CGImage]];
    _fisImageView.layer.mask = maskLayer;
    
    self.handPicked = NO;
    self.expireToday = NO;
    
}

- (void)setHandPicked:(BOOL)handPicked {
    _handPicked = handPicked;
    self.fisHandPickedImageView.hidden = !_handPicked;
}

- (void)setExpireToday:(BOOL)expireToday {
    _expireToday = expireToday;
    self.fisExpireTodayImageView.hidden = !_expireToday;
}

- (void)setCellType:(NSInteger)cellType {
    _cellType = cellType;
    if (cellType == FISDealsTableViewCellTypeCoupon) {
        _fisHandPickedImageView.image = [UIImage imageNamed:@"icon_ribbon_used"];
        _fisSavedTitleLabel.text = @"Expires";
        _fisSavedTitleLabel.textAlignment = NSTextAlignmentRight;
        _fisSavedCountLabel.textAlignment = NSTextAlignmentRight;
    }
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
         if (connectionError!=nil)
         {
         }
         else
         {
             self.fisImageView.image = [UIImage imageWithData:data];
             self.fisImageView.backgroundColor = [UIColor whiteColor];
         }
     }];
}

- (void)layoutSubviews {

    CGRect rect = CGRectMake(14, 157, 275, 20);
    _fisBusinessLabel.frame = rect;
    [_fisBusinessLabel sizeToFit];
    rect = _fisBusinessLabel.frame;
    rect.origin.y = 228 - 55 - rect.size.height;
    _fisBusinessLabel.frame = rect;
    
    rect = CGRectMake(14, 157, 275, 20);
    _fisTitleLabel.frame = rect;
    [_fisTitleLabel sizeToFit];
    rect = _fisTitleLabel.frame;
    rect.origin.y = _fisBusinessLabel.frame.origin.y - rect.size.height;
    _fisTitleLabel.frame = rect;

    if (self.cellType == FISDealsTableViewCellTypeCoupon) {
        if (self.isHandPicked || self.isExpireToday) {
            self.fisHandPickedImageView.frame = CGRectMake(0, 30, 98, 26);
            self.fisExpireTodayImageView.frame = CGRectMake(0, 30, 98, 26);
        }

        if (self.isHandPicked && self.isExpireToday) {
            self.fisHandPickedImageView.frame = CGRectMake(0, 15, 98, 26);
            self.fisExpireTodayImageView.frame = CGRectMake(0, 45, 98, 26);
        }
        
        _fisOriginalPriceLabel.hidden = YES;
        
        rect = CGRectMake(14, 181, 300, 42);
        [_fisNewPriceLabel sizeToFit];
        rect.size.width = _fisNewPriceLabel.frame.size.width;
        _fisNewPriceLabel.frame = rect;
        
        _fisSavedTitleLabel.frame = CGRectMake(133, 187, 150, 16);
        _fisSavedCountLabel.frame = CGRectMake(133, 200, 150, 16);
        
    }
    else {

        rect = CGRectMake(14, 181, 300, 42);
        [_fisOriginalPriceLabel sizeToFit];
        rect.size.width = _fisOriginalPriceLabel.frame.size.width;
        _fisOriginalPriceLabel.frame = rect;
        
        [_fisNewPriceLabel sizeToFit];
        rect.origin.x += rect.size.width + 10;
        rect.size.width = _fisNewPriceLabel.frame.size.width;
        _fisNewPriceLabel.frame = rect;
        
        _fisSavedTitleLabel.frame = CGRectMake(253, 187, 50, 16);
        _fisSavedCountLabel.frame = CGRectMake(253, 200, 50, 16);
        
    }

    [super layoutSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_fisTitleLabel release];
    [_fisBusinessLabel release];
    [_fisOriginalPriceLabel release];
    [_fisNewPriceLabel release];
    [_fisSavedTitleLabel release];
    [_fisSavedCountLabel release];
    [_fisImageView release];
    [_fisHandPickedImageView release];
    
    self.imageURL = nil;
    [super dealloc];
}

@end
