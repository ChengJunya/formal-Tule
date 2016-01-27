//
//  TLListOrgRequestDTO.h
//  TL
//
//  Created by Rainbow on 5/3/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"

@interface TLListOrgRequestDTO : RequestDTO
@property(nonatomic,copy) NSString *type;
@property(nonatomic,copy) NSString *pageSize;
@property(nonatomic,copy) NSString *currentPage;
@property(nonatomic,copy) NSString *searchText;
@property(nonatomic,copy) NSString *organizationId;
@property(nonatomic,copy) NSString *provinceId;
@property(nonatomic,copy) NSString *cityId;

@end


/*
 type
 String
 是
 1: 我加入的组织
 2:全部组织
 pageSize
 String
 否
 注：type为2时必填
 一次获取几条数据
 currentPage
 String
 否
 注：type为2时必填
 当前请求第几页的数据：初始为1
 searchText
 String
 否
 注：type为2时可选
 组织名称搜索
 organizationId
 String
 否
 注：type为2时可选
 组织编号
 provinceId
 String
 否
 注：type为2时可选
 组织归属省份
 cityId
 String 
 否 
 注：type为2时可选 
 组织归属地市
*/