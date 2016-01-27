//
//  TLViewOrgResponseDTO.h
//  TL
//
//  Created by Rainbow on 5/3/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"
#import "TLViewOrgResultDTO.h"
@interface TLViewOrgResponseDTO : ResponseDTO
@property (nonatomic,copy) TLViewOrgResultDTO *result;
@end
