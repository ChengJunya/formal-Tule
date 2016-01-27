//
//  TLSysMessageListRequestDTO.h
//  TL
//
//  Created by YONGFU on 5/31/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"

@interface TLSysMessageListRequestDTO : RequestDTO
@property (nonatomic,copy) NSString *currentTime;
@property (nonatomic,copy) NSString *pageSize;
@property (nonatomic,copy) NSString *currentPage;
@property (nonatomic,copy) NSString *type;//0 1 2 3 
@end


/**
 currentTime
 String
 是
 当前时间（yyyyMMddHHmmss）   如果是请求新的数据需要更新currentTime,如果是请求除了第一页以为的数据无需更新currentTime
 pageSize
 Strign
 是
 一次获取几条数据
 currentPage
 String
 是
 当前请求第几页的数据：初始为1
 type
 
 0：所有消息
 1：会员到期提醒 消息
 2：app升级提醒 消息
 3：消费记录提醒 消息

*/