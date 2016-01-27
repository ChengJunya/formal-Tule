//
//  TLTripDetailDTO.h
//  TL
//
//  Created by Rainbow on 3/17/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "JSONModel.h"
#import "TLImageDTO.h"
#import "TLTripUserDTO.h"
//详情信息
@interface TLTripDetailDTO : JSONModel
@property(nonatomic,copy) NSString *travelId;
@property(nonatomic,copy) NSString *cityId;
@property(nonatomic,copy) NSString *cityName;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *createTime;
@property(nonatomic,copy) NSString *viewCount;
@property(nonatomic,copy) NSString *commentCount;
@property(nonatomic,copy) NSString *collectCount;
@property(nonatomic,copy) NSString *content;
@property(nonatomic,copy) NSString<Optional> *isTop;
@property(nonatomic,copy) NSArray<TLImageDTO> *images;
@property(nonatomic,copy) TLTripUserDTO *user;





@end

/**
 
 
 
 

 注：当resultType为1时才会有值
 {
 
 "travelId":"101",    --编号
 "cityId":"1"                --地市编号
 "cityName":"北京",            --地市名称
 "title":"有一个地方叫【北京故宫】",     --名称
 "createTime":"2014-1-12 00:00:00",         --时间
 "praiseCount":2221,                 --点赞次数
 "viewCount":1234,                  --浏览次数
 "commentCount":1232,          --评论次数
 
 "collectCount":1211,               --收藏次数
 
 "content":"这一次简短的攻略，你也许看累了冰冷的大片，看类了刻意的摆拍。。。这一次我们尝试用一种及时的公路片，，，，这么多，我在测试呢。。。",   --攻略内容
 
 "images":[
 {"imageName":"PHOTO_20150102",  "imageURL":" http://hiphotos.baidu.com/lvpics/pic/item/73ca5910b8217aa4c3ce79a8.jpg"}
 ]                                  --攻略图片
 "user":{
 "userName":"途乐Man" ,
 "userId":101,
 "userIcon":" http://qlogo3.store.qq.com/qzone/641384094/641384094/100?1356670743 "
 }       --用户信息
 }
*/