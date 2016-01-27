//
//  TLSaveCarResponseDTO.h
//  TL
//
//  Created by Rainbow on 3/29/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"
#import "TLSaveCarResultDTO.h"
@interface TLSaveCarResponseDTO : ResponseDTO
@property (nonatomic,copy) TLSaveCarResultDTO *result;
@end
