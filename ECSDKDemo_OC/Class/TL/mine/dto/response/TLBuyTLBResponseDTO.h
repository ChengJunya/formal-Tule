//
//  TLBuyTLBResponseDTO.h
//  TL
//
//  Created by Rainbow on 4/27/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"
#import "TLBuyTLBResultDTO.h"
@interface TLBuyTLBResponseDTO : ResponseDTO
@property (nonatomic,copy) TLBuyTLBResultDTO *result;
@end
