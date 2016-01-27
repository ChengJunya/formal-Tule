//
//  TLViewGroupResponseDTO.h
//  TL
//
//  Created by Rainbow on 5/6/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"
#import "TLViewGroupResultDTO.h"
@interface TLViewGroupResponseDTO : ResponseDTO
@property (nonatomic,copy) TLViewGroupResultDTO *result;
@end
