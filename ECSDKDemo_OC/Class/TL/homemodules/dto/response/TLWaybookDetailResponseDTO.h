//
//  TLWaybookDetailResponseDTO.h
//  TL
//
//  Created by Rainbow on 3/17/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "BaseDTOModel.h"
#import "TLWayBookDetailDTO.h"
@interface TLWaybookDetailResponseDTO : ResponseDTO
@property (nonatomic,copy) TLWayBookDetailDTO *result;
@end
