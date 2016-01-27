//
//  TLSimpleUserDTO.h
//  TL
//
//  Created by Rainbow on 4/28/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "JSONModel.h"

@protocol TLSimpleUserDTO



@end

@interface TLSimpleUserDTO : JSONModel
@property (nonatomic,copy) NSString<Optional> *userIndex;
@property (nonatomic,copy) NSString<Optional> *userName;
@property (nonatomic,copy) NSString<Optional> *age;
@property (nonatomic,copy) NSString<Optional> *gender;
@property (nonatomic,copy) NSString<Optional> *vipLevel;
@property (nonatomic,copy) NSString<Optional> *loginId;
@property (nonatomic,copy) NSString<Optional> *subAccount;
@property (nonatomic,copy) NSString<Optional> *subToken;
@property (nonatomic,copy) NSString<Optional> *voipAccount;
@property (nonatomic,copy) NSString<Optional> *voipToken;
@property (nonatomic,copy) NSString<Optional> *userIcon;
@property (nonatomic,copy) NSString<Optional> *shortIndex;
@property (nonatomic,copy) NSString<Optional> *distance;
@property (nonatomic,copy) NSString<Optional> *join;
@property (nonatomic,copy) NSString<Optional> *isSelected;


@end


/*
 {
 "userIndex":1                  --用户编号
 "userName":"舒淇",          --姓名
 "age": 27,  --年龄
 "gender":"0",       --"0":代表女 ，“1”:代表男
 "vipLevel":"1",    --vip等级
 "loginId":"2938347",       --登陆账号
 "subAccount":"46ec477faa1511e48ad3ac853d9f54f2",        --子账户（文本聊天需要）
 "subToken":"b63229de3754f6df8132c22c29544856",          --子账户token（文本聊天需要）
 "voipAccount":"84760500000006",    --voip子账户账户（语音聊天需要）
 "voipToken":"zDhnS7Nq",                 --voip子账户账户Token（语音聊天需要）
 "userIcon":"    http://img1.cache.netease.com/catchpic/E/EF/EFFF24DDCAB29F4BC5AD83A58980B1B1.jpg",                                           --用户头像
 }

*/