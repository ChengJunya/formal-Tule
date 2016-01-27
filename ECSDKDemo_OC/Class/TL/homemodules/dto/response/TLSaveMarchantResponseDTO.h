//
//  TLSaveMarchantResponseDTO.h
//  TL
//
//  Created by YONGFU on 5/31/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"
#import "TLSaveMarchantResultDTO.h"
@interface TLSaveMarchantResponseDTO : ResponseDTO
@property (nonatomic,copy) TLSaveMarchantResultDTO*result;
@end
