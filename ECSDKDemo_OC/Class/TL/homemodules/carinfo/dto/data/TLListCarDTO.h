//
//  TLListCarDTO.h
//  TL
//
//  Created by Rainbow on 3/29/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "JSONModel.h"

@protocol TLListCarDTO



@end

@interface TLListCarDTO : JSONModel
@property (nonatomic,copy) NSString *carId;
@property (nonatomic,copy) NSString *carType;
@property (nonatomic,copy) NSString *priceRange;
@property (nonatomic,copy) NSString *publishTime;
@property (nonatomic,copy) NSString *editor;
@property (nonatomic,copy) NSString *createTime;
@property (nonatomic,copy) NSString *carImageUrl;
@end


/*
 {
 "carId":10                                 --车型编号
 " carType":"别克英朗",               --车型
 "priceRange":"9.7万-13万"      --价钱
 "publishTime":"2014-02-01"   --上市日期
 "editor":"admin"              --编辑用户
 "createTime":"2014-01-02"    --咨询发布日期
 "carImageUrl":"http://www.test.com/a.jpg"   --新车图片
 
 }
*/