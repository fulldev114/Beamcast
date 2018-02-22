//
//  FISBusinessSummaryView.h
//  FindItSimple
//
//  Created by Jain R on 3/19/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FISDealInfoViewController.h"

@interface FISDefaultAnnotation : NSObject<MKAnnotation>
@property (nonatomic, assign) CLLocationCoordinate2D currentLocation;
@property (nonatomic, copy) NSString* title;
@property (nonatomic, assign) MKPinAnnotationColor color;
@end

@interface FISBusinessSummaryView : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *fisBusinessTitleLabel;
@property (retain, nonatomic) IBOutlet MKMapView *fisBusinessMapView;
@end


