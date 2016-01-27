//
//  TLDistrictResponseDTO.h
//  TL
//
//  Created by Rainbow on 3/8/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "BaseDTOModel.h"
#import "TLDistrictResultDTO.h"
@interface TLDistrictResponseDTO : ResponseDTO
@property (nonatomic,copy) TLDistrictResultDTO *result;

@end
