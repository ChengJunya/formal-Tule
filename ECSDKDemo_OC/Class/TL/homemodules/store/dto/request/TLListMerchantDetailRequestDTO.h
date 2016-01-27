//
//  TLListMerchantDetailRequestDTO.h
//  TL
//
//  Created by Rainbow on 4/1/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"

@interface TLListMerchantDetailRequestDTO : RequestDTO
@property(nonatomic,copy) NSString *merchantId;
@property(nonatomic,copy) NSString *dataType;
@end
