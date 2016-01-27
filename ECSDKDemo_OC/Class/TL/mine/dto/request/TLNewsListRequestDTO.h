//
//  TLNewsListRequestDTO.h
//  TL
//
//  Created by Rainbow on 4/27/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"

@interface TLNewsListRequestDTO : RequestDTO
@property (nonatomic,copy) NSString *pageSize;
@property (nonatomic,copy) NSString *currentPage;
@property (nonatomic,copy) NSString *currentTime;
@property (nonatomic,copy) NSString *searchText;
@property (nonatomic,copy) NSString *type;

@end



/*

 pageSize
 String
 是
 一次获取几条数据
 currentPage
 String
 是
 当前请求第几页的数据：初始为1
 currentTime
 String
 是
 当前时间（yyyyMMddHHmmss）   如果是请求新的数据需要更新currentTime,如果是请求除了第一页以为的数据无需更新currentTime
 searchText
 String
 否
 搜索关键字（用于全局搜索接口）


*/