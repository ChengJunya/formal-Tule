//
//  CustomerTableViewCell.h
//  ContractManager
//
//  Created by Rainbow on 12/27/14.
//  Copyright (c) 2014 BONC. All rights reserved.
//

#import <UIKit/UIKit.h>


#define CustomerTableViewCell_IMAGE_GAP 2.0f
@interface CustomerTableViewCell : UITableViewCell
///保存每行每列的渲染视图 每一个视图包含CODE属性
@property (nonatomic,strong) NSMutableArray *columns;
///行数据
@property (nonatomic,strong) NSDictionary *rowData;
@property (nonatomic,strong) CALayer *lineLayer;
- (void)initContent;
@end
