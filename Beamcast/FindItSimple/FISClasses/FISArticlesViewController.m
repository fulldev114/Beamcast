//
//  FISArticlesViewController.m
//  FindItSimple
//
//  Created by Jain R on 3/24/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import "FISArticlesViewController.h"
#import "FISArticlesTableViewCell.h"
#import "FISArticleInfoViewController.h"

@interface FISArticlesViewController ()

@end

@implementation FISArticlesViewController

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
    
    self.header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        
#ifdef TEST_CODE
        [self performSelector:@selector(reload:) withObject:refreshView afterDelay:2.0];
#else
        [self reload:refreshView];
#endif
        
        NSLog(@"%@----Begin Refreshing开始进入刷新状态", refreshView.class);
    };
    [self.header beginRefreshing];

    [FISAppDirectory setNeedToRefresh:NO key:@"articlesVC"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([FISAppDirectory isNeedToRefreshWith:@"articlesVC"] && self.listType!=FISListTypeSaved) {
        [self reload:nil];
    }
}

- (void)reload:(id)sender {
    
    [[FISAppLocker sharedLocker] lockAppWith:sender==nil];

    [FISAppDirectory setNeedToRefresh:NO key:@"articlesVC"];
    
    NSString* token = FISGetCurrentToken();
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    if (self.listType==FISListTypeDefault || self.listType==FISListTypeSearched || self.listType==FISListTypeSpecialCategory) {
        
        [parameters setObject:@"no" forKey:@"saved"];
        
        if (token.length!=0) {
            [parameters setObject:token forKey:@"token"];
        }
        
        if (self.listType==FISListTypeSpecialCategory)
            [parameters setObject:self.specialCategories forKey:@"categories"];
        else
            [parameters setObject:[FISAppDirectory getFavorites] forKey:@"categories"];
        
        [parameters setObject:[FISAppDirectory getCities] forKey:@"cities"];
        
        if (self.listType==FISListTypeSearched) {
            [parameters setObject:self.searchText forKey:@"search"];
        }
    }
    else if ( self.listType == FISListTypeSubgroup)
    {
        [parameters setObject:@"no" forKey:@"saved"];
        if (token.length!=0) {
            [parameters setObject:token forKey:@"token"];
        }
        if (_businessID != nil) {
            [parameters setObject:_businessID forKey:@"bus_id"];
        }
    }
    else {
        [parameters setObject:@"yes" forKey:@"saved"];
        if (token.length==0) {
#ifdef TEST_CODE
#warning you must log in
#endif
        }
        [parameters setObject:token forKey:@"token"];
    }
    
    // get deals
    [FISWebService sendAsynchronousCommand:ACTION_GET_ARTICLE_ALL parameters:parameters completionHandler:^(NSData *response, NSError *error) {
        NSLog(@"error:%@\n\nresponse:\n%@", error, response);
        if (error!=nil) {
            UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] autorelease];
            [alert show];
        }
        else {
            self.fisData = [NSMutableArray arrayWithArray:(NSArray*)response];
            self.originalData = self.fisData;
            [self.tableView reloadData];
        }
        [self.header endRefreshing];
        [[FISAppLocker sharedLocker] unlockApp];
    }];
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

#pragma mark - FISDealInfoViewControllerDelegate
- (void)saveDeal:(FISDealInfoViewController *)vc indexPath:(NSIndexPath *)indexPath saved:(BOOL)saved {
    NSMutableDictionary* deal = [NSMutableDictionary dictionaryWithDictionary:[self.fisData objectAtIndex:indexPath.section]];
    if (self.listType==FISListTypeSaved) {
        if (saved==NO) {
            [self.fisData removeObjectAtIndex:indexPath.section];
            if (self.fisData!=self.originalData) {
                NSString* dealId = [deal objectForKey:@"id"];
                for (NSDictionary* origdeal in self.originalData) {
                    NSString* origId = [origdeal objectForKey:@"id"];
                    if ([origId isEqualToString:dealId]) {
                        [self.originalData removeObject:origdeal];
                        break;
                    }
                }
            }
            if (vc)
                [vc goBack];
        }
        [FISAppDirectory setNeedToRefresh:YES key:@"articlesVC"];
    }
    else {
        [deal setObject:[vc.info objectForKey:@"own_save"] forKey:@"own_save"];
        [deal setObject:[vc.info objectForKey:@"saved_count"] forKey:@"saved_count"];
        [self.fisData replaceObjectAtIndex:indexPath.section withObject:deal];
    }
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* cellIdentifier = [NSString stringWithFormat:@"cell%ld", (long)indexPath.section];
    
    FISArticlesTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell==nil) {
        cell = [[FISArticlesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSDictionary* article = [self.fisData objectAtIndex:indexPath.section];
    
    cell.fisTitleLabel.text = [article objectForKey:@"simple_title"];
    cell.fisDateLabel.text = FISAppendStringWithDate([article objectForKey:@"last_modified"]);
    cell.fisSavedCountLabel.text = [article objectForKey:@"saved_count"];
    if (self.listType==FISListTypeDefault) {
        NSString* marktid = [article objectForKey:@"own_save"];
        NSString* dealid = [article objectForKey:@"id"];
        if ([dealid isEqualToString:marktid]) {
            cell.handPicked = YES;
        }
        else {
            cell.handPicked = NO;
        }
    }
    else if (self.listType==FISListTypeSaved) {
        BOOL delflag = [[article objectForKey:@"delflag"] boolValue];
        if (delflag) {
            cell.fisHandPickedImageView.image = [UIImage imageNamed:@"ribbon_deleted"];
            cell.handPicked = YES;
        }
        else
            cell.handPicked = NO;
    }
    else
        cell.handPicked = NO;
    
    NSString* pictureURL = [article objectForKey:@"picture"];
    
    if ([pictureURL isKindOfClass:[NSString class]]) {
        cell.imageURL = pictureURL;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[FISAppLocker sharedLocker] lockApp];

    NSDictionary* article = [self.fisData objectAtIndex:indexPath.section];
    if (self.listType==FISListTypeSaved) {
        BOOL delflag = [[article objectForKey:@"delflag"] boolValue];
        if (delflag) {
            UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:FISDefaultAlertTitle message:@"This article was deleted by business owner.\nDo you want to delete it from your saved list?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil] autorelease];
            alert.tag = indexPath.section;
            [[FISAppLocker sharedLocker] unlockApp];
            [alert show];
            return;
        }
    }
    NSString* dealId = [article objectForKey:@"id"];

    NSString* token = FISGetCurrentToken();
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    if (token.length!=0) {
        [parameters setObject:token forKey:@"token"];
    }
    [parameters setObject:dealId forKey:@"id"];
    
    // get deal
    [FISWebService sendAsynchronousCommand:ACTION_GET_ARTICLE parameters:parameters completionHandler:^(NSData *response, NSError *error) {
        NSLog(@"error:%@\n\nresponse:\n%@", error, response);
        if (error!=nil) {
            NSRange range = [error.localizedDescription rangeOfString:MSG_ERR_VALUE];
            if (range.location != NSNotFound) {
                UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:@"This article might be deleted by business owner.\nPlease reload again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] autorelease];
                [alert show];
            }
            else {
                UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] autorelease];
                [alert show];
            }
        }
        else {
            FISDealInfoViewController* detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FISDealInfoViewController-568h"];
            detailViewController.info = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary*)response];
            detailViewController.type = FISInfoViewControllerTypeArticle;
            detailViewController.delegate = self;
            detailViewController.indexPath = indexPath;
            [self.navigationController pushViewController:detailViewController animated:YES];
        }
        [[FISAppLocker sharedLocker] unlockApp];
    }];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex==1) {
        NSString* token = FISGetCurrentToken();
        if (token.length==0) {
            UIAlertView* alret = [[[UIAlertView alloc] initWithTitle:FISDefaultAlertTitle message:@"Please Sign in on Profile Page" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] autorelease];
            [alret show];
            return;
        }
        
        [[FISAppLocker sharedLocker] lockApp];
        
        NSString* marktype = nil;
        marktype = TYPE_ARTICLE;
        NSDictionary* deal = [self.fisData objectAtIndex:alertView.tag];
        NSString* markid = [deal objectForKey:@"id"];
        
        // remove saving
        [FISWebService sendAsynchronousCommand:ACTION_REMOVE_SAVING parameters:@{@"token": token, @"marktype": marktype, @"markid": markid} completionHandler:^(NSData *response, NSError *error) {
            NSLog(@"error:%@\n\nresponse:\n%@", error, response);
            if (error!=nil) {
                UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] autorelease];
                [alert show];
            }
            else {
                NSMutableDictionary* globalInfo = [NSMutableDictionary dictionaryWithDictionary:[FISAppDirectory getUserInfo]];
                int savedCount = 0;
                savedCount = [[globalInfo objectForKey:@"g_article_cnt"] intValue];
                savedCount--;
                [globalInfo setObject:[NSString stringWithFormat:@"%d", savedCount] forKey:@"g_article_cnt"];
                [FISAppDirectory setUserInfo:globalInfo];
                
                [self saveDeal:nil indexPath:[NSIndexPath indexPathForRow:0 inSection:alertView.tag] saved:NO];
            }
            [[FISAppLocker sharedLocker] unlockApp];
        }];
    }
}

@end
