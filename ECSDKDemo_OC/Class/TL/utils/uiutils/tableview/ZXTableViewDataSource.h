//
//  ZXTableViewDataSource.h
//  alijk
//
//  Created by Rainbow on 3/5/15.
//  Copyright (c) 2015 zhongxin. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ZXTableViewDataSource : NSObject<UITableViewDataSource,UITableViewDelegate>


@property (nonatomic,copy) void (^ItemSelectedBlock)(id itemData);
@property (nonatomic,copy) void (^ItemDeleteBlock)(id itemData);
@property (nonatomic,strong) NSArray *sections;
@property (nonatomic,strong) NSMutableArray *gridData;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSDictionary *itemData;
@property (nonatomic,assign) BOOL canEditRow;

@property (nonatomic,copy) UITableViewCell* (^CellBlock)(id,id,UITableView *);//celldata sectiondata uitableview

@property (nonatomic,copy) UIView* (^HeaderBlock)(id,UITableView *);
@property (nonatomic,copy) CGFloat (^CellHeightBlock)();


-(instancetype)initWithTableView:(UITableView*)tableView itemData:(id)itemData;

@end