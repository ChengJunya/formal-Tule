//
//  TLResponseDTO.h
//  TL
//
//  Created by Rainbow on 4/17/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"

@interface TLResponseDTO : ResponseDTO
@property (nonatomic,copy) JSONModel *result;
@end
