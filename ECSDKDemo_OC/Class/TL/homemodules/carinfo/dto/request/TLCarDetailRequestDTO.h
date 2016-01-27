//
//  TLCarDetailRequestDTO.h
//  TL
//
//  Created by Rainbow on 3/29/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"

@interface TLCarDetailRequestDTO : RequestDTO
@property (nonatomic,copy) NSString *carId;
@property (nonatomic,copy) NSString *dataType;
@end


/*
 
 carId
 String
 是
 车型编号
 */