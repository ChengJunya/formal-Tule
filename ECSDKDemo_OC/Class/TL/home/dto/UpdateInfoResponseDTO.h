//
//  UpdateInfoResponseDTO.h
//  alijk
//
//  Created by easy on 14/7/28.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import "BaseDTOModel.h"
#import "UpdateInfoDTO.h"
@interface UpdateInfoResponseDTO : ResponseDTO

@property (nonatomic,copy) UpdateInfoDTO *result;


@end
