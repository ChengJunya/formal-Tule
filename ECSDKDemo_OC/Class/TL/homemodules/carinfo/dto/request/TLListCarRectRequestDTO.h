//
//  TLListCarRectRequestDTO.h
//  TL
//
//  Created by Rainbow on 3/29/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "TLTripListRequestDTO.h"

@interface TLListCarRectRequestDTO : TLTripListRequestDTO

@property (nonatomic,copy) NSString *carType;
@property (nonatomic,copy) NSString *priceRange;

@end
