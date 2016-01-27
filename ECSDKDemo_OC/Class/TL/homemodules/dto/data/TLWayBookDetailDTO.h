//
//  TLWayBookDetailDTO.h
//  TL
//
//  Created by Rainbow on 3/17/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "JSONModel.h"
#import "TLTripDetailDTO.h"
#import "TLWayBookNodeDTO.h"
@interface TLWayBookDetailDTO : TLTripDetailDTO

@property (nonatomic,copy) NSArray<TLWayBookNodeDTO> *travel;

@end
/*
 
 注：当resultType为1时才会有值
 {
 
 "travelId":"101",    --编号
 "cityId":"1"                --地市编号
 "cityName":"北京",            --地市名称
 "title":"有一个地方叫【北京故宫】",     --名称
 "publishTime":"2014-1-12 00:00:00",         --时间
 "praiseCount":2221,                 --点赞次数
 "viewCount":1234,                  --浏览次数
 "commentCount":1232,          --评论次数
 
 "collectCount":1211,               --收藏次数
 
 "content":"这一次简短的攻略，你也许看累了冰冷的大片，看类了刻意的摆拍。。。这一次我们尝试用一种及时的公路片，，，，这么多，我在测试呢。。。",   --攻略内容
 
 "image":  {"imageName":"PHOTO_20150102",  "imageURL":" http://hiphotos.baidu.com/lvpics/pic/item/73ca5910b8217aa4c3ce79a8.jpg "}
 "user":{
 "userName":"途乐Man" ,
 "userId":101,
 "userIcon":" http://qlogo3.store.qq.com/qzone/641384094/641384094/100?1356670743 "
 }       --用户信息
 
 "travel":[
 --路书开始节点
 {
 "title":"东川红土地",
 "content":"迎着清晨的第一缕阳光。。"
 "createTime":"2015-01-03 00:00:00",
 "images":[
 {          "imageName":"PHOTO_20150102",
 "imageURL":"http://hiphotos.baidu.com/lvpics/pic/item/73ca5910b8217aa4c3ce79a8.jpg"
 }
 ]                                  --路书节点图片
 
 }
 --路书结束节点
 {
 "title":"成都-昭通",
 "content":"终于结束啦！！！" ，
 "createTime":"2015-03-03 00:00:00",
 "images":[
 {          "imageName":"PHOTO_20150102",
 "imageURL":"http://hiphotos.baidu.com/lvpics/pic/item/73ca5910b8217aa4c3ce79a8.jpg"
 }
 ]                                  --路书节点图片
 
 }
 ]
 
 }
 */