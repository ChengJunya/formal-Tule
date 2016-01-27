//
//  TLCartListResponseDTO.h
//  TL
//
//  Created by Rainbow on 3/20/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"
#import "TLCarListResultDTO.h"
@interface TLCartListResponseDTO : ResponseDTO
@property (nonatomic,copy) TLCarListResultDTO *result;
@end
