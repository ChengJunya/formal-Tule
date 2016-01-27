//
//  TLListCartResponseDTO.h
//  TL
//
//  Created by Rainbow on 3/29/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"
#import "TLListCarResultDTO.h"
@interface TLListCartResponseDTO : ResponseDTO
@property (nonatomic,copy) TLListCarResultDTO *result;
@end
