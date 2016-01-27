//
//  TLCarEvalDetailResultDTO.h
//  TL
//
//  Created by Rainbow on 3/29/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "JSONModel.h"
#import "TLImageDTO.h"
@interface TLCarEvalDetailResultDTO : JSONModel
@property (nonatomic,copy) NSString *carEvaId;
@property (nonatomic,copy) NSString *carType;
@property (nonatomic,copy) NSString *oilCost;
@property (nonatomic,copy) NSString *publishTime;
@property (nonatomic,copy) NSString *editor;
@property (nonatomic,copy) NSString *createTime;
@property (nonatomic,copy) NSString *carEvalDesc;
@property (nonatomic,copy) NSArray<TLImageDTO> *images;
@end


/*

 " carEvaId":11                          -- 车型评测编号
 " carType":"别克英朗",             --车型
 "oilCost":"7.3/100km"            --油耗
 "publishTime":"2014-02-01" --上市日期
 "editor":"admin"                   --编辑用户
 "createTime":"2014-01-02"   --咨询发布日期
 "images":  [{"imageName":"PHOTO_20150102",  "imageUrl":" http://hiphotos.baidu.com/lvpics/pic/item/73ca5910b8217aa4c3ce79a8.jpg "}]
 "carEvalDesc":"去年11月，国产极光已经在奇瑞捷豹路虎的常熟工厂下线"
 --新车简介
 
*/