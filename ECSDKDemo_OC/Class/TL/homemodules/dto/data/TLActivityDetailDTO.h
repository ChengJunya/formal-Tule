//
//  TLActivityDetailDTO.h
//  TL
//
//  Created by Rainbow on 3/20/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "JSONModel.h"
#import "TLImageDTO.h"
#import "TLTripUserDTO.h"
@interface TLActivityDetailDTO : JSONModel

@property(nonatomic,copy) NSString *activityId;//活动ID
@property(nonatomic,copy) NSString *title;//活动标题
@property(nonatomic,copy) NSString *destnation;//目的地
@property(nonatomic,copy) NSString *costAverage;//人均消费
@property(nonatomic,copy) NSString *personNum;//活动人数
@property(nonatomic,copy) NSString *desc;//内容描述
@property(nonatomic,copy) NSString *viewCount;//浏览人数
@property(nonatomic,copy) NSString *commentCount;//评论人数
@property (nonatomic,copy) NSString *collectCount;
@property (nonatomic,copy) NSString *enrollCount;
@property (nonatomic,copy) NSString *publishTime;
@property (nonatomic,copy) NSString *userPhone;
//
@property (nonatomic,copy) NSString<Optional> *startDate;
@property (nonatomic,copy) NSString<Optional> *endDate;
@property (nonatomic,copy) NSString<Optional> *cityId;
@property (nonatomic,copy) NSString<Optional> *cityName;

@property(nonatomic,copy) NSArray<TLImageDTO> *images;//
@property(nonatomic,copy) TLTripUserDTO *user;//
@property(nonatomic,copy) NSArray<TLTripUserDTO> *enrollUsers;



@end


/**

 data:[
 
 {
 " title":"看看内蒙古的天空",      --活动标题
 "destnation":"故宫"                --目的地
 "costAverage":200                 --人均消费
 "personNum":"1"                   --活动人数
 "desc":"天空真的很蓝"            --内容描述
 "viewCount":300                   --浏览人数
 "commentCount":200           --评论人数
 "activityImages":["http://www.test.com/a.jpg"]    --活动首页的图片
 
 "user":{
 "userName":"途乐Man" ,
 "userId":101,
 "userIcon":" http://qlogo3.store.qq.com/qzone/641384094/641384094/100?1356670743 "
 }       --用户信息
 
 }
 
 ]
 
*/