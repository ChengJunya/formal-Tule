//
//  BoncDataGridCell.h
//  TableViewGridTest
//
//  Created by Rainbow on 12/2/14.
//  Copyright (c) 2014 Rainbow. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "BoncDefine.h"

@interface BoncDataGridCell : UITableViewCell
///保存每行每列的渲染视图 每一个视图包含CODE属性
@property (nonatomic,strong) NSMutableArray *columns;
///行数据
@property (nonatomic,strong) NSDictionary *rowData;
@property (nonatomic,strong) NSDictionary *headerData;
@property (nonatomic,strong) NSMutableArray *columnWidths;
@property (nonatomic,strong) CALayer *lineLayer;

/////////BLOCK/////////
@property (nonatomic, copy) void (^CheckBoxBlock)();
@property (nonatomic, copy) void (^DeleteItemBlock)(NSDictionary *);

- (void)initContent;
@end
