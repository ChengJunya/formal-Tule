//
//  TLMyFriendListRequestDTO.h
//  TL
//
//  Created by Rainbow on 4/27/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"

@interface TLMyFriendListRequestDTO : RequestDTO
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *phoneArray;
@property (nonatomic,copy) NSString *searchText;

@end


/*
 
 参数名称
 参数类型(String,json Object)
 是否必填（是，否）
 备注
 type
 String
 是
 1：好友列表
 2：好友推荐
 3：搜索好友
 phoneArray
 string
 否
 注：当type为2时需要填写该字段
 用户通讯录中的手机号码用分号连接成的字符串，例如：
 13211321122;18611212233
 searchText
 String
 否
 注：当type为3时需要填写该字段
 途乐号/用户名
*/