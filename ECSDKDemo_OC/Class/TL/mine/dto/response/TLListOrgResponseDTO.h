//
//  TLListOrgResponseDTO.h
//  TL
//
//  Created by Rainbow on 5/3/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"
#import "TLListOrgResultDTO.h"
@interface TLListOrgResponseDTO : ResponseDTO
@property (nonatomic,copy) TLListOrgResultDTO *result;
@end
