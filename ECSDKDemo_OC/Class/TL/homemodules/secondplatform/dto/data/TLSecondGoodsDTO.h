//
//  TLSecondGoodsDTO.h
//  TL
//
//  Created by Rainbow on 3/31/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "JSONModel.h"

@protocol TLSecondGoodsDTO


@end

@interface TLSecondGoodsDTO : JSONModel
@property (nonatomic,copy) NSString *goodsId;
@property (nonatomic,copy) NSString *goodsName;

@property (nonatomic,copy) NSString *oldDesc;
@property (nonatomic,copy) NSString *goodsDesc;
@property (nonatomic,copy) NSString *price;
@property (nonatomic,copy) NSString *editor;
@property (nonatomic,copy) NSString *createTime;
@property (nonatomic,copy) NSString *goodsImageUrl;
@end


/*

 " goodsId":10                      --二手物品编号
 "oldDesc":"全新"                --成色描述
 " goodsDesc":“”              --宝贝描述
 " price": " 1200元 "                 --价格
 "editor":"李小姐"                --联系人
 "createTime":"2014-01-02"   --发布日期
 "goodsImageUrl":"http://www.test.com/a.jpg"   --宝贝图片
 
 }

*/