//
//  TLActivityDetailRequestDTO.h
//  TL
//
//  Created by Rainbow on 3/20/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"

@interface TLActivityDetailRequestDTO : RequestDTO
@property (nonatomic,copy) NSString *activityId;// 活动编号
@property (nonatomic,copy) NSString *dataType;


@end
