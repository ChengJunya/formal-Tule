//
//  TLNewsListResponseDTO.h
//  TL
//
//  Created by Rainbow on 4/27/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"
#import "TLNewsListResultDTO.h"
@interface TLNewsListResponseDTO : ResponseDTO
@property (nonatomic,copy) TLNewsListResultDTO *result;
@end
