//
//  TLViewGroupResultDTO.h
//  TL
//
//  Created by Rainbow on 5/6/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "JSONModel.h"
#import "TLTripUserDTO.h"
@interface TLViewGroupResultDTO : JSONModel
@property (nonatomic,copy) NSString *groupId;
@property (nonatomic,copy) NSString *provinceName;
@property (nonatomic,copy) NSString *groupName;
@property (nonatomic,copy) NSString *cityName;
@property (nonatomic,copy) NSString *groupIcon;
@property (nonatomic,copy) NSString *groupCount;
@property (nonatomic,copy) NSString *groupDesc;
@property (nonatomic,copy) NSString *groupCreateTime;
@property (nonatomic,copy) NSString *join;
@property (nonatomic,copy) NSString *rlGroupId;

@property (nonatomic,copy) TLTripUserDTO *createUser;
@property (nonatomic,copy) NSArray<TLTripUserDTO> *groupUser;


@end


/*
 {
 " groupId":1,              --群组编号
 "provinceName":"北京市"    --群组归属省份
 "groupName":""      --群组名称
 "cityName":"朝阳区"      --群组归属地市
 "groupIcon":""          --群组图标
 "groupCount":200    --群最大能容纳人数
 "groupDesc":""        --群描述
 "groupCreateTime":"2015-06-01"   群组创建时间
 "join":"1"                   --1:已经加入该群组，
 0:未加入
 "createUser":{
 "userName":"途乐Man" ,
 "userIndex":101,
 "userIcon":"  http://qlogo3.store.qq.com/qzone/641384094/641384094/100?1356670743 "
 "loginId":02141
 
 }
 "groupUser":[
 
 {
 "userName":"途乐Man" ,
 "userIndex":101,
 "userIcon":"  http://qlogo3.store.qq.com/qzone/641384094/641384094/100?1356670743 "
 "loginId":02141
 }
 ]                 --群组成员
 }
 ]



*/