//
//  TLTlbChanrgeResponseDTO.h
//  TL
//
//  Created by YONGFU on 8/12/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"
#import "TLTlbChargeResultDTO.h"
@interface TLTlbChanrgeResponseDTO : ResponseDTO
@property (nonatomic,copy) TLTlbChargeResultDTO *result;
@end
