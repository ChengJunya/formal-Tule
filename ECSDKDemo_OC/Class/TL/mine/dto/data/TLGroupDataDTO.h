//
//  TLGroupDataDTO.h
//  TL
//
//  Created by Rainbow on 5/3/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "JSONModel.h"
#import "TLTripUserDTO.h"
@protocol TLGroupDataDTO


@end

@interface TLGroupDataDTO : JSONModel
@property (nonatomic,copy) NSString *groupId;
@property (nonatomic,copy) NSString *cityName;
@property (nonatomic,copy) NSString *provinceName;
@property (nonatomic,copy) NSString *groupName;
@property (nonatomic,copy) NSString<Optional> *shortIndex;
@property (nonatomic,copy) NSString *groupDesc;
@property (nonatomic,copy) NSString *groupIcon;
@property (nonatomic,copy) NSString *groupCreateTime;
@property (nonatomic,copy) NSString<Optional> *join;
@property (nonatomic,copy) NSString *rlGroupId;
@property (nonatomic,copy) NSString<Optional> *distance;
@property (nonatomic,copy) NSString<Optional> *create;

@property (nonatomic,copy) TLTripUserDTO *createUser;
@end


/*
 " groupId":1,              --群组编号
 "provinceName":"",  --省份名称
 "cityName":""            --地市名称
 "groupName":""      --群组名称
 "shortIndex":"T"       -x-群名称首字母缩写
 "groupDesc":""          --群组简介
 "groupIcon":""          --群组图标
 "groupCreateTime":"2015-06-01"   群组创建时间
 "join":"1"                   --1:已经加入该群组，
 0:未加入
 "createUser":{
 "userName":"途乐Man" ,
 "userIndex":101,
 "userIcon":"   http://qlogo3.store.qq.com/qzone/641384094/641384094/100?1356670743 "
 "loginId":02141
 
 }
 }
 }
 }
*/