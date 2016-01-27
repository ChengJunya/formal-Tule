//
//  TLCarRectDTO.h
//  TL
//
//  Created by Rainbow on 3/29/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "JSONModel.h"


@protocol TLCarRectDTO



@end

@interface TLCarRectDTO : JSONModel
@property (nonatomic,copy) NSString *rentId;
@property (nonatomic,copy) NSString *carType;
@property (nonatomic,copy) NSString *rentType;
@property (nonatomic,copy) NSString *driveDistance;
@property (nonatomic,copy) NSString *editor;
@property (nonatomic,copy) NSString *createTime;
@property (nonatomic,copy) NSString *carImageUrl;

@end


/*

 {
 "rentId":10                               --租赁编号
 " carType":"别克英朗",              --车型
 "rentType":"日租"                    --租赁方式
 "driveDistance":"10000公里"                     --行驶里程
 "editor":"admin"                      --编辑用户
 "createTime":"2014-01-02"     --咨询发布日期
 "carImageUrl":"http://www.test.com/a.jpg"   --车图片
 
 }
*/