//
//  TLCommentListResponseDTO.h
//  TL
//
//  Created by Rainbow on 3/17/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "BaseDTOModel.h"
#import "TLCommentListResultDTO.h"
@interface TLCommentListResponseDTO : ResponseDTO
@property (nonatomic,copy) TLCommentListResultDTO *result;
@end
