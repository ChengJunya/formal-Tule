//
//  TLAddBookNodeResponseDTO.h
//  TL
//
//  Created by Rainbow on 3/17/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "BaseDTOModel.h"
#import "TLAddBookNodeResultDTO.h"
@interface TLAddBookNodeResponseDTO : ResponseDTO
@property (nonatomic,copy) TLAddBookNodeResultDTO *result;
@end
