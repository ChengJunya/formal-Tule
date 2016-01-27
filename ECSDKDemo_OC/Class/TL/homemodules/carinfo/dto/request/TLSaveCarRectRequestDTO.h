//
//  TLSaveCarRectRequestDTO.h
//  TL
//
//  Created by Rainbow on 3/29/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"

@interface TLSaveCarRectRequestDTO : RequestDTO
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *carType;
@property (nonatomic,copy) NSString *rentType;
@property (nonatomic,copy) NSString *driveDistance;
@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSString *carDesc;
@property (nonatomic,copy) NSString *cityId;

@property (nonatomic,copy) NSString *price;
@property (nonatomic,copy) NSString *carAge;
@property (nonatomic,copy) NSString *isTop;
@property (nonatomic,copy) NSArray *carImage;

@property(nonatomic,copy) NSString *operateType;//1-add 2-modify
@property(nonatomic,copy) NSString *objId;//

@end


/*
 cityId
 String
 是
 地市编号
 price
 int
 是
 租赁价格（正整数）
 carAge
 String
 是
 车龄
 
 

 title
 String
 是
 标题
 carType
 String
 是
 车型
 rentType
 String
 是
 租赁方式
 1：日租
 2：月租
 注：用码表接口返回   rentType
 driveDistance
 String
 是
 行驶公里数
 address
 String
 是
 地址
 carDesc
 String
 是
 车辆描述
 isTop
 String
 是
 1：置顶
 0：不置顶
 carImage
 文件数组
 是
 图片
 
 
*/