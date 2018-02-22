//
//  FISBeaconAnnotationView.m
//  FindItSimple
//
//  Created by Jain R on 3/21/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import "FISBeaconAnnotationView.h"

@implementation FISBeaconAnnotationView

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
//        self.image = [UIImage imageNamed:@"map_annotationview_beacon"];
        self.centerOffset = CGPointMake(0, -36);
//        self.calloutOffset = CGPointMake(-2, 0);
//        self.iconView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_category_1"]] autorelease];
//        self.iconView.frame = CGRectMake(0, 0, 30, 30);
//        self.iconView.center = CGPointMake(20, 20);
//        [self addSubview:self.iconView];
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
    self.iconView = nil;
    [super dealloc];
}

@end
