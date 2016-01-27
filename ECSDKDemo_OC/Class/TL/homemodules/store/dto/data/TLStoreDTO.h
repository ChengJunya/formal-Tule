//
//  TLStoreDTO.h
//  TL
//
//  Created by Rainbow on 4/1/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "JSONModel.h"

@protocol TLStoreDTO


@end

@interface TLStoreDTO : JSONModel
@property (nonatomic,copy) NSString *merchantId;
@property (nonatomic,copy) NSString *merchantName;
@property (nonatomic,copy) NSString *rank;
@property (nonatomic,copy) NSString *merchantType;
@property (nonatomic,copy) NSString *editor;
@property (nonatomic,copy) NSString *createTime;
@property (nonatomic,copy) NSString *merchantImageUrl;
@property (nonatomic,copy) NSString *distance;


@end


/*

 {
 " merchantId":10                --商家编号
 "merchantName":""          --商家名称
 " rank":4                              --评分
 " merchantType": "美食 "     --价格
 "editor":"李小姐"                --联系人
 "createTime":"2014-01-02"   --发布日期
 "merchantImageUrl":"http://www.test.com/a.jpg"   --商家图片
 
 }

*/