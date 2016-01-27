//
//  TLTripListResponseDTO.h
//  TL
//
//  Created by Rainbow on 3/17/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "BaseDTOModel.h"
#import "TLTripListResultDTO.h"
@interface TLTripListResponseDTO : ResponseDTO
@property (nonatomic,copy) TLTripListResultDTO *result;
@end
