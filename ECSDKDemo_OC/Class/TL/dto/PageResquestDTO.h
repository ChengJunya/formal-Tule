//
//  PageResquest.h
//  alijk
//
//  Created by easy on 14/7/28.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import "BaseDTOModel.h"

//获取数据 发送请求的时候需要使用的页面信息数据对象
@interface PageResquestDTO : JSONModel

@property (nonatomic, assign) NSInteger curPage; // 当前页
@property (nonatomic, assign) NSInteger pageSize; // 每页条数
@property (nonatomic, assign) NSInteger totalPages; //总页数 首次为空
@property (nonatomic, assign) NSInteger totalRecords; //总条数 首次为空

@end
