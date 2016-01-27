//
//  TLActivitySaveRequestDTO.h
//  TL
//
//  Created by Rainbow on 3/20/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"

@interface TLActivitySaveRequestDTO : RequestDTO
@property (nonatomic,copy) NSString *title;// 标题
@property (nonatomic,copy) NSString *cityId;// 城市编号

@property (nonatomic,copy) NSString *costAverage;//人均费用
@property (nonatomic,copy) NSString *personNum;// 活动人数 , 1: 0-10人 用码表接口返回   activtyNum
@property (nonatomic,copy) NSString *desc;// 活动描述
@property (nonatomic,copy) NSArray *userImage;//活动图片
@property (nonatomic,copy) NSString *isTop;//是否置顶  1：置顶，0：不置顶
@property (nonatomic,copy) NSString *startDate;
@property (nonatomic,copy) NSString *endDate;
@property(nonatomic,copy) NSString *operateType;//1-add 2-modify
@property(nonatomic,copy) NSString *objId;//


@end


/*





 
 isTop
 String
 是
 是否置顶  1：置顶，0：不置顶
*/