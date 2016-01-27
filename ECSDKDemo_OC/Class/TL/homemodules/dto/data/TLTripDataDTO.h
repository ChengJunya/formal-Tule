//
//  TLTripDataDTO.h
//  TL
//
//  Created by Rainbow on 3/17/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "JSONModel.h"
#import "TLTripTravelDTO.h"
//攻略等列表信息
@protocol TLTripDataDTO

@end

@interface TLTripDataDTO : JSONModel
@property (nonatomic,copy) NSString *travelId;
@property (nonatomic,copy) NSString *cityId;
@property (nonatomic,copy) NSString *cityName;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *createTime;
@property (nonatomic,copy) NSString *viewCount;
@property (nonatomic,copy) NSString *userIcon;
@property (nonatomic,copy) NSString *userPic;
@property (nonatomic,copy) NSArray<TLTripTravelDTO> *travel;

@end
/**
 
 {
 data:[
 {
 
 "travelId":"101",    --攻略编号
 "touristSpot":"北京-故宫",            --景点名称
 "title":"有一个地方叫【北京故宫】",     --名称
 "publishTime":"2014-1-12 00:00:00",         --时间
 "praiseCount":2221                 --点赞次数
 "userIcon":"http://www.abc.com/aaaa.png",  --用户头像图片地址
 "userPic":"http://www.abc.com/aaaa.png",   --用户攻略，路书，游记中上传的图片地址，默认取得是首张
 注：travel节点是可选的节点，当请求参数的type类型为：2:路书时才会出现travel节点
 "travel":[
 --路书开始节点
 {
 "title":"东川红土地",
 "content":"迎着清晨的第一缕阳光。。"
 }
 --路书结束节点
 {
 "title":"成都-昭通",
 "content":"终于结束啦！！！"
 }
 ]}
 
 ]
 }
 */