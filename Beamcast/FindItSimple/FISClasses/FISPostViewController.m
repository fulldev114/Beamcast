//
//  FISPostViewController.m
//  FindItSimple
//
//  Created by Jain R on 4/12/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import "FISPostViewController.h"

@interface FISPostViewController ()

@end

@implementation FISPostViewController

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
    self.photoView.image = self.photo;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)dealloc {
    self.photo = nil;
    [_photoView release];
    [super dealloc];
}
- (IBAction)retake:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)use:(id)sender {
    
    UIImage* resizedImage = [UIImage imageWithImage:self.photo scaledToSize:CGSizeMake(200, 200)];
    
    NSString *photoData = [DARBase64 base64forData:UIImageJPEGRepresentation(resizedImage, 1.0f)];
    
    [[FISAppLocker sharedLocker] lockApp];
    // change photo
    [FISWebService sendAsynchronousCommand:ACTION_USER_MOD parameters:@{@"token": FISGetCurrentToken(), @"photo": photoData} completionHandler:^(NSData *response, NSError *error) {
        NSLog(@"error:%@\n\nresponse:\n%@", error, response);
        if (error!=nil) {
            UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] autorelease];
            [alert show];
        }
        else {
            if ([self.delegate respondsToSelector:@selector(usePhoto:photo:)]) {
                [self.delegate usePhoto:self.navigationController photo:resizedImage];
            }
        }
        [[FISAppLocker sharedLocker] unlockApp];
    }];
}
@end
