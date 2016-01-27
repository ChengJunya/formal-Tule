//
//  TLListMerchantResultDTO.h
//  TL
//
//  Created by Rainbow on 4/1/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "JSONModel.h"

#import "TLStoreDTO.h"
@interface TLListMerchantResultDTO : JSONModel
@property (nonatomic,copy) NSArray<TLStoreDTO> *data;
@end



