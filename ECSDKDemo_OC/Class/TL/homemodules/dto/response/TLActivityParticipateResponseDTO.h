//
//  TLActivityParticipateResponseDTO.h
//  TL
//
//  Created by Rainbow on 3/20/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"
#import "TLActivityParticipateResultDTO.h"
@interface TLActivityParticipateResponseDTO : ResponseDTO
@property (nonatomic,copy) TLActivityParticipateResultDTO *result;
@end
