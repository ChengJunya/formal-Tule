//
//  BoncDataGridDataSource.h
//  TableViewGridTest
//
//  Created by Rainbow on 12/2/14.
//  Copyright (c) 2014 Rainbow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BoncColumnSelectView.h"
#import "BoncDataGridHeaderView.h"

@interface BoncDataGridDataSource : NSObject<UITableViewDataSource,UITableViewDelegate,BoncColumnSelectViewDelegate,BoncDataGridHeaderViewDelegate>

@property (nonatomic,copy) void (^ItemSelectedBlock)(id itemData);
@property (nonatomic,strong) NSArray *sections;
@property (nonatomic,strong) NSDictionary *headerData;
@property (nonatomic,strong) NSMutableArray *gridData;
@property (nonatomic,strong) NSMutableArray *gridColumns;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSDictionary *itemData;
@property (nonatomic,strong)BoncColumnSelectView *columnSelectView;

@property (nonatomic,assign)BOOL isColumnSelectViewHidden;

-(instancetype)initWithTableView:(UITableView*)tableView itemData:(NSDictionary*)itemData;

@end
