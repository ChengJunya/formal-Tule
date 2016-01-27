//
//  TLSecondGoodsResult.h
//  TL
//
//  Created by Rainbow on 3/31/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "JSONModel.h"
#import "TLImageDTO.h"
#import "TLTripUserDTO.h"

@interface TLSecondGoodsResult : JSONModel
@property(nonatomic,copy) NSString *goodsId;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *createTime;
@property(nonatomic,copy) NSString *viewCount;
@property(nonatomic,copy) NSString *commentCount;
@property(nonatomic,copy) NSString *goodsName;
@property(nonatomic,copy) NSString *oldDesc;
@property(nonatomic,copy) NSString *price;
@property(nonatomic,copy) NSString *address;
@property(nonatomic,copy) NSString *goodsDesc;
@property(nonatomic,copy) NSString<Optional> *cityId;
@property(nonatomic,copy) NSString<Optional> *cityName;
@property(nonatomic,copy) NSString<Optional> *goodsType;

@property(nonatomic,copy) NSArray<TLImageDTO> *images;
@property(nonatomic,copy) TLTripUserDTO *user;
@property(nonatomic,copy) NSString *userPhone;
@end

/*
 
 
 "goodsId":10                            --二手宝贝编号
 "title":"ipad mini"                  --标题
 "createTime":"2015-03-06"    -- 发布日期(yyyy-MM-dd)
 "viewCount":20                       --浏览次数
 "commentCount":10               --评论次数
 "goodsName":"ipad mini"      --宝贝名称
 "oldDesc":"全新"                      --宝贝成色
 "price":"1200元"                       --价格
 "address":"上海市浦东新区金桥路"               --宝贝所在地
 "goodsDesc":""                        --宝贝描述
 "images":  [{"imageName":"PHOTO_20150102",  "imageUrl":" http://hiphotos.baidu.com/lvpics/pic/item/73ca5910b8217aa4c3ce79a8.jpg "}]    --租赁车型图片
 "user":{
 "userName":"途乐Man" ,
 "userIndex":101,
 "userIcon":"  http://qlogo3.store.qq.com/qzone/641384094/641384094/100?1356670743 "
 }       --用户信息
 "userPhone":"13511201122"   --店家手机号码
 
 }
 */