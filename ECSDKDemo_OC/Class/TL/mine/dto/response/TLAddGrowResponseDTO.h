//
//  TLAddGrowResponseDTO.h
//  TL
//
//  Created by Rainbow on 4/27/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"
#import "TLAddGrowResultDTO.h"
@interface TLAddGrowResponseDTO : ResponseDTO
@property (nonatomic,copy) TLAddGrowResultDTO *result;
@end
