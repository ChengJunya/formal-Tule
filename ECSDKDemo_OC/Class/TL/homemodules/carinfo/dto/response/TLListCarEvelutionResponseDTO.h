//
//  TLListCarEvelutionResponseDTO.h
//  TL
//
//  Created by Rainbow on 3/29/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"
#import "TLListCartEvelutionResultDTO.h"
@interface TLListCarEvelutionResponseDTO : ResponseDTO
@property (nonatomic,copy) TLListCartEvelutionResultDTO *result;
@end
