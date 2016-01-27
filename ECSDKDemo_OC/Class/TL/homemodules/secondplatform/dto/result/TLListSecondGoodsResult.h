//
//  TLListSecondGoodsResult.h
//  TL
//
//  Created by Rainbow on 3/31/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "JSONModel.h"
#import "TLSecondGoodsDTO.h"
@interface TLListSecondGoodsResult : JSONModel
@property (nonatomic,copy) NSArray<TLSecondGoodsDTO> *data;
@end
