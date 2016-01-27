//
//  TLSysMessageListResponseDTO.h
//  TL
//
//  Created by YONGFU on 5/31/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"
#import "TLSysMEssageListResultDTO.h"
@interface TLSysMessageListResponseDTO : ResponseDTO
@property (nonatomic,strong) TLSysMEssageListResultDTO *result;
@end
