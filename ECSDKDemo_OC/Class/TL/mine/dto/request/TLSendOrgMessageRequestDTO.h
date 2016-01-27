//
//  TLSendOrgMessageRequestDTO.h
//  TL
//
//  Created by Rainbow on 5/3/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"

@interface TLSendOrgMessageRequestDTO : RequestDTO
@property (nonatomic,copy) NSString *organizationId;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *content;
@end


/*
 organizationId
 String
 是
 组织编号
 content
 String
 是
 消息内容
 type
 
 
 
 1：返回发送小喇叭需要消耗途乐币的消息
 2：发送小喇叭消息
*/