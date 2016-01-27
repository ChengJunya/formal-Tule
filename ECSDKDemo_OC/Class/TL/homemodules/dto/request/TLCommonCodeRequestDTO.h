//
//  TLCommonCodeRequestDTO.h
//  TL
//
//  Created by Rainbow on 3/20/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"

@interface TLCommonCodeRequestDTO : RequestDTO
@property (nonatomic,copy) NSString *type;//码表类型： activtyPersonNum：活动人数码表
@end
