//
//  TLOrgDataDTO.h
//  TL
//
//  Created by Rainbow on 5/3/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "JSONModel.h"

@protocol TLOrgDataDTO

@end

@interface TLOrgDataDTO : JSONModel
@property (nonatomic,copy) NSString *organizationId;
@property (nonatomic,copy) NSString *cityId;
@property (nonatomic,copy) NSString *organizationName;
@property (nonatomic,copy) NSString *organizationCount;
@property (nonatomic,copy) NSString<Optional> *join;
@property (nonatomic,copy) NSString<Optional> *shortIndex;
@property (nonatomic,copy) NSString<Optional> *distance;

@end

/*

 {
 " organizationId":1,              --组织编号
 "cityId":1,                             --组织归属地市编号
 "organizationName":""      --组织名称
 "organizationCount":5000  --组织能容纳的人数
 }

*/