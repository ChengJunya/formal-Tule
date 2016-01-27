//
//  TLSecondGoodsDetailResponse.h
//  TL
//
//  Created by Rainbow on 3/31/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"
#import "TLSecondGoodsResult.h"
@interface TLSecondGoodsDetailResponse : ResponseDTO
@property (nonatomic,copy)TLSecondGoodsResult *result;
@end
