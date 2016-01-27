//
//  TLUserViewResponseDTO.h
//  TL
//
//  Created by Rainbow on 4/8/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"
#import "TLUserViewResultDTO.h"
@interface TLUserViewResponseDTO : ResponseDTO
@property (nonatomic,copy) TLUserViewResultDTO *result;
@end
