//
//  TLTripDetailResponseDTO.h
//  TL
//
//  Created by Rainbow on 3/17/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "BaseDTOModel.h"
#import "TLTripDetailDTO.h"
@interface TLTripDetailResponseDTO : ResponseDTO
@property (nonatomic,copy) TLTripDetailDTO *result;
@end
