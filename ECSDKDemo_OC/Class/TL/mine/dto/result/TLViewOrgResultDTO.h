//
//  TLViewOrgResultDTO.h
//  TL
//
//  Created by Rainbow on 5/3/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "JSONModel.h"
#import "TLTripUserDTO.h"
@interface TLViewOrgResultDTO : JSONModel
@property (nonatomic,copy) NSString *organizationId;
@property (nonatomic,copy) NSString *cityId;
@property (nonatomic,copy) NSString *organizationName;
@property (nonatomic,copy) NSString *organizationDesc;
@property (nonatomic,copy) NSString *organizationCount;
@property (nonatomic,copy) NSArray<TLTripUserDTO> *users;

@end


/*

 " organizationId":1,              --组织编号
 "cityId":1,                             --组织归属地市编号
 "organizationName":""      --组织名称
 " organizationDesc":""        --组织简介
 "organizationCount":5000  --组织能容纳的人数
 users:[
 {
 "userName":"途乐Man" ,
 "userIndex":101,
 "userIcon":"   http://qlogo3.store.qq.com/qzone/641384094/641384094/100?1356670743 "
 "loginId":02141
 }
 ]
*/