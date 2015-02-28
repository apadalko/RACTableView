 //
//  RACTableViewController.m
//  Home Automation Wizzard
//
//  Created by Alex Padalko on 12/25/14.
//  Copyright (c) 2014 Alex Padalko. All rights reserved.
//

#import "RACTableViewController.h"

@implementation RACTableViewController

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        
        self.cellHeight=44;
        self.loaderCellHeight=44;
        [self setDelegate:self];
        
        [self setDataSource:self];

        _paginationEnabled=YES;
        
    }
    
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    
    if (self=[super initWithFrame:frame style:style]) {
        
        self.cellHeight=44;
        self.loaderCellHeight=44;
        [self setDelegate:self];
        
        [self setDataSource:self];
        
        _paginationEnabled=YES;
    }
    return self;
}
//-(void)viewDidLoad{
//    [super viewDidLoad];
//    

//
//    
//}
-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    
    [_emptyView setFrame:self.bounds];
    [self.loadView setFrame:self.bounds];
}
-(void)setViewModel:(id<RACTableViewControllerProtocol>)viewModel{
    
    _viewModel=viewModel;
    
    
   
 
 
    
//    
    self.loadView =[[UIView alloc] init];
    
    [self.loadView setBackgroundColor:[UIColor greenColor]];
    
 //   [self addSubview:self.loadView];
    
    [self.loadView setHidden:YES];
    
    
    __weak RACTableViewController * selfRef=self;
    [RACObserve(_viewModel, items) subscribeNext:^(id x) {
        
        [selfRef reloadData];
    } ];
    
    
    _viewModel.updateItemsCommand=[[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        [selfRef reloadData];
        NSInteger intgr= 0;
        
        int rowNumbers = 0;
        [selfRef scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumbers inSection:intgr] atScrollPosition:UITableViewScrollPositionNone animated:YES];
      
      
        
        return [RACSignal return:nil];
    }];
    RAC(self.loadView, hidden)=[[self.viewModel.loadItemsCommand.executing not] filter:^BOOL(id value) {
        
        
        if (![value boolValue]) {
            
     
            
            NSUInteger itemsCount=self.viewModel.items.count ;
        if (itemsCount==0) {
            return YES;
        }
        return NO;
            
        }else{
            
            return YES;
        }
        
    }];
  
    
    [self.viewModel.loadItemsCommand execute:[NSIndexPath indexPathForRow:0 inSection:5]];
    
    
//    RAC([UIApplication sharedApplication], networkActivityIndicatorVisible) = [self.viewModel.loadItemsCommand.executing takeUntilBlock:^BOOL(id x) {
//        return YES;
//    }];
    
    
   //  RAC([UIApplication sharedApplication], networkActivityIndicatorVisible) = self.viewModel.loadItemsCommand.executing;
//    
//    [self.viewModel.loadItemsCommand.executionSignals subscribeNext:^(id x) {
//        [self.loadView setHidden:NO];
//        
//    }];
    
//
  
//    
//    [RACObserve(  self.viewModel.loadItemsCommand,executing ) subscribeNext:^(RACSignal *  sig) {
//   //     [sig doNext:^(id x) {
//            
//    [sig subscribeCompleted:^{
//        
//    
//        
//        
//        NSLog(@"WTF???");
//        [self.tableView reloadData];
//    }];
//            
//        
//      //  }];
//    }];
// 
}
-(void)dealloc{
    
    
    NSLog(@"RAC TABLE DEALLOC");
}

#pragma mark - cell creatroes

-(UITableViewCell *)defaultCellWithItem:(id)item{
    if (!self.cellClass) {
        NSObject * obj=item;
        UITableViewCell * cell=[self dequeueReusableCellWithIdentifier:cellIndifiter];
        
        if (!cell) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndifiter];
        }
        cell.textLabel.text=obj.description;
        return cell;
        
    }else{
        
        NSObject * obj=item;
        UITableViewCell* cell=[self dequeueReusableCellWithIdentifier:cellIndifiter];
        
        if (!cell) {
            cell=[[self.cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndifiter];
        }
        
        if (self.objectKeyPath) {
            [cell setValue:obj forKey:self.objectKeyPath];
        }else{
            cell.textLabel.text=obj.description;
        }
        
        return cell;
        
    }
}
-(UITableViewCell *)loadCell{
    if (!self.loaderCellClass) {
        UITableViewCell * cell=[self dequeueReusableCellWithIdentifier:loadIndifiter];
        
        if (!cell) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:loadIndifiter];
        }
        
        return cell;
        
    }else{
        
        
        UITableViewCell* cell=[self dequeueReusableCellWithIdentifier:loadIndifiter];
        
        if (!cell) {
            cell=[[self.loaderCellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:loadIndifiter];
        }
        
        
        return cell;
        
    }
}
#pragma mark - data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
   
    NSUInteger itemsCount=self.viewModel.items.count ;
    
    if (itemsCount==0) {
        [self addSubview:self.emptyView];
        
        [self.emptyView setHidden:NO];
    }else{
        
        [self.emptyView setHidden:YES];
        if ([self.viewModel shouldShowLoadCell]) {
                 itemsCount++;
        }
   
    }
    
    return  itemsCount;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    if (indexPath.row<self.viewModel.items.count) {
        return [self defaultCellWithItem:[self.viewModel items][indexPath.row]];
    }else{
        return [self loadCell];
    }
}
#pragma mark - delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
        NSObject * obj=[self.viewModel items][indexPath.row];
    [self.viewModel.tableSelectionCommand execute:obj];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
       if (indexPath.row<self.viewModel.items.count) {
    return self.cellHeight;
       }else{
           return self.loaderCellHeight;
       }
}

-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
       if (indexPath.row<self.viewModel.items.count) {
           
           
       }else{
           
           
       }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
        //   NSLog(@"%@",cell.reuseIdentifier);
    if ([cell.reuseIdentifier isEqualToString:@"RACTVCLoadCellIndifiter"]){
        
       // NSLog(@"loadCell!!!");
        
        [self.viewModel.loadNextPageCommand execute:nil];
        
    }
    
    
    
    
    
}
@end
