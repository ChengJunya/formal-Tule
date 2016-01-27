//
//  TLViewCarRectResponseDTO.h
//  TL
//
//  Created by Rainbow on 3/29/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"
#import "TLViewCarRectResultDTO.h"
@interface TLViewCarRectResponseDTO : ResponseDTO
@property (nonatomic,copy) TLViewCarRectResultDTO *result;
@end
