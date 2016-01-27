//
//  TLProvinceResponseDTO.h
//  TL
//
//  Created by Rainbow on 3/8/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "BaseDTOModel.h"
#import "TLProvinceResultDTO.h"
@interface TLProvinceResponseDTO : ResponseDTO
@property (nonatomic,copy) TLProvinceResultDTO *result;
@end
