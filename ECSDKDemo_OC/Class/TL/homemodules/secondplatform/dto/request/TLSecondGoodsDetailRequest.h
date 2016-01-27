//
//  TLSecondGoodsDetailRequest.h
//  TL
//
//  Created by Rainbow on 3/31/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"

@interface TLSecondGoodsDetailRequest : RequestDTO
@property(nonatomic,copy) NSString *goodsId;
@property(nonatomic,copy) NSString *dataType;
@end
