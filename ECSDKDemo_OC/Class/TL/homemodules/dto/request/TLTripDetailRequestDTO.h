//
//  TLTripDetailRequestDTO.h
//  TL
//
//  Created by Rainbow on 3/17/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "BaseDTOModel.h"

@interface TLTripDetailRequestDTO : RequestDTO
@property(nonatomic,copy) NSString *travelId;
@property(nonatomic,copy) NSString *type;
@property(nonatomic,copy) NSString *dataType;

@end
