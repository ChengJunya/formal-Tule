//
//  RegResponseDTO.h
//  alijk
//
//  Created by easy on 14/7/28.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import "BaseDTOModel.h"
#import "TLRegDTO.h"
@interface RegResponseDTO : ResponseDTO
@property (nonatomic,copy) TLRegDTO *result;
@end
