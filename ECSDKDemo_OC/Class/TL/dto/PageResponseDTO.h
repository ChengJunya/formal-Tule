//
//  PageResponseDTO.h
//  alijk
//
//  Created by easy on 14/7/28.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import "BaseDTOModel.h"

@interface PageResponseDTO : JSONModel
//JSONModel json数据模型对象
@property (nonatomic, assign) NSInteger totalPages;     //总页码
@property (nonatomic, assign) NSInteger totalRecords;   //总记录数，总数据数

@end
