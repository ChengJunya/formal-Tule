//
//  TLCityResponseDTO.h
//  TL
//
//  Created by Rainbow on 3/8/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "BaseDTOModel.h"
#import "TLCityResultDTO.h"
@interface TLCityResponseDTO : ResponseDTO
@property (nonatomic,copy) TLCityResultDTO *result;
@end
