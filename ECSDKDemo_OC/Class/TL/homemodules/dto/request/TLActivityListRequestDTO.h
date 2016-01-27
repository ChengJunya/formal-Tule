//
//  TLActivityListRequestDTO.h
//  TL
//
//  Created by Rainbow on 3/20/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "TLTripListRequestDTO.h"

@interface TLActivityListRequestDTO : TLTripListRequestDTO

@end


/**
 pageSize
 String
 是
 一次获取几条数据
 currentPage
 String
 是
 当前请求第几页的数据：初始为1
 cityId
 String
 是
 城市编号
 orderByTime
 String
 是
 0:不按照发表时间来排序
 1:按照发表时间来排序
 orderByViewCount
 String
 是
 0:不按照人气来排序
 1:按照人气来排序
*/