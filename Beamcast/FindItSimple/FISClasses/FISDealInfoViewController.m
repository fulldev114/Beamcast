//
//  FISDealInfoViewController.m
//  FindItSimple
//
//  Created by Jain R on 3/19/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import "FISAppDelegate.h"
#import "FISDealInfoViewController.h"
#import "FISBusinessSummaryView.h"
#import "FISAboutDealView.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Social/Social.h>
#import "FISChangeRewardViewController.h"
#import "FISGetRewardViewController.h"
#import "JKAlertDialog.h"
#import "UILabel+Boldify.h"

@interface FISDealInfoViewController ()

@end

@implementation FISDealInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = [self.info objectForKey:@"business"];
    if (self.type == FISInfoViewControllerTypeReward) {
        NSString * points = [NSString stringWithFormat:@"%ld Points", (long)self.nUserPointsForBusiness];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:points style:UIBarButtonItemStylePlain target:nil action:nil];
    } else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showShareActionSheet)];
    }
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont fontWithName:FISFONT_REGULAR size:15]}];
    
    _fisSaveButton.titleLabel.font = [UIFont fontWithName:FISFONT_SEMIBOLD size:15];
    [_fisSaveButton setTitleColor:FISDefaultForegroundColor() forState:UIControlStateNormal];
    _toolbar.backgroundColor = FISDefaultToolbarBackgroundColor();

    if (self.type == FISInfoViewControllerTypeCoupon) {
        self.fisSaveButton.hidden = YES;
        self.fisRewardButton.hidden = YES;
        BOOL used = [[self.info objectForKey:@"used"] boolValue];
        if (used) {
            self.fisUseButton.hidden = YES;
            self.fisUseLabel.hidden = NO;
            self.fisUseLabel.font = [UIFont fontWithName:FISFONT_REGULAR size:15];
            self.fisUseLabel.textColor = [UIColor whiteColor];
        }
        else {
            self.fisUseButton.hidden = NO;
            self.fisUseLabel.hidden = YES;
        }
    } else if(self.type == FISInfoViewControllerTypeReward) {
        self.fisUseButton.hidden = NO;
        self.fisUseButton.frame = CGRectMake(20, 8, 73, 27);
        [self.fisUseButton setImage:[UIImage imageNamed:@"icon_toolbar_claim"] forState:UIControlStateNormal];
        self.fisSaveButton.hidden = NO;
        if([self.rewards count] > 1) {
            [self.fisSaveButton setImage:[UIImage imageNamed:@"icon_toolbar_change"] forState:UIControlStateNormal];
        } else {
            [self.fisSaveButton setImage:[UIImage imageNamed:@"icon_toolbar_change_gray"] forState:UIControlStateNormal];
        }
        self.fisUseLabel.hidden = YES;
        
        self.fisRewardButton.hidden = NO;
        
        _fisRewardProgress.dataSource = self;
        self.fisRewardProgress.font = [UIFont fontWithName:FISFONT_REGULAR size:16];
        self.fisRewardProgress.popUpViewAnimatedColors = @[[UIColor redColor], [UIColor orangeColor], [UIColor greenColor]];
        [self.fisRewardProgress showPopUpViewAnimated:YES];
        [self refreshProgressView];
    }
    else {

        self.fisSaveButton.hidden = NO;
        self.fisRewardButton.hidden = YES;
        NSString* marktid = [self.info objectForKey:@"own_save"];
        NSString* dealid = [self.info objectForKey:@"id"];
        if ([dealid isEqualToString:marktid]) {
            self.fisSaveButton.selected = YES;
        }
        else {
            self.fisSaveButton.selected = NO;
        }
        self.fisUseButton.hidden = YES;
        self.fisUseLabel.hidden = YES;
        
    }
    
    self.fisTableCellImage = nil;
    
    // add refresh notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPoint) name:FISNOTIFICATION_REFRESH_DEALINFO object:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.type == FISInfoViewControllerTypeReward && [FISAppDirectory isNeedToRefreshWith:@"dealInfoVC"]) {
        [self refreshPoint];
        [FISAppDirectory setNeedToRefresh:NO key:@"dealInfoVC"];
    }
}

-(void) refreshProgressView {
    NSString * points = [self.info objectForKey:@"point"];
    NSInteger rewardPoint = [points integerValue];
    self.fisRewardProgress.hidden = NO;
    
    CGFloat progress = (CGFloat)self.nUserPointsForBusiness / rewardPoint;
    [self.fisRewardProgress setProgress:progress animated:YES];
}

-(void)refreshPoint {
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:self.businessID forKey:@"bus_id"];
    [parameters setObject:FISGetCurrentToken() forKey:@"token"];
    
    [FISWebService sendAsynchronousCommand:ACTION_USER_POINTS_FOR_BUSINESS parameters:parameters completionHandler:^(NSData *response, NSError *error) {
        
        if (error != nil) {
            
        } else {
            // get point
            NSDictionary * point = (NSDictionary *) response;
            
            self.nUserPointsForBusiness = [[point objectForKey:@"cur_point"] integerValue];
            
            NSString * points = [NSString stringWithFormat:@"%d Points", self.nUserPointsForBusiness];
            
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:points style:UIBarButtonItemStylePlain target:nil action:nil];
            
            [self refreshProgressView];
            //[self.tableView reloadData];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_fisSaveButton release];
    [_toolbar release];
    self.info = nil;
    self.indexPath = nil;
    [_tableView release];
    [_fisUseButton release];
    [_fisUseLabel release];
    //remove refresh notification
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_fisRewardButton release];
    [super dealloc];
}

#pragma mark - FISActionSheetDelegate

- (BOOL)actionSheet:(FISActionSheet *)actionsheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	// Determine the sharing content.
	switch (self.type) {
		case FISInfoViewControllerTypeDeal:
			break;
			
		case FISInfoViewControllerTypeArticle:
			break;
			
		case FISInfoViewControllerTypeEvent:
			break;
		
		default:
            return YES;
			break;
	}

    NSString* business = [self.info objectForKey:@"business"]; // "StGeorgeMassage.com"
    NSString* title = [self.info objectForKey:@"simple_title"]; // "One Hour Massage"
    //NSString* fullTitle = [self.info objectForKey:@"full_title"]; // "One hour therapeutic massage"
    NSString* description = [self.info objectForKey:@"description"]; // One hour custom therapeutic ... and injury."
    //NSString* originalPrice = FISAppendStringWithDollar([self.info objectForKey:@"orig_price"]); // 70
    //NSString* newPrice = FISAppendStringWithDollar([self.info objectForKey:@"new_price"]); // 48
    //NSString* discount = FISAppendStringWithDollar([self.info objectForKey:@"discount"]); // 22
    //NSString* savedCount = [self.info objectForKey:@"saved_count"]; // 2
	NSString* dealURL = [self.info objectForKey:@"url"]; // http://www.stgeorgemassage.com
	//NSString* email = [self.info objectForKey:@"usermail"]; // michael@stgeorgemassage.com
	//NSString* phone = [self.info objectForKey:@"phone"]; // 435-215-3480
	//NSString* address = [self.info objectForKey:@"address"]; // 393 East Riverside Drive, Suite 101
	//NSString* lat = [self.info objectForKey:@"latitude"]; // 37.0847
	//NSString* lon = [self.info objectForKey:@"longitude"]; // -113.575

    NSString* pictureURL = [self.info objectForKey:@"picture"];
    if ([pictureURL isKindOfClass:[NSString class]]) {
        //cell.imageURL = pictureURL;
    }

    if (buttonIndex==0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:"]];
    }
	else if (buttonIndex==1) {
		// Check if the Facebook app is installed and we can present the share dialog
//		FBLinkShareParams *params = [[FBLinkShareParams alloc] init];
//		params.link = [NSURL URLWithString:dealURL];
//		params.name = title;
//		params.caption = business;
//		params.linkDescription = description;
//		params.picture = [NSURL URLWithString:pictureURL];

		// If the Facebook app is installed and we can present the share dialog
		/*if ([FBDialogs canPresentShareDialogWithParams:params]) {
			// Present the share dialog
			[FBDialogs presentShareDialogWithLink:params.link
										  handler:
			^(FBAppCall *call, NSDictionary *results, NSError *error) {
											  if(error) {
												  // An error occurred, we need to handle the error
												  // See: https://developers.facebook.com/docs/ios/errors
												  NSLog(@"Error publishing story: %@", error.description);
											  }
											  else {
												  // Success
												  NSLog(@"result %@", results);
											  }
										  }];
		}
		else*/ {
			// Present the feed dialog
			// Put together the dialog parameters
			NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
										   title, @"name",
										   business, @"caption",
										   description, @"description",
										   dealURL, @"link",
										   pictureURL, @"picture",
										   nil];
			
			// Show the feed dialog
			[FBWebDialogs presentFeedDialogModallyWithSession:nil
												   parameters:params
													  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
														  if (error) {
															  // An error occurred, we need to handle the error
															  // See: https://developers.facebook.com/docs/ios/errors
															  NSLog(@"Error publishing story: %@", error.description);
														  } else {
															  if (result == FBWebDialogResultDialogNotCompleted) {
																  // User cancelled.
																  NSLog(@"User cancelled.");
															  } else {
																  /*
																  // Handle the publish feed callback
																  NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
																  
																  if (![urlParams valueForKey:@"post_id"]) {
																	  // User cancelled.
																	  NSLog(@"User cancelled.");
																	  
																  } else {
																	  // User clicked the Share button
																	  NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
																	  NSLog(@"result %@", result);
																  }
																*/
															  }
														  }
													  }];
		}
	}
	else if (buttonIndex==2) {
		if ([SLComposeViewController class]) {
			BOOL isAvailable = [SLComposeViewController isAvailableForServiceType: SLServiceTypeTwitter];
			if (isAvailable) {
				SLComposeViewController *composeVC = [SLComposeViewController composeViewControllerForServiceType: SLServiceTypeTwitter];
				if (composeVC) {
					[composeVC setInitialText:[NSString stringWithFormat:@"%@, %@, %@", title, business, description]];
					[composeVC addURL:[NSURL URLWithString:dealURL]];
					[self presentViewController: composeVC animated: YES completion: nil];
				}
			}
		}
	}
	
	return YES;
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.type == FISInfoViewControllerTypeReward) {
        return 1;
    }
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section==0) {
        return 1;
    }
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section==1) {
        return 30 + self.toolbar.frame.size.height;
    }
    return 15;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        if (self.type==FISInfoViewControllerTypeEvent) {
            return 3;
        }
        return 2;
    }
    else if (section==1) {
        return 5;
    }
    return 0;
}

//- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    UIView* view = [[UIView alloc] init];
//    view.backgroundColor = [UIColor clearColor];
//    if (section==2) {
//        view.frame = CGRectMake(0, 0, 320, 0);
//    }
//    else {
//        view.frame = CGRectMake(0, 0, 320, 15);
//    }
//    return [view autorelease];
//}
//
//- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView* view = [[UIView alloc] init];
//    view.backgroundColor = [UIColor clearColor];
//    if (section==0) {
//        view.frame = CGRectMake(0, 0, 320, 0);
//    }
//    else {
//        view.frame = CGRectMake(0, 0, 320, 15);
//    }
//    return [view autorelease];
//}
//
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            FISDealSummaryView* cell = [tableView dequeueReusableCellWithIdentifier:@"FISDealSummaryView"];
            cell.fisDealTitle.text = [self.info objectForKey:@"full_title"];

            [cell layoutIfNeeded];
            return cell.bounds.size.height;
        }
        else if (indexPath.row==1) {
            UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 290, 0)];
            label.numberOfLines = 0;
            label.font = [UIFont fontWithName:FISFONT_REGULAR size:14];
            label.text = [self.info objectForKey:@"description"];
            [label sizeToFit];
            return label.frame.size.height+40;
        }
        else {
            if (self.type==FISInfoViewControllerTypeEvent) {
                UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 290, 0)];
                label.numberOfLines = 0;
                label.font = [UIFont fontWithName:FISFONT_REGULAR size:14];
                label.text = [self.info objectForKey:@"eaddr"];
                [label sizeToFit];
                return label.frame.size.height+40;
            }
            return 0;
        }
    }
    else if (indexPath.section==1) {
        if (indexPath.row==0) {
            FISBusinessSummaryView* cell = [tableView dequeueReusableCellWithIdentifier:@"FISBusinessSummaryView"];
            [cell layoutIfNeeded];
            
            return cell.bounds.size.height;
        }
        return 44;
    }
    
    if (indexPath.row==0) {
        return 44;
    }
    return 200;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellID = @"normalCell";

    if (indexPath.section==0) {
        if (indexPath.row == 0) {
            FISDealSummaryView* cell = [tableView dequeueReusableCellWithIdentifier:@"FISDealSummaryView"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if (self.fisTableCellImage != nil) {
                cell.fisDealImageView.image = self.fisTableCellImage;
            } else {
                [cell.fisDealImageView setURLWith:[self.info objectForKey:@"picture"]];
                self.fisTableCellImage = cell.fisDealImageView.image;
            }

            cell.fisDealTitle.text = [self.info objectForKey:@"full_title"];
            
            switch (self.type) {
                case FISInfoViewControllerTypeDeal:
                    cell.fisOriginalPrice.text = FISAppendStringWithDollar([self.info objectForKey:@"orig_price"]);
                    cell.fisNewPriceLabel.text = FISAppendStringWithDollar([self.info objectForKey:@"new_price"]);
                    cell.fisDiscountValueLabel.text = FISAppendStringWithPercent([self.info objectForKey:@"discount"]);
                    cell.fisSavedCountLabel.text = [self.info objectForKey:@"saved_count"];
                    break;
                    
                case FISInfoViewControllerTypeArticle:
                    cell.fisOriginalPrice.hidden = YES;
                    
                    cell.fisNewPriceLabel.text = FISAppendStringWithDate([self.info objectForKey:@"last_modified"]);
                    
                    cell.fisDiscountValueLabel.hidden = YES;
                    cell.fisDiscountTitleLabel.hidden = YES;
                    cell.fisSavedCountLabel.text = [self.info objectForKey:@"saved_count"];
                   break;
                    
                case FISInfoViewControllerTypeEvent:
                    cell.fisOriginalPrice.hidden = YES;
                    
                    NSString* begin = FISAppendStringWithDate([self.info objectForKey:@"begin_time"]);
                    NSString* end = FISAppendStringWithDate([self.info objectForKey:@"end_time"]);
                    if ([begin isEqualToString:end]) {
                        cell.fisNewPriceLabel.text = begin;
                    }
                    else {
                        cell.fisNewPriceLabel.text = [begin stringByAppendingFormat:@" - \n%@", end];
                        cell.fisNewPriceLabel.font = [UIFont fontWithName:FISFONT_BOLD size:12];
                        cell.fisNewPriceLabel.numberOfLines = 2;
                    }
                    
                    cell.fisDiscountValueLabel.hidden = YES;
                    cell.fisDiscountTitleLabel.hidden = YES;
                    cell.fisSavedCountLabel.text = [self.info objectForKey:@"saved_count"];
                    break;
                    
                case FISInfoViewControllerTypeCoupon:
                    cell.fisOriginalPrice.hidden = YES;
                    
                    cell.fisNewPriceLabel.text = [NSString stringWithFormat:@"Save %@", FISAppendStringWithDollar([self.info objectForKey:@"coupon_price"])];
                    
                    cell.fisDiscountValueLabel.hidden = YES;
                    cell.fisDiscountTitleLabel.hidden = YES;
                    cell.fisSavedTitleLabel.text = @"Expires";
                    cell.fisSavedCountLabel.text = FISAppendStringWithDate([self.info objectForKey:@"coupon_end_time"]);
                    break;
                case FISInfoViewControllerTypeReward:
                {
                    NSString * points = [self.info objectForKey:@"point"];
                    cell.fisOriginalPrice.hidden = YES;
                    cell.fisNewPriceLabel.hidden = YES;
                    cell.fisSavedTitleLabel.text = @"Point";
                    
                    cell.fisSavedCountLabel.text = points;
                    cell.fisDiscountValueLabel.hidden = YES;
                    cell.fisDiscountTitleLabel.hidden = YES;
                    
                    self.fisRewardProgress.hidden = NO;
                    
                    break;
                }
                    
                default:
                    break;
            }
            [cell layoutIfNeeded];
            return cell;
        }
        else if (indexPath.row==1) {
            UITableViewCell* cell = nil;
            cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (cell==nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
                cell.textLabel.font = [UIFont fontWithName:FISFONT_REGULAR size:14];
                cell.textLabel.textColor = UIColorWithRGBA(117, 120, 123, 1);
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.text = [self.info objectForKey:@"description"];
            cell.imageView.image = nil;
            [cell layoutIfNeeded];
            return cell;
        }
        if (self.type==FISInfoViewControllerTypeEvent) {
            UITableViewCell* cell = nil;
            cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (cell==nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
                cell.textLabel.font = [UIFont fontWithName:FISFONT_REGULAR size:14];
                cell.textLabel.textColor = UIColorWithRGBA(117, 120, 123, 1);
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.text = [self.info objectForKey:@"eaddr"];
            cell.imageView.image = nil;
            [cell layoutIfNeeded];
            return cell;
        }
        return nil;
        
    }
    else if (indexPath.section==1) {
        if (indexPath.row==0) {
            FISBusinessSummaryView* cell = [tableView dequeueReusableCellWithIdentifier:@"FISBusinessSummaryView"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            CLLocationCoordinate2D location;

            cell.fisBusinessTitleLabel.text = [self.info objectForKey:@"business"];
            
#ifdef TEST_CODE
            location.latitude = 40.14601; //[[self.info objectForKey:@"latitude"] doubleValue];
            location.longitude = 124.30101;//[[self.info objectForKey:@"longitude"] doubleValue];
#else
            location.latitude = [[self.info objectForKey:@"latitude"] doubleValue];
            location.longitude = [[self.info objectForKey:@"longitude"] doubleValue];
#endif

            // init mapview
            [cell.fisBusinessMapView setMapType:MKMapTypeStandard];
            [cell.fisBusinessMapView setZoomEnabled:YES];
            [cell.fisBusinessMapView setScrollEnabled:YES];
            [cell.fisBusinessMapView setDelegate:self];
            
            FISDefaultAnnotation *ann = [[[FISDefaultAnnotation alloc] init] autorelease];
            ann.currentLocation = location;
            ann.title = cell.fisBusinessTitleLabel.text;
            ann.color = MKPinAnnotationColorRed;
            [cell.fisBusinessMapView addAnnotation:ann];
            
            if (self.type==FISInfoViewControllerTypeEvent) {
                location.latitude = [[self.info objectForKey:@"elat"] doubleValue];
                location.longitude = [[self.info objectForKey:@"elong"] doubleValue];
                ann = [[[FISDefaultAnnotation alloc] init] autorelease];
                ann.currentLocation = location;
                ann.title = [self.info objectForKey:@"simple_title"];
                ann.color = MKPinAnnotationColorGreen;
                [cell.fisBusinessMapView addAnnotation:ann];
            }
            
            MKCoordinateRegion region;
            region.center = location;
            region.span.longitudeDelta = 0.01f;
            region.span.latitudeDelta = 0.01f;
            [cell.fisBusinessMapView setRegion:region animated:YES];
            return cell;
        }
        
        UITableViewCell* cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell==nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
            cell.textLabel.font = [UIFont fontWithName:FISFONT_REGULAR size:12];
            cell.textLabel.textColor = UIColorWithRGBA(117, 120, 123, 1);
        }

        if (indexPath.row==1) {
            cell.imageView.image = [UIImage imageNamed:@"dealinfo_phone"];
            cell.textLabel.text = [self.info objectForKey:@"phone"];
        }
        else if (indexPath.row==2) {
            cell.imageView.image = [UIImage imageNamed:@"dealinfo_mail"];
            cell.textLabel.text = [self.info objectForKey:@"usermail"];
        }
        else if (indexPath.row==3) {
            cell.imageView.image = [UIImage imageNamed:@"dealinfo_address"];
            cell.textLabel.text = [self.info objectForKey:@"address"];
        }
        else if (indexPath.row==4) {
            cell.imageView.image = [UIImage imageNamed:@"dealinfo_go"];
            cell.textLabel.text = [self.info objectForKey:@"url"];
        }
        
        cell.textLabel.numberOfLines = 0;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    if (indexPath.row==0) {
        UITableViewCell* cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell==nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
            cell.textLabel.font = [UIFont fontWithName:FISFONT_REGULAR size:17];
            cell.textLabel.textColor = FISDefaultTextForegroundColor();
            cell.textLabel.text = @"About This Deal";
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    FISAboutDealView* cell = [tableView dequeueReusableCellWithIdentifier:@"FISAboutDealView"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* text = nil;
    NSURL* url = nil;
    if (indexPath.section==1) {
        if (indexPath.row==1) {
            text = [self.info objectForKey:@"phone"];
            if (text.length!=0) {
                text = [[text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
                url = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", text]];
            }
        }
        else if (indexPath.row==2) {
            text = [self.info objectForKey:@"usermail"];
            if (text.length!=0) {
                url = [NSURL URLWithString:[NSString stringWithFormat:@"mailto:%@", text]];
            }
        }
        else if (indexPath.row==3) {
            text = [self.info objectForKey:@"address"];
        }
        else if (indexPath.row==4) {
            text = [self.info objectForKey:@"url"];
            text = [text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString* prefix = [text substringToIndex:7];
            if (![prefix isEqualToString:@"http://"]) {
                text = [NSString stringWithFormat:@"http://%@", text];
            }
            if (text.length!=0) {
                url = [NSURL URLWithString:text];
            }
        }

        if (url) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UIAction
- (void)showShareActionSheet {
    FISActionSheet* actionsheet = [[FISActionSheet alloc] initWithFrame:CGRectZero];
    
    UIButton* button;
    UIImage* buttonImage;
    
    buttonImage = [UIImage imageNamed:@"actionsheet_mail"];
    button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height)];
    [button setImage:buttonImage forState:UIControlStateNormal];
    [actionsheet addButton:button];
    [button release];
    buttonImage = [UIImage imageNamed:@"actionsheet_facebook"];
    button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height)];
    [button setImage:buttonImage forState:UIControlStateNormal];
    [actionsheet addButton:button];
    [button release];
    buttonImage = [UIImage imageNamed:@"actionsheet_tweet"];
    button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height)];
    [button setImage:buttonImage forState:UIControlStateNormal];
    [actionsheet addButton:button];
    [button release];
    buttonImage = [UIImage imageNamed:@"actionsheet_cancel"];
    button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height)];
    [button setImage:buttonImage forState:UIControlStateNormal];
    [actionsheet addButton:button isCancelButton:YES];
    [button release];
    
    actionsheet.delegate = self;
    actionsheet.backgroundColor = UIColorWithRGBA(19, 19, 19, 1);
    [actionsheet showInView:self.view];
    [actionsheet release];
}

- (void) goGetReward {
    FISGetRewardViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FISGetRewardViewController-568h"];
    
    FISNavigationController* navigation = [[FISNavigationController alloc] initWithRootViewController:vc];
    
    vc.rewardType = FISGetRewardViewControllerTypeQRCode;
    [self presentViewController:navigation animated:YES completion:^{
        vc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"icon_leftbarbutton_close2"] imageWithRenderingMode:UIImageRenderingModeAutomatic] style:UIBarButtonItemStyleBordered target:vc action:@selector(goBack)];
    }];
    return;
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont fontWithName:FISFONT_BOLD size:FISFONT_NAVIGATION_TITLESIZE]}];
}

- (IBAction)saveButtonClicked:(UIButton *)sender {
    if (self.type == FISInfoViewControllerTypeReward) {
        
        if ([self.rewards count] > 1) {
            FISChangeRewardViewController* changeRewardViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FISChangeRewardViewController-568h"];
            
            changeRewardViewController.rewards = [self.rewards mutableCopy];
            changeRewardViewController.delegate = self;
            [self.navigationController pushViewController:changeRewardViewController animated:YES];
        }
        return;
    }
    
    if (self.type == FISInfoViewControllerTypeCoupon) {
        return;
    }

    NSString* token = FISGetCurrentToken();
    if (token.length==0) {
        UIAlertView* alret = [[[UIAlertView alloc] initWithTitle:FISDefaultAlertTitle message:@"Please Sign in on Profile Page" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] autorelease];
        [alret show];
        return;
    }

    [[FISAppLocker sharedLocker] lockApp];

    NSString* marktype = nil;
    switch (self.type) {
        case FISInfoViewControllerTypeDeal:
            marktype = TYPE_DEAL;
            break;
            
        case FISInfoViewControllerTypeArticle:
            marktype = TYPE_ARTICLE;
            break;
            
        case FISInfoViewControllerTypeEvent:
            marktype = TYPE_EVENT;
            break;
            
        default:
            break;
    }
    NSString* markid = [self.info objectForKey:@"id"];
    NSString* businessid = [self.info objectForKey:@"bus_id"];
    
    if (sender.selected==NO) {
        // add saving
        [FISWebService sendAsynchronousCommand:ACTION_ADD_SAVING parameters:@{@"token": token, @"marktype": marktype, @"markid": markid, @"bus_id": businessid} completionHandler:^(NSData *response, NSError *error) {
            NSLog(@"error:%@\n\nresponse:\n%@", error, response);
            if (error!=nil) {
                UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] autorelease];
                [alert show];
            }
            else {
                [self.info setObject:markid forKey:@"own_save"];
                int savedCount = [[self.info objectForKey:@"saved_count"] intValue];
                savedCount++;
                [self.info setObject:[NSString stringWithFormat:@"%d", savedCount] forKey:@"saved_count"];
//                [self.tableView reloadData];
                NSMutableDictionary* globalInfo = [NSMutableDictionary dictionaryWithDictionary:[FISAppDirectory getUserInfo]];
                savedCount = 0;
                switch (self.type) {
                    case FISInfoViewControllerTypeDeal:
                        savedCount = [[globalInfo objectForKey:@"g_deal_cnt"] intValue];
                        savedCount++;
                        [globalInfo setObject:[NSString stringWithFormat:@"%d", savedCount] forKey:@"g_deal_cnt"];
                        break;
                        
                    case FISInfoViewControllerTypeArticle:
                        savedCount = [[globalInfo objectForKey:@"g_article_cnt"] intValue];
                        savedCount++;
                        [globalInfo setObject:[NSString stringWithFormat:@"%d", savedCount] forKey:@"g_article_cnt"];
                        break;
                        
                    case FISInfoViewControllerTypeEvent:
                        savedCount = [[globalInfo objectForKey:@"g_event_cnt"] intValue];
                        savedCount++;
                        [globalInfo setObject:[NSString stringWithFormat:@"%d", savedCount] forKey:@"g_event_cnt"];
                        break;
                        
                    default:
                        break;
                }
                [FISAppDirectory setUserInfo:globalInfo];


                if ([self.delegate respondsToSelector:@selector(saveDeal:indexPath:saved:)]) {
                    [self.delegate saveDeal:self indexPath:self.indexPath saved:YES];
                }
                sender.selected = YES;
            }
            [[FISAppLocker sharedLocker] unlockApp];
        }];
    }
    else {
        // remove saving
        [FISWebService sendAsynchronousCommand:ACTION_REMOVE_SAVING parameters:@{@"token": token, @"marktype": marktype, @"markid": markid} completionHandler:^(NSData *response, NSError *error) {
            NSLog(@"error:%@\n\nresponse:\n%@", error, response);
            if (error!=nil) {
                UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] autorelease];
                [alert show];
            }
            else {
                [self.info setObject:@"-1" forKey:@"own_save"];
                int savedCount = [[self.info objectForKey:@"saved_count"] intValue];
                savedCount--;
                [self.info setObject:[NSString stringWithFormat:@"%d", savedCount] forKey:@"saved_count"];
//                [self.tableView reloadData];

                NSMutableDictionary* globalInfo = [NSMutableDictionary dictionaryWithDictionary:[FISAppDirectory getUserInfo]];
                savedCount = 0;
                switch (self.type) {
                    case FISInfoViewControllerTypeDeal:
                        savedCount = [[globalInfo objectForKey:@"g_deal_cnt"] intValue];
                        savedCount--;
                        [globalInfo setObject:[NSString stringWithFormat:@"%d", savedCount] forKey:@"g_deal_cnt"];
                        break;
                        
                    case FISInfoViewControllerTypeArticle:
                        savedCount = [[globalInfo objectForKey:@"g_article_cnt"] intValue];
                        savedCount--;
                        [globalInfo setObject:[NSString stringWithFormat:@"%d", savedCount] forKey:@"g_article_cnt"];
                        break;
                        
                    case FISInfoViewControllerTypeEvent:
                        savedCount = [[globalInfo objectForKey:@"g_event_cnt"] intValue];
                        savedCount--;
                        [globalInfo setObject:[NSString stringWithFormat:@"%d", savedCount] forKey:@"g_event_cnt"];
                        break;
                        
                    default:
                        break;
                }
                [FISAppDirectory setUserInfo:globalInfo];

                if ([self.delegate respondsToSelector:@selector(saveDeal:indexPath:saved:)]) {
                    [self.delegate saveDeal:self indexPath:self.indexPath saved:NO];
                }
                sender.selected = NO;
            }
            [[FISAppLocker sharedLocker] unlockApp];
        }];
    }
}

- (IBAction)useButtonClicked:(UIButton *)sender {
    if (self.type == FISInfoViewControllerTypeReward) {
        if (self.fisRewardProgress.progress < 1.f) {
            UIAlertView* alertUse = [[[UIAlertView alloc] initWithTitle:FISDefaultAlertTitle message:@"You do not have enough points for this reward" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] autorelease];
            [alertUse show];

        } else {
            UIAlertView* alertUse = [[[UIAlertView alloc] initWithTitle:FISDefaultAlertTitle message:[NSString stringWithFormat:@"Please show this message to employee to claim your %@", [self.info objectForKey:@"full_title"]] delegate:self cancelButtonTitle:@"Claim Reward" otherButtonTitles:@"Cancel", nil] autorelease];
            alertUse.tag = 10003;
            [alertUse show];
        }
        return;
    }
    
    if (self.type != FISInfoViewControllerTypeCoupon) {
        return;
    }
    
    NSString* token = FISGetCurrentToken();
    if (token.length==0) {
        UIAlertView* alret = [[[UIAlertView alloc] initWithTitle:FISDefaultAlertTitle message:@"Please Sign in on Profile Page" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] autorelease];
        [alret show];
        return;
    }
    
    UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Enter MasterKey" message:@"Please present to the Business Owner" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil] autorelease];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField* textField = [alert textFieldAtIndex:0];
    textField.keyboardType = UIKeyboardTypeNumberPad;
    [alert show];
}

- (IBAction)rewardButtonClicked:(id)sender {
    FISAppDelegate* appDelegate = (FISAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSArray * detectedBeacons = [BeaconTracker sharedBeaconTracker].detectedBeacons;
    
    if ([detectedBeacons count] < 1) {
        FISNoValidBeaconAlert()
    }
    
    NSMutableArray * beacons = [NSMutableArray array];
    
    for (CLBeacon* detectedBeacon in detectedBeacons) {
        [beacons addObject:[NSArray arrayWithObjects:[NSNumber numberWithInteger:detectedBeacon.major.integerValue], [NSNumber numberWithInteger:detectedBeacon.minor.integerValue], nil]];
    }
    [[FISAppLocker sharedLocker] lockApp];
    [appDelegate processToGetPoints:beacons from:FIS_CALL_GET_POINTS_FROM_DEAL_INFO_VC];
}

#pragma use points

-(void) usePointsForReward {
    if ([[self.info objectForKey:@"chk_key"] isEqualToString:@"required"]) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:FISDefaultAlertTitle message:@"Owner Code" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel", nil];
        alertView.alertViewStyle = UIAlertViewStyleSecureTextInput;
        alertView.tag = 10004;
        [alertView show];
    } else {
        [self requestForUseRewardToWeb:nil];
    }
}

-(void) requestForUseRewardToWeb:(NSString *) owner_code {
    NSString* token = FISGetCurrentToken();
    if (token.length==0) {
        FISNeedSignInAlert();
        return;
    }
    [[FISAppLocker sharedLocker] lockApp];
    
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:self.businessID forKey:@"bus_id"];
    [parameters setObject:token forKey:@"token"];
    [parameters setObject:[self.info objectForKey:FIS_PARAM_BUSINESS_REWARD_ID] forKey:@"reward_id"];
    [parameters setObject:[self.info objectForKey:FIS_PARAM_BUSINESS_REWARD_POINT] forKey:@"point"];
    if (owner_code.length != 0) {
        [parameters setObject:owner_code forKey:@"owner_code"];
    }
    
    // use points
    [FISWebService sendAsynchronousCommand:ACTION_USE_POINTS_FOR_REWARD parameters:parameters completionHandler:^(NSData *response, NSError *error) {
        NSLog(@"error:%@\n\nresponse:\n%@", error, response);
        if (error!=nil) {
            UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to Claim Reward." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] autorelease];
            [alert show];
        }
        else {
            NSDictionary * info = (NSDictionary *)response;
            NSString * user_point = [info objectForKey:@"cur_point"];
            NSString * message = [NSString stringWithFormat:@"Congratulations, you have used %@ points to claim your %@.\nYou now have %@ points",[self.info objectForKey:FIS_PARAM_BUSINESS_REWARD_POINT],[self.info objectForKey:@"full_title"],user_point];
            
            
            
            JKAlertDialog* alert = [[JKAlertDialog alloc] initWithTitle:FISDefaultAlertTitle message:message];
            
            UILabel * myLabel = alert._labelmessage;
            
            [myLabel boldSubstring:[self.info objectForKey:FIS_PARAM_BUSINESS_REWARD_POINT]];
            [myLabel boldSubstring:[self.info objectForKey:@"full_title"]];
            //[myLabel boldSubstring:[NSString stringWithFormat:@"%@", user_point]];
            
            [alert addButtonWithTitle:@"OK"];
            
            [alert show];
            
            [self performSelector:@selector(DismissDialog:) withObject:alert afterDelay:3.0f];
            
            [self refreshPoint];
            [[NSNotificationCenter defaultCenter] postNotificationName:FISNOTIFICATION_REFRESH_DEALSVC object:nil];
        }
        [[FISAppLocker sharedLocker] unlockApp];
    }];
}

- (void) DismissDialog:(JKAlertDialog*) alert {
    [alert dismiss];
}

#pragma mark - <UIAlertViewDelegate>
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 10003) {
        if (buttonIndex == 0) {
            [self usePointsForReward];
        }
        return;
    } else if (alertView.tag == 10004) {
        if (buttonIndex == 0) {
            NSString * ownerCode = [alertView textFieldAtIndex:0].text;
            if (ownerCode.length == 0) {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:FISDefaultAlertTitle message:@"Please insert owner code" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                
                [alert show];
            }
            [self requestForUseRewardToWeb:ownerCode];
        } else {
            return;
        }
    }
    
    if (buttonIndex == 1) {

        [[FISAppLocker sharedLocker] lockApp];
        
        NSString* token = FISGetCurrentToken();
        if (token.length==0) {
            UIAlertView* alret = [[[UIAlertView alloc] initWithTitle:FISDefaultAlertTitle message:@"Please Sign in on Profile Page" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] autorelease];
            [alret show];
            return;
        }
        
        NSString* markid = [self.info objectForKey:@"coupon_id"];
        NSString* masterkey = [alertView textFieldAtIndex:0].text;
        if (masterkey == nil) {
            masterkey = @"";
        }
        
        // add saving
        [FISWebService sendAsynchronousCommand:ACTION_USE_COUPON parameters:@{@"token": token, @"id": markid, @"master_key": masterkey} completionHandler:^(NSData *response, NSError *error) {
            NSLog(@"error:%@\n\nresponse:\n%@", error, response);
            if (error!=nil) {
                UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter correct MasterKey." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] autorelease];
                [alert show];
            }
            else {

                if ([self.delegate respondsToSelector:@selector(useCoupon:indexPath:)]) {
                    [self.delegate useCoupon:self indexPath:self.indexPath];
                }
                
                self.fisUseButton.hidden = YES;
                self.fisUseLabel.hidden = NO;
                self.fisUseLabel.font = [UIFont fontWithName:FISFONT_REGULAR size:15];
                self.fisUseLabel.textColor = [UIColor whiteColor];

            }
            [[FISAppLocker sharedLocker] unlockApp];
        }];
        
    }
}

#pragma mark - map delegate
- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    MKPinAnnotationView *pinView = nil;
    if(annotation != mapView.userLocation)
    {
        static NSString *defaultPinID = @"aPin";
        pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if ( pinView == nil )
            pinView = [[[MKPinAnnotationView alloc]
                        initWithAnnotation:annotation reuseIdentifier:defaultPinID] autorelease];
        pinView.canShowCallout = YES;
        pinView.animatesDrop = YES;
    } else {
    }

    if ([annotation isKindOfClass:[FISDefaultAnnotation class]]) {
        pinView.pinColor = [(FISDefaultAnnotation*)annotation color];
    }
    return pinView;
}

#pragma mark - chagne reward delegate
-(void) changeReward:(NSInteger)index {
    self.info = [self.rewards objectAtIndex:index];
    [self refreshProgressView];
    [self.tableView reloadData];
}

#pragma mark - ASProgressPopUpView dataSource

// <ASProgressPopUpViewDataSource> is entirely optional
// it allows you to supply custom NSStrings to ASProgressPopUpView
- (NSString *)progressView:(ASProgressPopUpView *)progressView stringForProgress:(float)progress
{
    NSString *s = nil;
    if (progress < 0.2) {
        s = @"Just starting";
    } else if (progress > 0.4 && progress < 0.6) {
        s = @"About halfway";
    } else if (progress > 0.75 && progress < 1.0) {
        s = @"Nearly there";
    } else if (progress >= 1.0) {
        s = @"Complete";
    }
    return s;
}

// by default ASProgressPopUpView precalculates the largest popUpView size needed
// it then uses this size for all values and maintains a consistent size
// if you want the popUpView size to adapt as values change then return 'NO'
- (BOOL)progressViewShouldPreCalculatePopUpViewSize:(ASProgressPopUpView *)progressView;
{
    return NO;
}


@end
