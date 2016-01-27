//
//  TLActivityParticipateRequestDTO.h
//  TL
//
//  Created by Rainbow on 3/20/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"

@interface TLActivityParticipateRequestDTO : RequestDTO
@property (nonatomic,copy) NSString *activityId;// 活动编号
@property (nonatomic,copy) NSString *loginId;//  用户登陆ID
@end


/*
 activityId
 String
 是
 活动编号
 loginId
 String
 是
 用户登陆ID
*/