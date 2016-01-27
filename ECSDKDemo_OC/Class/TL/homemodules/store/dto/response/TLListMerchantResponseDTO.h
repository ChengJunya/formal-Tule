//
//  TLListMerchantResponseDTO.h
//  TL
//
//  Created by Rainbow on 4/1/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"
#import "TLListMerchantResultDTO.h"
@interface TLListMerchantResponseDTO : ResponseDTO
@property (nonatomic,copy) TLListMerchantResultDTO *result;
@end
