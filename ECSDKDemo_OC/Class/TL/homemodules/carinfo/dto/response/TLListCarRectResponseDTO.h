//
//  TLListCarRectResponseDTO.h
//  TL
//
//  Created by Rainbow on 3/29/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"
#import "TLListCarRectResultDTO.h"
@interface TLListCarRectResponseDTO : ResponseDTO
@property (nonatomic,copy) TLListCarRectResultDTO *result;
@end
