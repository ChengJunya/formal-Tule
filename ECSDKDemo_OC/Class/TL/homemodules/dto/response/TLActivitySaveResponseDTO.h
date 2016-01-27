//
//  TLActivitySaveResponseDTO.h
//  TL
//
//  Created by Rainbow on 3/20/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"
#import "TLActivitySaveResultDTO.h"
@interface TLActivitySaveResponseDTO : ResponseDTO
@property (nonatomic,copy) TLActivitySaveResultDTO *result;
@end
