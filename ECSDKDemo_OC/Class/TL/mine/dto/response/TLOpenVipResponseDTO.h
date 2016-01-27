//
//  TLOpenVipResponseDTO.h
//  TL
//
//  Created by Rainbow on 4/27/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"
#import "TLOpenVipResultDTO.h"
@interface TLOpenVipResponseDTO : ResponseDTO
@property (nonatomic,copy) TLOpenVipResultDTO *result;
@end
