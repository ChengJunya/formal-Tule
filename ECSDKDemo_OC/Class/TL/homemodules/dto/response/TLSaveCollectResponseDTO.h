//
//  TLSaveCollectResponseDTO.h
//  TL
//
//  Created by Rainbow on 3/22/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"
#import "TLSsaveCollectResultDTO.h"
@interface TLSaveCollectResponseDTO : ResponseDTO
@property(nonatomic,copy)TLSsaveCollectResultDTO *result;
@end
