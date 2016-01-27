//
//  TLActivityListResponseDTO.h
//  TL
//
//  Created by Rainbow on 3/20/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"
#import "TLActivityListResultDTO.h"
@interface TLActivityListResponseDTO : ResponseDTO
@property (nonatomic,copy) TLActivityListResultDTO *result;
@end
