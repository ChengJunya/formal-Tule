//
//  TLTripDetailResultDTO.h
//  TL
//
//  Created by Rainbow on 3/17/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "JSONModel.h"
#import "TLTripDetailDTO.h"
@interface TLTripDetailResultDTO : JSONModel
@property (nonatomic,copy) TLTripDetailDTO *data;
@end
