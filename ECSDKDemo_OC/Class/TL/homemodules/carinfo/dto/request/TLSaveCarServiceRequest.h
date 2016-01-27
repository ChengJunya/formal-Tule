//
//  TLSaveCarServiceRequest.h
//  TL
//
//  Created by Rainbow on 3/30/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"

@interface TLSaveCarServiceRequest : RequestDTO
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *serviceType;
@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSString *serviceDesc;
@property (nonatomic,copy) NSString *isTop;
@property (nonatomic,copy) NSArray *serviceImage;

@property(nonatomic,copy) NSString *operateType;//1-add 2-modify
@property(nonatomic,copy) NSString *objId;//
@property(nonatomic,copy) NSString *longtitude;//
@property(nonatomic,copy) NSString *latitude;//

@end


/*

 
 longtitude
 String
 是
 商家所在位置经度（取用户当前的经度）
 latitude
 
 
 title
 String
 是
 标题
 serviceType
 String
 是
 服务类型：
 1：车辆维修
 2：洗车服务
 3：洗车用品
 4：车辆保险
 i、可以选择多个服务种类，传参时用“，”进行拼接
 ii、服务类型从后端获取：serviceType
 address
 String
 是
 地址
 serviceDesc
 String
 是
 服务描述
 isTop
 String
 是
 1：置顶
 0：不置顶
 serviceImage
 文件数组
 是
 图片

*/