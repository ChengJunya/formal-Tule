//
//  TLViewCarRectResultDTO.h
//  TL
//
//  Created by Rainbow on 3/29/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "JSONModel.h"
#import "TLImageDTO.h"
#import "TLTripUserDTO.h"

@interface TLViewCarRectResultDTO : JSONModel
@property (nonatomic,copy) NSString *rentId;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *createTime;
@property (nonatomic,copy) NSString *viewCount;
@property (nonatomic,copy) NSString *commentCount;
@property (nonatomic,copy) NSString *carType;
@property (nonatomic,copy) NSString *driveDistance;
@property (nonatomic,copy) NSString *rentType;
@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSString *carDesc;
@property (nonatomic,copy) NSString<Optional> *rentMoney;
@property (nonatomic,copy) NSString<Optional> *require;
@property (nonatomic,copy) NSString<Optional> *cityId;
@property (nonatomic,copy) NSString<Optional> *cityName;


@property (nonatomic,copy) NSArray<TLImageDTO> *images;
@property (nonatomic,copy) TLTripUserDTO *user;
@property (nonatomic,copy)NSString<Optional> *userPhone;


@end



/**


 "rentId":10                               --租赁编号
 "title":"别克昂科威"                  --标题
 "createTime":"2015-03-06"    -- 发布日期(yyyy-MM-dd)
 "viewCount":20                       --浏览次数
 "commentCount":10               --评论次数
 "carType":"别克昂科威"           -- 车型
 "driveDistance":"2000公里"    --行驶距离
 "rentType":"日租"                    --租赁方式
 "address":"上海是浦东新区金桥路"  --所在地
 "carDesc":"车辆描述"               --车辆描述
 "images":  [{"imageName":"PHOTO_20150102",  "imageUrl":" http://hiphotos.baidu.com/lvpics/pic/item/73ca5910b8217aa4c3ce79a8.jpg "}]    --租赁车型图片
 "user":{
 "userName":"途乐Man" ,
 "userIndex":101,
 "userIcon":"   http://qlogo3.store.qq.com/qzone/641384094/641384094/100?1356670743 "
 }       --用户信息
*/