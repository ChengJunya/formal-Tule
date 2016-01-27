//
//  TLIsTopResponseDTO.h
//  TL
//
//  Created by Rainbow on 3/20/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"
#import "TLIsTopResultDTO.h"
@interface TLIsTopResponseDTO : ResponseDTO
@property (nonatomic,copy) TLIsTopResultDTO *result;
@end
