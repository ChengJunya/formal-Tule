//
//  BoncColumnItem.h
//  TableViewGridTest
//
//  Created by Rainbow on 12/3/14.
//  Copyright (c) 2014 Rainbow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BoncColumnItem : UIView
///没一列的编码，从行数据获取编码对应的值
@property (nonatomic,strong) NSString *code;

@property (nonatomic,strong) NSDictionary *rowData;
@end
