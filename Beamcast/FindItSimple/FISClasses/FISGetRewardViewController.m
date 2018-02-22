//
//  FISGetRewardViewController.m
//  FindItSimple
//
//  Created by PKS on 3/20/15.
//  Copyright (c) 2015 Alex Hong. All rights reserved.
//

#import "FISGetRewardViewController.h"

@interface FISGetRewardViewController ()
@end

@implementation FISGetRewardViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Get Reward";
    
    // init lock view
    self.lockBackgroundView.backgroundColor = UIColorWithRGBA(0, 0, 0, 0.0f);
    self.lockAnimationContainerView.backgroundColor = UIColorWithRGBA(19, 19, 19, 1);
    self.lockLabel.textColor = UIColorWithRGBA(255, 255, 255, 1);
    self.lockLabel.font = [UIFont fontWithName:FISFONT_SEMIBOLD size:12];
    self.lockAnimationContainerView.layer.cornerRadius = 5.0f;
    self.lockAnimationContainerView.layer.masksToBounds = YES;
    
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_navigation_reward"] style:UIBarButtonItemStylePlain target:self action:@selector(requestGetPoints)];
    
    // iniitalize cell subviews
    self.fisRewardTypeSwitch = [[[UISwitch alloc] init] autorelease];
    [self.fisRewardTypeSwitch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.fisRewardTypeSwitch.onTintColor = FISDefaultBackgroundColor();
    
    if (self.rewardType == FISGetRewardViewControllerTypeBoth) {
        [self.fisRewardTypeSwitch setEnabled:YES];
        self.rewardType = FISGetRewardViewControllerTypeManual;
    } else {
        [self.fisRewardTypeSwitch setEnabled:NO];
    }
    
    CGRect rect = CGRectMake(140, 10, 120, 30);
    
    self.fisProductName = [[UITextField alloc] initWithFrame:rect];
    self.fisProductName.placeholder = @"Unknown";
    self.fisProductName.textAlignment = NSTextAlignmentRight;
    self.fisProductName.font = [UIFont fontWithName:FISFONT_REGULAR size:16];
    self.fisProductName.textColor = [UIColor grayColor];
    
    self.fisQRCodeName = [[UITextField alloc] initWithFrame:rect];
    self.fisQRCodeName.placeholder = @"Unknown";
    self.fisQRCodeName.textAlignment = NSTextAlignmentRight;
    self.fisQRCodeName.font = [UIFont fontWithName:FISFONT_REGULAR size:16];
    self.fisQRCodeName.textColor = [UIColor grayColor];
    
    [self.fisAmount removeFromSuperview];
    self.fisAmount = [[UITextField alloc] initWithFrame:rect];
    self.fisAmount.placeholder = @"0.0";
    self.fisAmount.keyboardType = UIKeyboardTypeDecimalPad;
    self.fisAmount.textAlignment = NSTextAlignmentRight;
    self.fisAmount.font = [UIFont fontWithName:FISFONT_REGULAR size:16];
    self.fisAmount.textColor = [UIColor grayColor];
    self.fisAmount.tag = 100001;
    [self addReturnKey:self.fisAmount];
    
    self.fisPoint = [[UITextField alloc] initWithFrame:rect];
    self.fisPoint.placeholder = @"0";
    self.fisPoint.keyboardType = UIKeyboardTypeNumberPad;
    self.fisPoint.textAlignment = NSTextAlignmentRight;
    self.fisPoint.font = [UIFont fontWithName:FISFONT_REGULAR size:16];
    self.fisPoint.textColor = [UIColor grayColor];
    [self addReturnKey:self.fisPoint];
    
    self.fisReceiptNumber1 = [[UITextField alloc] initWithFrame:rect];
    self.fisReceiptNumber1.placeholder = @"0000";
    self.fisReceiptNumber1.textAlignment = NSTextAlignmentRight;
    self.fisReceiptNumber1.font = [UIFont fontWithName:FISFONT_REGULAR size:16];
    self.fisReceiptNumber1.textColor = [UIColor grayColor];
    
    if ([self.receipt_number isEqualToString:@"receipt_number"]) {
        [self.fisReceiptNumber1 setEnabled:YES];
    } else {
        [self.fisReceiptNumber1 setEnabled:NO];
    }
    
    self.fisReceiptNumber2 = [[UITextField alloc] initWithFrame:rect];
    self.fisReceiptNumber2.placeholder = @"0000";
    self.fisReceiptNumber2.textAlignment = NSTextAlignmentRight;
    self.fisReceiptNumber2.font = [UIFont fontWithName:FISFONT_REGULAR size:16];
    self.fisReceiptNumber2.textColor = [UIColor grayColor];
    
    
    NSDictionary * business = [FISAppDirectory getBusinessForDetectedBeacon];
    
    NSString * name = [business objectForKey:@"title"];
    
    self.fisBtnGetPoints = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.fisBtnGetPoints.frame = CGRectMake(10, 9, 300, 30);
    self.fisBtnGetPoints.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //self.fisBtnGetPoints.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.fisBtnGetPoints.titleLabel.font = [UIFont fontWithName:FISFONT_REGULAR size:16];
    
    NSString * title = @"Get Points";
    if (name.length != 0) {
//        title = [NSString stringWithFormat:@"Get Points From %@", name];
    }
    
    [self.fisBtnGetPoints setTitle:title forState:UIControlStateNormal];
    [self.fisBtnGetPoints addTarget:self action:@selector(requestGetPoints) forControlEvents:UIControlEventTouchUpInside];
    self.fisBtnGetPoints.backgroundColor = [UIColor clearColor];
    
    self.qrCodeID = @"";
    [self.tableView reloadData];
    
    // init view
    self.lblTitle.text = title;
    self.lblTitle.font = [UIFont fontWithName:FISFONT_BOLD size:FISFONT_NAVIGATION_TITLESIZE];
    self.btnCancel.titleLabel.font = [UIFont fontWithName:FISFONT_REGULAR size:16];
    [self.btnCancel addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    self.btnGetPoints.titleLabel.font = [UIFont fontWithName:FISFONT_REGULAR size:16];
    [self.btnGetPoints addTarget:self action:@selector(requestGetPoints) forControlEvents:UIControlEventTouchUpInside];
}

-(void) goBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return 1;
    }
    /*if (self.rewardType == FISGetRewardViewControllerTypeQRCode) {
        return 4;
    } else if (self.rewardType == FISGetRewardViewControllerTypeManual) {
        return 5;
    }*/
    return 4;
}

-(void) viewWillAppear:(BOOL)animated {
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        UITableViewCell * buttonCell = [tableView dequeueReusableCellWithIdentifier:@"buttonCell"];
        
        if (buttonCell == nil) {
            buttonCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"buttonCell"];
            
            [buttonCell addSubview:self.fisBtnGetPoints];
        }
        return buttonCell;
    }
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"mainCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"mainCell"];
    }
    
    cell.textLabel.font = [UIFont fontWithName:FISFONT_REGULAR size:16];
    cell.detailTextLabel.font = [UIFont fontWithName:FISFONT_REGULAR size:16];
    cell.detailTextLabel.textColor = [UIColor grayColor];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Amount Spent";
            [cell addSubview:self.fisAmount];
            break;
        case 1:
            cell.textLabel.text = @"Receipt Number";
            if ([self.receipt_number isEqualToString:@"required"]) {
                cell.textLabel.textColor = [UIColor blackColor];
            } else {
                cell.textLabel.textColor = [UIColor grayColor];
            }
            [cell addSubview:self.fisReceiptNumber1];
            break;
        case 2:
            cell.textLabel.text = @"Points Earned";
            [cell addSubview:self.fisPoint];
        default:
            break;
    }
    
    self.fisAmount.delegate = self;
    self.fisReceiptNumber1.delegate = self;
    self.fisPoint.delegate = self;
    
    return cell;
}

-(void) scanQRCode {
    if ([QRCodeReader supportsMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]]) {
        static QRCodeReaderViewController *reader = nil;
        static dispatch_once_t onceToken;
        
        dispatch_once(&onceToken, ^{
            reader                        = [QRCodeReaderViewController new];
            reader.modalPresentationStyle = UIModalPresentationFormSheet;
        });
        reader.delegate = self;
        
        [reader setCompletionWithBlock:^(NSString *resultAsString) {
            NSLog(@"Completion with result: %@", resultAsString);
        }];
        
        [self presentViewController:reader animated:YES completion:NULL];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Reader not supported by the current device" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
    }
}

#pragma mark - QRCodeReader Delegate Methods
- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
{
    // parse result
    NSData * data = [result dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * qr_info = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    NSString * qr_id = [qr_info objectForKey:@"id"];
    
    if (qr_info == nil || qr_id == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:FISDefaultAlertTitle message:@"Please scan valid QR code." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    self.qrCodeID = [NSString stringWithFormat:@"%@",qr_id];
    self.fisQRCodeName.text = [qr_info objectForKey:@"title"];
    
    [reader dismissViewControllerAnimated:YES completion:nil];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


-(void) switchValueChanged:(UISwitch *) swRewardType {
    if (swRewardType.on) {
        self.rewardType = FISGetRewardViewControllerTypeQRCode;
    } else {
        self.rewardType = FISGetRewardViewControllerTypeManual;
    }
    [self.tableView reloadData];
}

#pragma UITextField Delegate
- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField.tag == 100001 && self.fisPoint.text.length == 0) {
        NSString * strAmount = [textField.text stringByReplacingCharactersInRange:range withString:string];
        {
            CGFloat fAmount = [strAmount floatValue];
            NSString * point = @"";
            
            NSArray * rules = [self.info objectForKey:@"manual_point"];
            for (NSDictionary * rule in rules) {
                NSString * strEnd = [rule objectForKey:@"end"];
                if (strEnd.length == 0 || [strEnd isEqualToString:@"infinite"]) {
                    point = [rule objectForKey:@"point"];
                    break;
                } else {
                    NSString * strStart = [rule objectForKey:@"start"];
                    CGFloat fEndValue = [strEnd floatValue];
                    CGFloat fStartValue = [strStart floatValue];
                    
                    if (fAmount <= fEndValue) {
                        point = [rule objectForKey:@"point"];
                        break;
                    }
                }
            }
            if (point.length == 0) {
                point = [[rules lastObject] objectForKey:@"point"];
            }
            
            self.fisPoint.placeholder = point;
        }
    }
    
    return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    return [textField resignFirstResponder];
}

- (void) resetView{
    [self.fisPoint resignFirstResponder];
    [self.fisAmount resignFirstResponder];
}

- (void) addReturnKey:(UITextField*) textField {
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 35.0f)];
    toolbar.barStyle=UIBarStyleBlackOpaque;
    
    // Create a flexible space to align buttons to the right
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    // Create a cancel button to dismiss the keyboard
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(resetView)];
    
    // Add buttons to the toolbar
    [toolbar setItems:[NSArray arrayWithObjects:flexibleSpace, barButtonItem, nil]];
    
    textField.inputAccessoryView = toolbar;
}

#pragma mark - alert view delegate
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 10001) {
        if (buttonIndex == 0) {
            NSString * ownerCode = [alertView textFieldAtIndex:0].text;
            if (ownerCode.length == 0) {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:FISDefaultAlertTitle message:@"Please insert owner code" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                
                [alert show];
            }
            [self requestGetPointsToWebServer:ownerCode];
        }
    } else if (alertView.tag == 10002) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma makr - lock and unlock viewrequestGetPointsToWebServer
- (void)lockView:(BOOL)showIndicator {
    [self.view bringSubviewToFront:self.lockBackgroundView];
    self.lockAnimationContainerView.hidden = !showIndicator;
}

- (void)unlockView {
    [self.view sendSubviewToBack:self.lockBackgroundView];
}

#pragma mark - request for getting points
-(void) requestGetPointsToWebServer:(NSString *) code {
    [self lockView:YES];
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    
    NSString * token = FISGetCurrentToken();
    NSDictionary * business = [FISAppDirectory getBusinessForDetectedBeacon];
    
    NSString * business_id = [business objectForKey:FIS_PARAM_BUSINESS_ID];
    if (token.length == 0) {
        FISNeedSignInAlert();
        return;
    }
    if (business_id.length == 0) {
        FISNoValidBeaconAlert();
        return;
    }
    [parameters setObject:token forKey:@"token"];
    [parameters setObject:business_id forKey:@"bus_id"];
    
    if (self.rewardType ==FISGetRewardViewControllerTypeManual) {
        [parameters setObject:self.fisReceiptNumber1.text forKey:@"receipt_number"];
    } else {
        [parameters setObject:self.fisReceiptNumber2.text forKey:@"receipt_number"];
    }
    
    [parameters setObject:self.fisAmount.text forKey:@"amount"];
    [parameters setObject:code forKey:@"owner_code"];
    if (self.rewardType ==FISGetRewardViewControllerTypeManual) {
        [parameters setObject:self.fisPoint.text forKey:@"point"];
    }
    
    NSString * chargeMode = @"";
    
    if (self.rewardType == FISGetRewardViewControllerTypeManual) {
        chargeMode = @"manual";
    } else {
        chargeMode = @"qrcode";
    }
    
    [parameters setObject:chargeMode forKey:@"charge_mode"];
    [FISWebService sendAsynchronousCommand:ACTION_GET_POINTS_FOR_BUSINESS parameters:parameters completionHandler:^(NSData *response, NSError *error) {
        NSLog(@"error:%@\n\nresponse:\n%@", error, response);
        if (error!=nil) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:FISDefaultAlertTitle message:@"Failed to get free points." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        } else {
            // point success
            NSDictionary * info = (NSDictionary *) response;
            
            NSString * business_name = [FISAppDirectory getBusinessNameForDetectedBeacon];
            NSString * points = [info objectForKey:@"charged_point"];
            NSString * message = [NSString stringWithFormat:@"You got %@ points from %@.",points,business_name];
            
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:FISDefaultAlertTitle message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            alert.tag = 10002;
            [alert show];
            
            // need to refresh
            [[NSNotificationCenter defaultCenter] postNotificationName:FISNOTIFICATION_REFRESH_DEALSVC object:nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:FISNOTIFICATION_REFRESH_DEALINFO object:nil];
//            [FISAppDirectory setNeedToRefresh:YES key:@"dealsVC"];
//            [FISAppDirectory setNeedToRefresh:YES key:@"dealInfoVC"];
            [self.delegate changeUserPoint:[points integerValue]];
        }
        [self unlockView];
    }];
}


-(void) requestGetPoints {
    
    [self.fisAmount resignFirstResponder];
    [self.fisPoint resignFirstResponder];
    [self.fisProductName resignFirstResponder];
    [self.fisReceiptNumber1 resignFirstResponder];
    [self.fisReceiptNumber2 resignFirstResponder];
    [self.fisQRCodeName resignFirstResponder];
    
    if (self.rewardType == FISGetRewardViewControllerTypeManual) {
        if ([self.fisAmount.text isEqualToString:@""]) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:FISDefaultAlertTitle message:@"Please insert the Amount Field" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:FISDefaultAlertTitle message:@"Owner Code" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel", nil];
        alertView.alertViewStyle = UIAlertViewStyleSecureTextInput;
        alertView.tag = 10001;
        [alertView show];
    } else {
        // get points from QR Code
        if (self.qrCodeID.length != 0) {
            [self requestGetPointsToWebServer:self.qrCodeID];
        }
        else {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:FISDefaultAlertTitle message:@"Please scan a QR code for getting points" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}


@end
