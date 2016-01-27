//
//  TLCarServiceResult.h
//  TL
//
//  Created by Rainbow on 3/30/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "JSONModel.h"
#import "TLImageDTO.h"
#import "TLTripUserDTO.h"


@interface TLCarServiceResult : JSONModel
@property (nonatomic,copy) NSString *serviceId;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *createTime;
@property (nonatomic,copy) NSString *viewCount;
@property (nonatomic,copy) NSString *commentCount;
@property (nonatomic,copy) NSString *serviceType;
@property (nonatomic,copy) NSString *rank;
@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSString *serviceDesc;
@property (nonatomic,copy) NSString *userPhone;
@property (nonatomic,copy) NSString<Optional> *isTop;


@property (nonatomic,copy) NSString<Optional> *cityId;
@property (nonatomic,copy) NSString<Optional> *cityName;

@property (nonatomic,copy) NSArray<TLImageDTO> *images;
@property (nonatomic,copy) TLTripUserDTO *user;
@end


/*

 "serviceId":10                               --服务商编号
 "title":"别克昂科威"                  --标题
 "createTime":"2015-03-06"    -- 发布日期(yyyy-MM-dd)
 "viewCount":20                       --浏览次数
 "commentCount":10               --评论次数
 "serviceType":["车辆维修"]      -- 服务种类
 "rank":3                                   --3星
 "address":"上海是浦东新区金桥路"  --所在地
 "serviceDesc":"服务描述"               --服务描述
 "images":  [{"imageName":"PHOTO_20150102",  "imageUrl":" http://hiphotos.baidu.com/lvpics/pic/item/73ca5910b8217aa4c3ce79a8.jpg "}]    --租赁车型图片
 "user":{
 "userName":"途乐Man" ,
 "userIndex":101,
 "userIcon":"  http://qlogo3.store.qq.com/qzone/641384094/641384094/100?1356670743 "
 }       --用户信息
 "userPhone":"13511201122"   --店家手机号码
 

*/