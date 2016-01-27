//
//  TLSaveMarchantRequestDTO.h
//  TL
//
//  Created by YONGFU on 5/31/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"

@interface TLSaveMarchantRequestDTO : RequestDTO
@property (nonatomic,copy) NSString *merchantName;
@property (nonatomic,copy) NSString *merchantType;
@property (nonatomic,copy) NSString *openTime;
@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSString *parking;
@property (nonatomic,copy) NSString *merchantDesc;
@property (nonatomic,copy) NSString *cityId;
@property (nonatomic,copy) NSString *phone;
@property (nonatomic,copy) UIImage *merchantIcon;
@property (nonatomic,copy) NSArray *merchantImages;
@property (nonatomic,copy) NSString *longtitude;
@property (nonatomic,copy) NSString *latitude;

@end


/**
 merchantName
 String
 是
 商户名称
 merchantType
 String
 是
 商家类型，从码表获取
 merchantType
 openTime
 String
 是
 营业时间
 address
 String
 是
 商户地址
 parking
 String
 是
 是否有停车位 1:有，0:没有
 merchantDesc
 String
 是
 商家描述
 cityId
 String
 是
 商户所在地市
 phone
 String
 是
 联系电话
 merchantIcon
 文件
 是
 商户头像
 merchantImages
 文件数组
 是
 商户图片数组
 longtitude
 String
 是
 商户所在位置经度
 latitude
 String
 是
 商户所在位置纬度

*/