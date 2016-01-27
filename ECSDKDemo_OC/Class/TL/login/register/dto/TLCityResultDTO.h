//
//  TLCityResultDTO.h
//  TL
//
//  Created by Rainbow on 3/8/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "JSONModel.h"
#import "TLCityDTO.h"
@interface TLCityResultDTO : JSONModel
@property (nonatomic,strong) NSArray<TLCityDTO> *data;
@property (nonatomic,strong) NSString *provinceId;
@property (nonatomic,strong) NSString *provinceName;

@end
