//
//  TLListSecondGoodsResponse.h
//  TL
//
//  Created by Rainbow on 3/31/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"
#import "TLListSecondGoodsResult.h"
@interface TLListSecondGoodsResponse : ResponseDTO
@property (nonatomic,copy) TLListSecondGoodsResult *result;
@end
