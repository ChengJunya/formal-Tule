//
//  TLWayBookDetailRequestDTO.h
//  TL
//
//  Created by Rainbow on 3/17/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "BaseDTOModel.h"

@interface TLWayBookDetailRequestDTO : RequestDTO
//id路书编号
@property(nonatomic,copy) NSString *travelId;
@property(nonatomic,copy) NSString *dataType;
@end
