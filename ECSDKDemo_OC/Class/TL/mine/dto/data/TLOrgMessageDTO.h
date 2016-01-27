//
//  TLOrgMessageDTO.h
//  TL
//
//  Created by YONGFU on 5/19/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "JSONModel.h"
#import "TLTripUserDTO.h"

@protocol TLOrgMessageDTO


@end

@interface TLOrgMessageDTO : JSONModel
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *createDate;
@property (nonatomic,copy) NSString *busType;
@property (nonatomic,copy) NSString *objId;
@property (nonatomic,copy) TLTripUserDTO *createUser;



@end

/*
 
 {
 "content":"组织消息"                              --消息内容
 "createDate":"2014-05-11 00:00:00"    -- 消息时间
 "busType":"17"          --消息类型 1:攻略,2:路书,3:游记,17:小喇叭
 "objId":"1"               --消息详情编号
 "createUser":{
 "userName":"途乐Man" ,
 "userIndex":101,
 "userIcon":"  http://qlogo3.store.qq.com/qzone/641384094/641384094/100?1356670743 "
 "loginId":02141
 
 }
 }
 
 */