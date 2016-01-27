//
//  TLListMerchantDetailResponseDTO.h
//  TL
//
//  Created by Rainbow on 4/1/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"
#import "TLListMerchantDetailResultDTO.h"
@interface TLListMerchantDetailResponseDTO : ResponseDTO
@property (nonatomic,copy) TLListMerchantDetailResultDTO *result;
@end
