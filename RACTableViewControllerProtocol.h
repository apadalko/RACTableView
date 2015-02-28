//
//  RACTableViewControllerProtocol.h
//  Home Automation Wizzard
//
//  Created by Alex Padalko on 12/25/14.
//  Copyright (c) 2014 Alex Padalko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
@protocol RACTableViewControllerProtocol <NSObject>
@property(retain,nonatomic)NSMutableArray * items;

//@property (retain,nonatomic)RACSignal * loadItemsSignal;
@property (retain,nonatomic) RACCommand * loadItemsCommand;
@property (retain,nonatomic) RACCommand * tableSelectionCommand;
@property (retain,nonatomic) RACCommand * updateItemsCommand;

@property (retain,nonatomic) RACCommand * loadNextPageCommand;

-(BOOL)shouldShowLoadCell;
@end
