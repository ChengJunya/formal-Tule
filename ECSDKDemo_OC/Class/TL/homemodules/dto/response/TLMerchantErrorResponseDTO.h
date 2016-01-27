//
//  TLMerchantErrorResponseDTO.h
//  TL
//
//  Created by YONGFU on 5/31/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"
#import "TLMerchantResultDTO.h"


@interface TLMerchantErrorResponseDTO : ResponseDTO
@property (nonatomic,copy) TLMerchantResultDTO *result;
@end
