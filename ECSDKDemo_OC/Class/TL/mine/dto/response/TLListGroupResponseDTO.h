//
//  TLListGroupResponseDTO.h
//  TL
//
//  Created by Rainbow on 5/3/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"
#import "TLListGroupResultDTO.h"
@interface TLListGroupResponseDTO : ResponseDTO
@property (nonatomic,copy) TLListGroupResultDTO *result;
@end
