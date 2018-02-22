//
//  FISPhotoAnnotationView.m
//  FindItSimple
//
//  Created by Jain R on 3/21/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import "FISPhotoAnnotationView.h"

@implementation FISPhotoAnnotationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.image = [UIImage imageNamed:@"map_annotationview_me_mask"];
        self.centerOffset = CGPointMake(3, -26);
        self.calloutOffset = CGPointMake(-3, 0);
        self.photoView = [[[UIImageView alloc] initWithFrame:CGRectMake(4, 2, 47, 47)] autorelease];
        self.photoView.image = [UIImage imageNamed:@"menu_avatar_sample2"];
        UIImage *maskImage = [UIImage imageNamed:@"map_annotationview_me_mask"];
        CALayer* maskLayer = [CALayer layer];
        maskLayer.frame = CGRectMake(-4, -2, self.bounds.size.width, self.bounds.size.height);
        [maskLayer setContents:(id)[maskImage CGImage]];
        self.photoView.layer.mask = maskLayer;
        [self addSubview:self.photoView];

        UIImageView* pinImageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"map_annotationview_me"]] autorelease];
        [self addSubview:pinImageView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc {
    self.photoView = nil;
    [super dealloc];
}

@end
