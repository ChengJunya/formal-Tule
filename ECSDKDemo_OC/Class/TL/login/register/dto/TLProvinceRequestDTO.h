//
//  TLProvinceRequestDTO.h
//  TL
//
//  Created by Rainbow on 3/8/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "BaseDTOModel.h"
#import "TLRegDTO.h"
@interface TLProvinceRequestDTO : RequestDTO
@property (nonatomic,copy) TLRegDTO *result;
@end
