//
//  TLActivityDTO.h
//  TL
//
//  Created by Rainbow on 3/20/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "JSONModel.h"

@protocol TLActivityDTO



@end

@interface TLActivityDTO : JSONModel
@property (nonatomic,copy) NSString *title;//--活动标题
@property (nonatomic,copy) NSString *destnation;//目的地
@property (nonatomic,copy) NSString *costAverage;//人均消费
@property (nonatomic,copy) NSString *personNum;//活动人数
@property (nonatomic,copy) NSString *desc;//内容描述
@property (nonatomic,copy) NSString *viewCount;//浏览人数
@property (nonatomic,copy) NSString *commentCount;//评论人数
@property (nonatomic,copy) NSString *activityImage;//-活动首页的图片
@property (nonatomic,copy) NSString *activityId;//活动id
@property (nonatomic,copy) NSString *enrollCount;//当前参与人数
@property (nonatomic,copy) NSString *publishTime;//创建时间






@end



/*
 {
 " title":"看看内蒙古的天空",      --活动标题
 "destnation":"故宫"                --目的地
 "costAverage":200                 --人均消费
 "personNum":"1"                   --活动人数
 "desc":"天空真的很蓝"            --内容描述
 "viewCount":300                   --浏览人数
 "commentCount":200           --评论人数
 "activityImage":"http://www.test.com/a.jpg"    --活动首页的图片
 }
 */