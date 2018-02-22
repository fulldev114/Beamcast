//
//  FISCategoriesViewController.m
//  FindItSimple
//
//  Created by Jain R on 3/14/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import "FISCategoriesViewController.h"
#import "FISCategoriesTableViewCell.h"
#import "FISCitiesViewController.h"
#import "FISBaseListViewController.h"
#import "FISNearbyViewController.h"
#import "FISDealsViewController.h"

@interface FISCategoriesViewController ()

@end

@implementation FISCategoriesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Cities" style:UIBarButtonItemStylePlain target:self action:@selector(showCitiesViewController)] autorelease];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:FISFONT_REGULAR size:16]} forState:UIControlStateNormal];
    
    if (self.categories.count==0) {
        [self initializeGlobalCategories];
    }

    self.treeView.delegate = self;
    self.treeView.dataSource = self;
//    self.treeView.separatorStyle = RATreeViewCellSeparatorStyleSingleLine;
    
    [self.treeView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[FISAppLocker sharedLocker] lockAppWith:YES];
    
    NSString* token = FISGetCurrentToken();
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    if (token.length!=0) {
        [parameters setObject:token forKey:@"token"];
    }
    [parameters setObject:[FISAppDirectory getCities] forKey:@"cities"];

    // get categories
    [FISWebService sendAsynchronousCommand:ACTION_GET_CATEGORY_ALL parameters:parameters completionHandler:^(NSData *response, NSError *error) {
        NSLog(@"categories error:%@\n\nresponse:\n%@", error, response);
        if (error!=nil) {
            UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] autorelease];
            [alert show];
        }
        else {
            NSArray* data = [NSMutableArray arrayWithArray:(NSArray*)response];
            NSLog(@"%@",data);
            if (data.count == self.categories.count) {

                for (int i = 0; i < data.count; i++) {
                    NSArray* count = [data objectAtIndex:i];
                    RADataObject* raCategory = [self.categories objectAtIndex:i];
                    NSArray* child = @[
                                       @{@"title":@"Deals", @"value":[[count objectAtIndex:0] stringValue], @"index":[NSNumber numberWithInt:i+0]},
                                       @{@"title":@"FYI", @"value":[[count objectAtIndex:1] stringValue], @"index":[NSNumber numberWithInt:i+1000]},
                                       @{@"title":@"Events", @"value":[[count objectAtIndex:2] stringValue], @"index":[NSNumber numberWithInt:i+2000]},
                                       @{@"title":@"Coupons", @"value":[[count objectAtIndex:3] stringValue], @"index":[NSNumber numberWithInt:i+3000]},
                                       @{@"title":@"Rewards", @"value":[[count objectAtIndex:4] stringValue], @"index":[NSNumber numberWithInt:i+5000]},
                                       @{@"title":@"Businesses", @"value":[[count objectAtIndex:5] stringValue], @"index":[NSNumber numberWithInt:i+4000]}
                                       ];
                    raCategory.children = child;
                }
                
                [self.treeView reloadData];
            }
        }

        [[FISAppLocker sharedLocker] unlockApp];

    }];
}

- (void)showCitiesViewController {
    UIViewController* citiesViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FISCitiesViewController"];
    [self.navigationController pushViewController:citiesViewController animated:YES];
}

- (void)initializeGlobalCategories {
    // The first text of each array is Main Category.
    NSArray* categoryData =
    @[
      @"Food & Beverage",
      @"Home & Maintenance",
      @"Health & Fitness",
      @"Beauty & Spas",
      @"Shopping",
      @"Entertainment",
      @"Automotive",
      @"Pets",
      @"Education",
      @"Business & Professional",
      @"Hotels & Travel",
      @"Computers & Electronics"
      ];
    
    self.categories = [NSMutableArray array];
    self.categoryIds = [NSMutableDictionary dictionary];

    NSArray* child = @[
                       @{@"title":@"Deals", @"value":@"0", @"index":[NSNumber numberWithInt:0]},
                       @{@"title":@"FYI", @"value":@"0", @"index":[NSNumber numberWithInt:1000]},
                       @{@"title":@"Events", @"value":@"0", @"index":[NSNumber numberWithInt:2000]},
                       @{@"title":@"Coupons", @"value":@"0", @"index":[NSNumber numberWithInt:3000]},
                       @{@"title":@"Rewards", @"value":@"0", @"index":[NSNumber numberWithInt:3000]},
                       @{@"title":@"Businesses", @"value":@"0", @"index":[NSNumber numberWithInt:4000]}
                       ];
    
    // All category
    RADataObject* raAllCategory = [RADataObject dataObjectWithName:FISAllCategoryTitle children:[child mutableCopy]];
    raAllCategory.isExpanded = YES;
    [self.categories addObject:raAllCategory];
    
    int index = 0;
    for (NSString* category in categoryData) {
        RADataObject* raCategory = [RADataObject dataObjectWithName:category children:[child mutableCopy]];
        [self.categories addObject:raCategory];
        [self.categoryIds setObject:[NSNumber numberWithInt:index] forKey:category];
        index++;
    }
    
   NSLog(@"number of categories = %d", index);

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.categories = nil;
    self.categoryIds = nil;
    [_treeView release];
    [super dealloc];
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

#pragma mark TreeView Delegate methods

//- (NSInteger)treeView:(RATreeView *)treeView indentationLevelForRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
//{
//    return treeNodeInfo.treeDepthLevel;
//}

- (BOOL)treeView:(RATreeView *)treeView canEditRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo {
    return NO;
}

- (void)treeView:(RATreeView *)treeView willExpandRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo {
    if ([item isKindOfClass:[RADataObject class]]) {
        RADataObject *data = item;
        data.isExpanded = YES;
    }
}

- (void)treeView:(RATreeView *)treeView willCollapseRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo {
    if ([item isKindOfClass:[RADataObject class]]) {
        RADataObject *data = item;
        data.isExpanded = NO;
    }
}

- (void)treeView:(RATreeView *)treeView willDisplayCell:(UITableViewCell *)cell forItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
//    if (treeNodeInfo.treeDepthLevel == 0) {
//        cell.backgroundColor = UIColorFromRGB(0xF7F7F7);
//    } else if (treeNodeInfo.treeDepthLevel == 1) {
//        cell.backgroundColor = UIColorFromRGB(0xD1EEFC);
//    } else if (treeNodeInfo.treeDepthLevel == 2) {
//        cell.backgroundColor = UIColorFromRGB(0xE0F8D8);
//    }
}

- (BOOL)treeView:(RATreeView *)treeView shouldItemBeExpandedAfterDataReload:(id)item treeDepthLevel:(NSInteger)treeDepthLevel {
    if (item == nil) {
        return NO;
    }
    
    if ([item isKindOfClass:[RADataObject class]]) {
        RADataObject *data = item;
        return data.isExpanded;
    }
    
    return NO;
    
}

#pragma mark TreeView Data Source

- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    UITableViewCell *cell = nil;
    
    NSString* title;

    if ([item isKindOfClass:[RADataObject class]]) {
        cell = [[[FISCategoriesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"maincell"] autorelease];
        RADataObject *data = item;
        title = data.name;

        cell.textLabel.font = [UIFont fontWithName:FISFONT_REGULAR size:16];
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);

        UISwitch* fisSwitch = [[[UISwitch alloc] init] autorelease];
        NSInteger index = 0;
        
        if ([title isEqualToString:FISAllCategoryTitle]) {
            for (int i = 1; i<self.categories.count; i++) {
                RADataObject* raCategory = [self.categories objectAtIndex:i];
                index = [[self.categoryIds objectForKey:raCategory.name] integerValue];
                if ([FISAppDirectory isFavorite:index]) {
                    fisSwitch.on = YES;
                    break;
                }
            }
            index = 1000;
            cell.imageView.image = nil;
        }
        else {
            index = [[self.categoryIds objectForKey:title] integerValue];
            if ([FISAppDirectory isFavorite:index])
                fisSwitch.on = YES;
            cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_category_%ld", (long)(index + 1)]];
        }
        
        
        [fisSwitch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
        fisSwitch.tag = index;
        fisSwitch.onTintColor = FISDefaultBackgroundColor();
        cell.accessoryView = fisSwitch;

        cell.textLabel.text = title;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        title = [item objectForKey:@"title"];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:FISFONT_REGULAR size:14];
        cell.imageView.image = [UIImage imageNamed:@"icon_favorite"];

        cell.textLabel.text = title;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@   >", [item objectForKey:@"value"]]; // padding
        
        cell.detailTextLabel.font = [UIFont fontWithName:FISFONT_REGULAR size:16];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIButton* fisButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        NSInteger index = [[item objectForKey:@"index"] integerValue];

        switch (treeNodeInfo.positionInSiblings) {
            case 1:
                [fisButton setImage:[UIImage imageNamed:@"profile_icon_articles"] forState:UIControlStateNormal];
                break;
            case 2:
                [fisButton setImage:[UIImage imageNamed:@"profile_icon_events"] forState:UIControlStateNormal];
                break;
            case 3:
                [fisButton setImage:[UIImage imageNamed:@"profile_icon_deals"] forState:UIControlStateNormal];
                break;
            case 4:
                [fisButton setImage:[UIImage imageNamed:@"profile_icon_reward"] forState:UIControlStateNormal];
                break;
            case 5:
                [fisButton setImage:[UIImage imageNamed:@"profile_icon_pin"] forState:UIControlStateNormal];
                break;
                
            default:
                [fisButton setImage:[UIImage imageNamed:@"profile_icon_deals"] forState:UIControlStateNormal];
                break;
        }

        fisButton.tag = index;
        [fisButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        fisButton.frame = CGRectMake(0, 0, 29, 29);
        
        
        cell.accessoryView = fisButton;
    }
    
    return cell;
}

- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(id)item
{
    if (item == nil) {
        return [self.categories count];
    }
    
    if ([item isKindOfClass:[RADataObject class]]) {
        RADataObject *data = item;
        return data.children.count;
    }
    
    return 0;
}

- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item
{
    if (item == nil) {
        return [self.categories objectAtIndex:index];
    }
    
    if ([item isKindOfClass:[RADataObject class]]) {
        RADataObject *data = item;
        return [data.children objectAtIndex:index];
    }
    
    return nil;
}

- (void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo {

    if ([item isKindOfClass:[RADataObject class]]) {
        return;
    }
    
    UIButton* fisButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    NSInteger index = [[item objectForKey:@"index"] integerValue];
    fisButton.tag = index;
    [self buttonTapped:fisButton];
    
}

#pragma mark - UIAction
- (IBAction)switchValueChanged:(UISwitch*)sender {
    NSLog(@"index path:%ld", (long)sender.tag);
    if (sender.tag >= 1000) {
        NSInteger index = sender.tag - 1000;
        for (int i = 1; i<self.categories.count; i++) {
            RADataObject* raCategory = [self.categories objectAtIndex:i];
            index = [[self.categoryIds objectForKey:raCategory.name] integerValue];
            if (sender.on)
                [FISAppDirectory addFavorite:index];
            else
                [FISAppDirectory removeFavorite:index];
        }
    }
    else {
        if (sender.on)
            [FISAppDirectory addFavorite:sender.tag];
        else
            [FISAppDirectory removeFavorite:sender.tag];
    }

    [FISAppDirectory setNeedToRefresh:YES key:@"dealsVC"];
    [FISAppDirectory setNeedToRefresh:YES key:@"articlesVC"];
    [FISAppDirectory setNeedToRefresh:YES key:@"eventsVC"];
    [FISAppDirectory setNeedToRefresh:YES key:@"nearbyVC"];
    
    [self.treeView.tableView reloadData];
}

- (IBAction)buttonTapped:(UIButton*)sender {
    NSInteger index = sender.tag;
    NSInteger type = 0;
    NSInteger catId = 0;

    if (index >= 5000) { // go business
        catId = index - 5000;
        type = 5;
    }
    else if (index >= 4000) { // go business
        catId = index - 4000;
        type = 4;
    }
    else if (index >= 3000) { // go coupon
        catId = index - 3000;
        type = 3;
    }
    else if (index >= 2000) { // go event
        catId = index - 2000;
        type = 2;
    }
    else if (index >= 1000) { // go article
        catId = index - 1000;
        type = 1;
    }
    else { // go deal
        catId = index;
        type = 0;
    }
    
    NSMutableArray* catArr = [NSMutableArray array];
    if (catId == 0) {
        for (int i = 0; i < FISNumberOfCategories; i++) {
            [catArr addObject:[NSNumber numberWithInt:i + FISCategoryBaseIndex_V3_0 + 1]];
        }
    }
    else
        [catArr addObject:[NSNumber numberWithInteger:catId + FISCategoryBaseIndex_V3_0]];
    
    if (type < 4) {
        FISBaseListViewController* viewController = nil;
        
        switch (type) {
            case 0:
                viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FISDealsViewController-568h"];
                viewController.navigationItem.title = @"DEALS";
                break;
            case 1:
                viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FISArticlesViewController-568h"];
                viewController.navigationItem.title = @"FYI";
                break;
            case 2:
                viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FISEventsViewController-568h"];
                viewController.navigationItem.title = @"HAPPENINGS";
                break;
            case 3:
                viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FISDealsViewController-568h"];
                [(FISDealsViewController*)viewController setDealListType:FISDealsViewControllerTypeCoupon];
                viewController.navigationItem.title = @"COUPONS";
                break;
            default:
                break;
        }
        
        viewController.specialCategories = catArr;
        viewController.listType = FISListTypeSpecialCategory;
        
        [self.navigationController pushViewController:viewController animated:YES];
    } else if (type == 5) { // rewards
        FISDealsViewController* viewController = nil;
        
        viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FISDealsViewController-568h"];
        [viewController setDealListType:FISDealsViewControllerTypeReward];
        viewController.navigationItem.title = @"REWARDS";
        
        viewController.specialCategories = catArr;
        viewController.listType = FISListTypeSpecialCategory;
        
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else {
        FISNearbyViewController* viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FISNearbyViewController-568h"];
        viewController.navigationItem.title = @"NEARBY";
        viewController.specialCategories = catArr;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    
}

@end
