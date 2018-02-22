//
//  FISCategoriesViewController.h
//  FindItSimple
//
//  Created by Jain R on 3/14/14.
//  Copyright (c) 2014 Alex Hong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FISBaseViewController.h"
#import "RATreeView.h"
#import "RADataObject.h"

@interface FISCategoriesViewController : FISBaseViewController <RATreeViewDelegate, RATreeViewDataSource>

@property (nonatomic, retain) NSMutableArray* categories;
@property (nonatomic, retain) NSMutableDictionary* categoryIds;
@property (retain, nonatomic) IBOutlet RATreeView *treeView;

- (void)initializeGlobalCategories;

@end
