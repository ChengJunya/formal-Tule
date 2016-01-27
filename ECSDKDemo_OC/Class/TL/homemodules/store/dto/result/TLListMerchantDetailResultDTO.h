//
//  TLListMerchantDetailResultDTO.h
//  TL
//
//  Created by Rainbow on 4/1/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "JSONModel.h"
#import "TLImageDTO.h"

@interface TLListMerchantDetailResultDTO : JSONModel
@property (nonatomic,copy) NSString *merchantId;
@property (nonatomic,copy) NSString *merchantName;
@property (nonatomic,copy) NSString *createTime;
@property (nonatomic,copy) NSString *viewCount;
@property (nonatomic,copy) NSString *commentCount;
@property (nonatomic,copy) NSString *rank;
@property (nonatomic,copy) NSString *openTime;
@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSString *park;
@property (nonatomic,copy) NSString *merchantDesc;
@property(nonatomic,copy) NSArray<TLImageDTO> *images;
@property (nonatomic,copy) NSString *merchantIcon;
@property (nonatomic,copy) NSString<Optional> *city;
@property (nonatomic,copy) NSString<Optional>  *phone;
@property (nonatomic,copy) NSString<Optional>  *authorize;
@property (nonatomic,copy) NSString<Optional>  *longtitude;
@property (nonatomic,copy) NSString<Optional>  *latitude;
@property (nonatomic,copy) NSString<Optional>  *merchantType;


@end


/*

 "merchantId":10                       --商家编号
 "merchantName":"来伊粉"      --商家名称
 "createTime":"2015-03-06"     -- 发布日期(yyyy-MM-dd)
 "viewCount":20                        --浏览次数
 "commentCount":10                --评论次数
 "rank":4                                    --商家评分
 "openTime":"9:00-22:00"         --营业时间
 "address":"上海市浦东新区金桥路"   --商家所在地
 "park":"无停车场"                    --停车场描述
 "merchantDesc":""                   --商家描述
 "images":  [{"imageName":"PHOTO_20150102",  "imageUrl":" http://hiphotos.baidu.com/lvpics/pic/item/73ca5910b8217aa4c3ce79a8.jpg "}]    --租赁车型图片

 
 "authorize":"1"                        --是否认证商家(新增)
 （0:未认证，1:已认证）
 "phone":"020-1102211"       --商家联系方式(新增)
 "city":"上海"                             --所在地
*/