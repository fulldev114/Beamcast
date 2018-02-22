//
//  FISBaseListViewController.h
//  FindItSimple
//
//  Created by Jain R on 3/29/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FISBaseViewController.h"
#import "FISWebService.h"
#import "MJRefresh.h"


@interface FISBaseListViewController : FISBaseViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, retain) MJRefreshHeaderView* header;
@property (nonatomic, retain) MJRefreshFooterView* footer;

@property (nonatomic, retain) NSMutableArray* fisData;
@property (nonatomic, retain) NSMutableArray* originalData;
@property (nonatomic, assign) NSUInteger pageIndex;
@property (nonatomic, assign) BOOL isSearching;
@property (nonatomic, copy) NSString* searchText;
@property (nonatomic, retain) UIBarButtonItem* rightBarButtonItem;

@property (nonatomic, retain) IBOutlet UITableView* tableView;
@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;

@property (nonatomic, assign) FISListType listType;

@property (nonatomic, retain) NSArray* specialCategories;

- (void)reload:(id)sender;

@end
