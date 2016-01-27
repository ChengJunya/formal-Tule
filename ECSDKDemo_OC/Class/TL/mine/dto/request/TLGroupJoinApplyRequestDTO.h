//
//  TLGroupJoinApplyRequestDTO.h
//  TL
//
//  Created by Rainbow on 5/6/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"

@interface TLGroupJoinApplyRequestDTO : RequestDTO
@property(nonatomic,copy) NSString *rlGroupId;
@property(nonatomic,copy) NSString *type;
@property(nonatomic,copy) NSString *voipAccount;
@property(nonatomic,copy) NSString *confirm;
@property(nonatomic,copy) NSString *rule;
@property(nonatomic,copy) NSString *groupName;
@property(nonatomic,copy) NSString *groupDesc;

@end


/*
 type	String	是	0：用户申请加入群组
 1：管理员验证用户申请加入群组
 2：成员主动退出群组
 3：设置群组消息接收规则
 4：删除群组
 5：修改群组
 rlGroupId	String	否	容联群组编号
 注：type=0时为必填
 type=1时为必填
 type=2时为必填
 type=3时为必填
 type=4时为必填
 type=5时为必填
 voipAccount
 String
 否
 容联对应的群组成员账号
 注：type=1时为必填
 confirm
 String
 否
 0 ：通过 1：拒绝
 注：type=1时为必填
 rule
 String
 否
 接收规则 0：接收 1：拒绝   默认为0
 注：type=3时为必填
 groupName
 String
 否
 群组名称
 注：type=5时为必填
 groupDesc
 String
 否
 群组描述
 注：type=5时为必填
*/