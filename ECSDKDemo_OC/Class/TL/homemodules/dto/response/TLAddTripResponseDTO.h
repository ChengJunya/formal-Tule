//
//  TLAddTripResponseDTO.h
//  TL
//
//  Created by Rainbow on 3/17/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "BaseDTOModel.h"
#import "TLAddTripResultDTO.h"
@interface TLAddTripResponseDTO : ResponseDTO
@property (nonatomic,copy) TLAddTripResultDTO *result;
@end
