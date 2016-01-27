//
//  TLProvinceResultDTO.h
//  TL
//
//  Created by Rainbow on 3/8/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "JSONModel.h"
#import "TLProvinceDTO.h"
@interface TLProvinceResultDTO : JSONModel
@property (nonatomic,strong) NSArray<TLProvinceDTO> *data;
@end
