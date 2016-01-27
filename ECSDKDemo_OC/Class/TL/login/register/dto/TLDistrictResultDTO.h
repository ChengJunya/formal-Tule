//
//  TLDistrictResultDTO.h
//  TL
//
//  Created by Rainbow on 3/8/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "JSONModel.h"
#import "TLDistrictDTO.h"
@interface TLDistrictResultDTO : JSONModel
@property (nonatomic,strong) NSArray<TLDistrictDTO> *data;
@property (nonatomic,strong) NSString *cityId;
@property (nonatomic,strong) NSString *cityName;
@end
