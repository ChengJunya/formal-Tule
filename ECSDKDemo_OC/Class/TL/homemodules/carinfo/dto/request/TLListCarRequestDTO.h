//
//  TLListCarRequestDTO.h
//  TL
//
//  Created by Rainbow on 3/29/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "TLTripListRequestDTO.h"

@interface TLListCarRequestDTO : TLTripListRequestDTO

@property (nonatomic,copy) NSString *carType;

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
*/