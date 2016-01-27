//
//  TLHomeImageResponseDTO.h
//  TL
//
//  Created by Rainbow on 3/8/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "BaseDTOModel.h"
#import "TLHomeImageResultDTO.h"
@interface TLHomeImageResponseDTO : ResponseDTO
@property (nonatomic,copy) TLHomeImageResultDTO* result;
@end
