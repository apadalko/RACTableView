//
//  RACTableViewController.h
//  Home Automation Wizzard
//
//  Created by Alex Padalko on 12/25/14.
//  Copyright (c) 2014 Alex Padalko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RACTableViewControllerProtocol.h"
static NSString * cellIndifiter=@"RACTVCCellIndifiter";
static NSString * loadIndifiter=@"RACTVCLoadCellIndifiter";
@interface RACTableViewController : UITableView<UITableViewDataSource,UITableViewDelegate>
@property (assign,nonatomic)id<RACTableViewControllerProtocol> viewModel;

@property (retain,nonatomic)Class cellClass;

@property (retain,nonatomic)NSString * objectKeyPath;

@property (nonatomic)CGFloat cellHeight;


@property (retain,nonatomic)UIView * emptyView;

@property (retain,nonatomic)UIView * loadView;


@property (nonatomic)BOOL paginationEnabled;
@property (nonatomic)CGFloat loaderCellHeight;
@property (retain,nonatomic)Class loaderCellClass;

-(UITableViewCell*)defaultCellWithItem:(id)item;
-(UITableViewCell*)loadCell;

@end
