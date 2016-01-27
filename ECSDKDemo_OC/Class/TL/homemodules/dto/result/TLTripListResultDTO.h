//
//  TLTripListResultDTO.h
//  TL
//
//  Created by Rainbow on 3/17/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "JSONModel.h"
#import "TLTripDataDTO.h"
@interface TLTripListResultDTO : JSONModel
@property (nonatomic,copy)NSArray<TLTripDataDTO> *data;
@end
