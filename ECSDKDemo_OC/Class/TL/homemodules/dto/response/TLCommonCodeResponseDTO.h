//
//  TLCommonCodeResponseDTO.h
//  TL
//
//  Created by Rainbow on 3/20/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"
#import "TLCommonCodeResultDTO.h"
@interface TLCommonCodeResponseDTO : ResponseDTO
@property (nonatomic,copy) TLCommonCodeResultDTO *result;
@end
