//
//  TLCarServiceDTO.h
//  TL
//
//  Created by Rainbow on 3/30/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "JSONModel.h"

@protocol TLCarServiceDTO

@end

@interface TLCarServiceDTO : JSONModel
@property (nonatomic,copy) NSString *serviceId;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *rank;
@property (nonatomic,copy) NSString *serviceType;
@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSString *createTime;
@property (nonatomic,copy) NSString *serviceImageUrl;


@end


/*

 {
 "serviceId":10                         --服务编号
 "title":"日租"                           --租赁方式
 "rank":3                                  --评分
 " serviceType":[" 车辆维修"," 洗车服务"]
 --服务种类
 "address":"地址"                     --地址
 "createTime":"2014-01-02"   --发布日期
 "serviceImageUrl":"http://www.test.com/a.jpg"   --车图片
 
 }
 
 ]

*/