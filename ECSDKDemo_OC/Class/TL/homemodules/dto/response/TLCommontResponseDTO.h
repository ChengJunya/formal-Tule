//
//  TLCommontResponseDTO.h
//  TL
//
//  Created by Rainbow on 3/17/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "BaseDTOModel.h"
#import "TLCommentResultDTO.h"
@interface TLCommontResponseDTO : ResponseDTO
@property (nonatomic,copy) TLCommentResultDTO *result;
@end
