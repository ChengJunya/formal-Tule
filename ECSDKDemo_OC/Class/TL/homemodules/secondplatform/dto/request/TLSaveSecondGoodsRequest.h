//
//  TLSaveSecondGoodsRequest.h
//  TL
//
//  Created by Rainbow on 3/31/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"

@interface TLSaveSecondGoodsRequest : RequestDTO
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *goodsName;
@property (nonatomic,copy) NSString *oldDesc;
@property (nonatomic,copy) NSString *price;
@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSString *goodsDesc;
@property (nonatomic,copy) NSArray *goodsImage;
@property (nonatomic,copy) NSString *isTop;
@property (nonatomic,copy) NSString *goodsType;



@property(nonatomic,copy) NSString *operateType;//1-add 2-modify
@property(nonatomic,copy) NSString *objId;//

@end

/**

 title
 String
 是
 标题
 goodsName
 String
 是
 宝贝名称
 oldDesc
 String
 是
 成色
 price
 String
 是
 价钱
 address
 String
 是
 联系地址
 goodsDesc
 String
 是
 宝贝描述
 goodsImage
 文件数组
 是
 图片
*/