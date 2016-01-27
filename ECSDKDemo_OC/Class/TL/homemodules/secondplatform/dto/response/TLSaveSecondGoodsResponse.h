//
//  TLSaveSecondGoodsResponse.h
//  TL
//
//  Created by Rainbow on 3/31/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"
#import "TLSaveSecondGoodsResult.h"
@interface TLSaveSecondGoodsResponse : ResponseDTO
@property (nonatomic,copy) TLSaveSecondGoodsResult *result;
@end
