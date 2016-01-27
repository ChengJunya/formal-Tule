//
//  TLSaveGroupResponseDTO.h
//  TL
//
//  Created by Rainbow on 5/6/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"
#import "TLSaveGroupResultDTO.h"
@interface TLSaveGroupResponseDTO : ResponseDTO
@property (nonatomic,copy) TLSaveGroupResultDTO *result;
@end
