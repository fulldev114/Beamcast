//
//  FISBaseListViewController.m
//  FindItSimple
//
//  Created by Jain R on 3/29/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import "FISBaseListViewController.h"
#import "FISBusinessDetailViewController.h"

@interface FISBaseListViewController ()

@end

@implementation FISBaseListViewController

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

    if (self.listType==FISListTypeSaved || self.listType == FISListTypeSubgroup || self.listType == FISListTypeSpecialCategory) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    }
    
    if (self.listType==FISListTypeSearched) {
        self.searchBar.userInteractionEnabled = NO;
        self.searchBar.hidden = YES;
        CGRect frame = self.tableView.frame;
        frame.origin.y -= self.searchBar.frame.size.height;
        frame.size.height += self.searchBar.frame.size.height;
        self.tableView.frame = frame; 
    }

    self.pageIndex = 0;

    // 3.集成刷新控件
    // 3.1.下拉刷新
    [self addHeader];
    
    // 3.2.上拉加载更多
    [self addFooter];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont fontWithName:FISFONT_BOLD size:FISFONT_NAVIGATION_TITLESIZE]}];
}

- (void)reload:(id)sender {
    NSLog(@"Called Super reload method");
}

- (void)addFooter
{
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.tableView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是footer
        self.pageIndex++;
        [self performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:2.0];
        
//        NSLog(@"%@----Begin Refreshing开始进入刷新状态", refreshView.class);
    };
    self.footer = footer;
}

- (void)addHeader
{
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.tableView;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 进入刷新状态就会回调这个Block
        
        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是header
        [self performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:2.0];
        
//        NSLog(@"%@----Begin Refreshing开始进入刷新状态", refreshView.class);
    };
    header.endStateChangeBlock = ^(MJRefreshBaseView *refreshView) {
        // 刷新完毕就会回调这个Block
//        NSLog(@"%@----End Refreshing刷新完毕", refreshView.class);
        self.pageIndex = 0;
    };
    header.refreshStateChangeBlock = ^(MJRefreshBaseView *refreshView, MJRefreshState state) {
        // 控件的刷新状态切换了就会调用这个block
        switch (state) {
            case MJRefreshStateNormal:
//                NSLog(@"%@----Change State：Normal普通状态", refreshView.class);
                break;
                
            case MJRefreshStatePulling:
//                NSLog(@"%@----Change State：Can Refresh if release松开即可刷新的状态", refreshView.class);
                break;
                
            case MJRefreshStateRefreshing:
//                NSLog(@"%@----Change State：Now Refreshing正在刷新状态", refreshView.class);
                break;
            default:
                break;
        }
    };
//    [header beginRefreshing];
    self.header = header;
}

- (void)doneWithView:(MJRefreshBaseView *)refreshView
{
    // 刷新表格
    [self.tableView reloadData];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancelSearch {
    [self.searchBar setText:self.searchText];
    [self.searchBar resignFirstResponder];
}

- (void)beginSearch {
    self.isSearching = YES;
    self.searchText = self.searchBar.text;

    NSMutableArray* newData = [NSMutableArray array];
    
    for (NSDictionary* data in self.originalData) {
        NSString* simpletitle = [data objectForKey:@"simple_title"];
        NSRange range = [simpletitle rangeOfString:self.searchText options:NSCaseInsensitiveSearch];
        if (range.location != NSNotFound) {
            [newData addObject:data];
            continue;
        }
    }
    
    if ([self numberOfSectionsInTableView:self.tableView]) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }

    self.fisData = newData;
    self.pageIndex = 1;
    
    [self.tableView reloadData];
}

- (void)endSearch {
    self.isSearching = NO;
    self.searchText = nil;
    [self.searchBar setText:self.searchText];

    if ([self numberOfSectionsInTableView:self.tableView]) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }

    self.fisData = self.originalData;
    self.pageIndex = 1;
    
    [self.tableView reloadData];

    [self.navigationItem setRightBarButtonItem:self.rightBarButtonItem animated:YES];
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

- (void)goBack {
    NSInteger index = [self.navigationController.viewControllers indexOfObject:self];
    if (index>0) {
        if ([self.navigationController.viewControllers[index - 1] isKindOfClass:[FISBusinessDetailViewController class]]) {
            [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont fontWithName:FISFONT_REGULAR size:15]}];
            
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger numberOfSections = (self.pageIndex+1) * NUMBEROFROWSINAPAGE;
    NSInteger numberOfData = self.fisData.count;
    return ((numberOfData<numberOfSections)?numberOfData:numberOfSections);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section==self.fisData.count-1) {
        return 14.0f;
    }
    return 7.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section==0) {
        return 14.0f;
    }
    return 7.0f;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark - UISearchBar Delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self beginSearch];
    [searchBar resignFirstResponder];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    UIBarButtonItem* cancelButton = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_toolbar_cancel"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelSearch)] autorelease];
    [self.navigationItem setRightBarButtonItem:cancelButton animated:YES];
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    if (self.isSearching) {
        UIBarButtonItem* cancelButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelSearch)] autorelease];
        cancelButton = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_toolbar_showall"] style:UIBarButtonItemStylePlain target:self action:@selector(endSearch)] autorelease];
        [self.navigationItem setRightBarButtonItem:cancelButton animated:YES];
    }
    else
        [self.navigationItem setRightBarButtonItem:self.rightBarButtonItem animated:YES];
    return YES;
}

- (void)dealloc {
    self.tableView = nil;
    self.header = nil;
    self.footer = nil;
    self.fisData = nil;
    self.originalData = nil;
    self.searchText = nil;
    self.rightBarButtonItem = nil;
    self.specialCategories = nil;
    [_searchBar release];
    [super dealloc];
}

@end
