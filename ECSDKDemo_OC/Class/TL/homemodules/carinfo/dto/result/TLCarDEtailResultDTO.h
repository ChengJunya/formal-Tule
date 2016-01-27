//
//  TLCarDEtailResultDTO.h
//  TL
//
//  Created by Rainbow on 3/29/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "JSONModel.h"
#import "TLImageDTO.h"
@interface TLCarDEtailResultDTO : JSONModel



@property (nonatomic,copy) NSString *carId;//
@property (nonatomic,copy) NSString *carMaker;//
@property (nonatomic,copy) NSString *carBrand;//
@property (nonatomic,copy) NSString *carType;//
@property (nonatomic,copy) NSString *publishTime;//
@property (nonatomic,copy) NSString *seatCount;//
@property (nonatomic,copy) NSString *color;//
@property (nonatomic,copy) NSString *price_low;//
@property (nonatomic,copy) NSString *engine_low;//
@property (nonatomic,copy) NSString *gearBox_low;//
@property (nonatomic,copy) NSString *oilCost_low;//
@property (nonatomic,copy) NSString *drive_low;//
@property (nonatomic,copy) NSString *oilType_low;//
@property (nonatomic,copy) NSString *price_high;//
@property (nonatomic,copy) NSString *engine_high;//
@property (nonatomic,copy) NSString *gearBox_high;//
@property (nonatomic,copy) NSString *oilCost_high;//
@property (nonatomic,copy) NSString *drive_high;//
@property (nonatomic,copy) NSString *oilType_high;//
@property (nonatomic,copy) NSString *carDesc;//
@property (nonatomic,copy) NSString *viewCount;//
@property (nonatomic,copy) NSString *carEvalDesc;//
@property (nonatomic,copy) NSString *editor;//

@property (nonatomic,copy) NSString *createTime;

@property (nonatomic,copy) NSArray<TLImageDTO> *images;


@end


/*
 "carId":""              新车编号
 "carMaker":""           汽车制造商
 "carBrand":""           汽车品牌
 "carType":"SUV"         汽车类型
 "publishTime":"2015=05-01"
 "seatCount":"6座"       汽车座位数
 "color":""              可选颜色
 "price_low":""          低配价格
 "engine_low":""         低配发动机
 "gearBox_low":""        低配变速箱
 "oilCost_low":""        百公里油耗
 "drive_low":""          四驱/两驱
 "oilType_low":""        烧油类型
 "price_high":""         高配价格
 "engine_high":""        高配发动机
 "gearBox_high":""       高配变速箱
 "oilCost_high":""       高配百公里油耗
 "drive_high":""         四驱/两驱
 "oilType_high":""       燃油类型
 "carDesc":""            新车简介
 "viewCount":0           浏览量
 "carEvalDesc":""        评测详情
 " editor":""         创建用户
 "createTime":" 2014-01-02"         创建时间
 "images":  [{"imageName":"PHOTO_20150102",  "imageUrl":" http://hiphotos.baidu.com/lvpics/pic/item/73ca5910b8217aa4c3ce79a8.jpg "}]*/