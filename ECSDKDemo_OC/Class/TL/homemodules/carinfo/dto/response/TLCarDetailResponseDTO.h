//
//  TLCarDetailResponseDTO.h
//  TL
//
//  Created by Rainbow on 3/29/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"
#import "TLCarDEtailResultDTO.h"
@interface TLCarDetailResponseDTO : ResponseDTO
@property (nonatomic,copy) TLCarDEtailResultDTO *result;
@end
