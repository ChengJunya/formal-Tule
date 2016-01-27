//
//  TLActivityDetailResponseDTO.h
//  TL
//
//  Created by Rainbow on 3/20/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"
#import "TLActivityDetailResultDTO.h"
@interface TLActivityDetailResponseDTO : ResponseDTO
@property (nonatomic,copy) TLActivityDetailResultDTO *result;
@end
