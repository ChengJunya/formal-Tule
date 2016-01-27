//
//  TLSysMessageDTO.h
//  TL
//
//  Created by YONGFU on 5/31/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "JSONModel.h"

@protocol TLSysMessageDTO

@end

@interface TLSysMessageDTO : JSONModel
@property (nonatomic,copy) NSString *messageId;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *createTime;
@property (nonatomic,copy) NSString *messageType;

@end


/**
 "messageId":1               --系统消息编号
 "content":""                   --系统消息内容
 "createTime":"2015-05-25 00:00:00"             --系统消息时间
 "messageType":""         --消息类型
 1：会员到期提醒 消息
 2：消费记录提醒 消息

*/